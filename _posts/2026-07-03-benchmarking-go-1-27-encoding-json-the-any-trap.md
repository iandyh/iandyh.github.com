---
layout: post
title: "Benchmarking Go 1.27's encoding/json: The `any` Trap"
description: "A benchmark of Go 1.27's jsonv2-backed encoding/json, why decoding into any can be slower than v1, and when v2's promised speedup shows up."
category: programming
tags: [go, json, performance, benchmark]
---

{% include JB/setup %}

## Background

I'm developing software that needs strong JSON library performance, especially on the decoding side.

`encoding/json/v2` has been experimental in Go for almost a year. It started from this [issue](https://github.com/golang/go/issues/71497). Starting in Go 1.25, it became part of the experimental feature set. In Go 1.27 (coming this August), v2 becomes the default backend for `encoding/json`.

## Questions in my mind

- Is v2 faster? This is easy to answer.
- Is the Go 1.27 `encoding/json` compatibility path faster? Considering the breaking changes in v2, and considering Go's compatibility promise, will compatibility affect performance?
- How does it compare to other well-known libraries, such as `goccy/go-json`?

## Benchmark & Results

I asked GPT-5.5 to run the benchmark. The test uses Go 1.27rc1 and runs on my MacBook Air M2 with 24 GB of memory. The test data is NDJSON with 100,000 entries. A sample from the data looks like this:

```json
{"type":"request","connection_id":996,"timestamp":"2026-07-01T00:42:05.503678Z","log_type":"DownstreamStart","http":{"version":"HTTP/1.1","method":"GET","scheme":"http","authority":"testhttp:8080","path":"/api/v1/resource/4"},"headers":{"x-api-key":["rqt_api_dummy-apikey-local"],"x-forwarded-host":["testhttp:8080"],"x-forwarded-port":["8080"],"x-forwarded-proto":["http"],"x-forwarded-scheme":["http"],"x-real-ip":["172.18.0.1"]},"body":{}}
```

The benchmark runs four cases:

- `encoding/json/v2` native: directly import v2 and run decode and encode.
- `encoding/json`: in Go 1.27rc1, this is backed by the v2 implementation with compatibility support. That means v2 can make breaking changes, but as long as you are not using the v2 import path, behavior should remain compatible with v1.
- `encoding/json` with `GOEXPERIMENT=nojsonv2`: this is a build-time Go experiment setting that makes `encoding/json` use the legacy v1 implementation.
- `goccy/go-json`: a third-party library that does not rely on `encoding/json`. It is included for comparison.

The benchmark simply decodes the JSON into an `any` object.

```go
var v any
if err := c.unmarshal(record, &v); err != nil {
    return err
}
```

### Decode results

| Rank | Library                          | Total time | Mean/pass |   Throughput | ns/record | Allocated bytes/record | Allocs/record | Relative to v1 |
| :--- | -------------------------------- | ---------: | --------: | -----------: | --------: | ---------------------: | ------------: | -------------: |
| 1    | `encoding/json/v2 native`        |      983ms |     197ms | 213.32 MiB/s |      1967 |                   1755 |         53.04 |          1.76x |
| 2    | `goccy/go-json`                  |      994ms |     199ms | 211.06 MiB/s |      1988 |                   2797 |         83.38 |          1.74x |
| 3    | `encoding/json (nojsonv2 v1)`    |     1.726s |     345ms | 121.55 MiB/s |      3451 |                   2139 |         71.49 |          1.00x |
| 4    | `encoding/json (default jsonv2)` |     2.216s |     443ms |  94.65 MiB/s |      4433 |                   2089 |         69.84 |          0.78x |

### Encode results

| Rank | Library                          | Total time | Mean/pass |   Throughput | ns/record | Allocated bytes/record | Allocs/record | Relative to v1 |
| ---: | -------------------------------- | ---------: | --------: | -----------: | --------: | ---------------------: | ------------: | -------------: |
|    1 | `encoding/json/v2 native`        |      890ms |     178ms | 235.71 MiB/s |      1780 |                    565 |         10.99 |          1.41x |
|    2 | `goccy/go-json`                  |      991ms |     198ms | 211.73 MiB/s |      1981 |                   1334 |          5.84 |          1.26x |
|    3 | `encoding/json (default jsonv2)` |     1.115s |     223ms | 188.15 MiB/s |      2230 |                    677 |         17.98 |          1.12x |
|    4 | `encoding/json (nojsonv2 v1)`    |     1.252s |     250ms | 167.51 MiB/s |      2504 |                   1748 |         39.74 |          1.00x |

At first glance, when using `encoding/json` with the default jsonv2 backend, decoding is slower than legacy v1 in this benchmark. It is only about 80% of legacy v1 throughput. For encoding, the compatibility path is modestly faster than v1 in this run.

From the Go 1.27 [release notes](https://go.dev/doc/go1.27):

> Marshal performance is broadly at parity with the previous implementation, while unmarshal performance is significantly faster.

That does not match this benchmark. What happened?

## Why?

So I asked GPT-5.5 to analyze why this happens. This is what it found.

We start from profiling:

| Function                                       |  Flat | Flat % | Cumulative | Cumulative % | Meaning                                    |
| ---------------------------------------------- | ----: | -----: | ---------: | -----------: | ------------------------------------------ |
| `encoding/json/v2.makeInterfaceArshaler.func2` | 390ms |  3.10% |     10.32s |       82.10% | Generic interface decode path.             |
| `encoding/json/v2.makeMapArshaler.func3`       | 180ms |  1.43% |     10.18s |       80.99% | Generic map decode path.                   |
| `encoding/json/v2.makeStringArshaler.func2`    | 180ms |  1.43% |      2.29s |       18.22% | Generic string decode path.                |
| `runtime.mallocgc`                             | 270ms |  2.15% |      2.19s |       17.42% | Allocation and GC work.                    |
| `encoding/json/v2.makeSliceArshaler.func3`     |  90ms |  0.72% |      2.13s |       16.95% | Generic slice decode path.                 |
| `encoding/json/v2.newAddressableValue`         |  10ms |  0.08% |      1.64s |       13.05% | Addressable reflection value construction. |
| `reflect.unsafe_New`                           |  50ms |  0.40% |      1.55s |       12.33% | Reflection allocation.                     |
| `reflect.New`                                  |  10ms |  0.08% |      1.50s |       11.93% | Reflection allocation wrapper.             |
| `reflect.Value.Set`                            |  80ms |  0.64% |      1.35s |       10.74% | Reflection assignment.                     |
| `reflect.Value.assignTo`                       | 170ms |  1.35% |      1.29s |       10.26% | Reflection conversion and assignment.      |
| `reflect.Value.SetMapIndex`                    | 130ms |  1.03% |      1.22s |        9.71% | Reflection map insertion.                  |

Pay attention to the extra reflection cost. This is one of the main places where the additional decode time is spent.

The extra decode cost mostly comes from the compatibility path falling out of the optimized `any` decoder and into generic reflection-heavy decoding.

Native v2 has an optimized `any` path, but it only applies when duplicate-name compatibility is disabled:

```go
// encoding/json/v2/arshal_default.go
if optimizeCommon && t == anyType && !uo.Flags.Get(jsonflags.AllowDuplicateNames|jsonflags.FormatTag) && (uo.Unmarshalers == nil || !uo.Unmarshalers.(*Unmarshalers).fromAny) {
    v, err := unmarshalValueAny(dec, uo)
    if v != nil {
        va.Set(reflect.ValueOf(v))
    }
    return err
}
```

The `encoding/json` v1 compatibility options enable duplicate names:

```go
// encoding/json/internal/jsonflags/flags.go
DefaultV1Flags = 0 |
    AllowDuplicateNames |
    AllowInvalidUTF8 |
    EscapeForHTML |
    EscapeForJS |
    PreserveRawStrings |
    Deterministic |
    FormatNilMapAsNull |
    FormatNilSliceAsNull |
    MatchCaseInsensitiveNames |
    CallMethodsWithLegacySemantics |
    FormatByteArrayAsArray |
    FormatBytesWithLegacySemantics |
    FormatDurationAsNano |
    MatchCaseSensitiveDelimiter |
    MergeWithLegacySemantics |
    OmitEmptyWithLegacySemantics |
    ParseBytesWithLooseRFC4648 |
    ParseTimeWithLooseRFC3339 |
    ReportErrorsWithLegacySemantics |
    StringifyWithLegacySemantics |
    UnmarshalArrayFromAnyLength
```

Because `AllowDuplicateNames` is true, the optimized v2 `any` fast path is skipped. The decoder goes through:

- `encoding/json/v2.makeInterfaceArshaler.func2`
- `encoding/json/v2.makeMapArshaler.func3`
- `reflect.New`
- `reflect.Value.Set`
- `reflect.Value.assignTo`
- `reflect.Value.SetMapIndex`
- arshaler lookup via `internal/sync.HashTrieMap.Load`

Legacy v1 has a direct `any` path for this exact benchmark shape:

```go
// encoding/json/decode.go
// The xxxInterface routines build up a value to be stored
// in an empty interface. They are not strictly necessary,
// but they avoid the weight of reflection in this common case.
func (d *decodeState) valueInterface() (val any)
func (d *decodeState) objectInterface() map[string]any
```

This benchmark decodes every record into `any`, so that difference dominates.

**So decoding into `any` through the compatibility path is the culprit in this benchmark.** Let's ask GPT-5.5 to run another test without decoding into `any`:

| Rank | Library                        |    Time | Mean/pass |   Throughput | ns/record | Allocated bytes/record | Allocs/record | Relative to v1 |
| ---: | ------------------------------ | ------: | --------: | -----------: | --------: | ---------------------: | ------------: | -------------: |
|    1 | encoding/json (default jsonv2) | 14.346s |    2.869s | 152.84 MiB/s |     28691 |                   7149 |        131.42 |          1.69x |
|    2 | encoding/json (nojsonv2 v1)    | 24.203s |    4.841s |  90.59 MiB/s |     48405 |                   8347 |        188.00 |          1.00x |

**This time we see the decode performance gain.** 

While decoding the entire JSON into `any` is quite an extreme case, after running an another benchmark by mixing the proper types and `any`, the slowdown appears when a large share of the decode workload goes through any/interface decoding. For example, with a simple `map[string]any` case:

| Mode                         | ns/op | B/op | allocs/op | vs nojsonv2 v1 |
| ---------------------------- | ----: | ---: | --------: | -------------: |
| `GOEXPERIMENT=nojsonv2` / v1 | 528.8 |  896 |        12 |          1.00x |
| default jsonv2 compatibility | 610.4 |  768 |        12 |   1.15x slower |

On the other hand, when `any` is only a small part of a larger struct, jsonv2 can still outperform `nojsonv2` v1.

### Can we use the fast path?

As we saw above, we cannot use the fast path because of the condition below:

```go
if optimizeCommon && t == anyType && !uo.Flags.Get(jsonflags.AllowDuplicateNames) && uo.Format == "" && (uo.Unmarshalers == nil || !uo.Unmarshalers.(*Unmarshalers).fromAny)
```

Specifically, `AllowDuplicateNames` is true by default. It's tempting to remove it from the condition. However, the comment above this condition clearly says:

```go
// Optimize for the any type if there are no special options.
// We do not care about stringified numbers since JSON strings
// are always unmarshaled into an any value as Go strings.
// Duplicate name check must be enforced since unmarshalValueAny
// does not implement merge semantics.
```

Imagine the case below:

```go
var v any = map[string]any{
    "x": map[string]any{"old": float64(1)},
}
json.Unmarshal([]byte(`{"x":{"new":2}}`), &v)
```

| Path | Result |
| --- | --- |
| `encoding/json` with `GOEXPERIMENT=nojsonv2` | `{"x":{"new":2}}` |
| `encoding/json` default jsonv2 compatibility | `{"x":{"new":2}}` |
| native `encoding/json/v2` | `{"x":{"old":1,"new":2}}` |

In this case, we cannot simply remove the `AllowDuplicateNames` check without changing this behavior.

## Conclusions

At the start, GPT-5.5 chose `any` because the NDJSON data has mixed event shapes. After the analysis, we noticed that decoding into `any` through the compatibility route uses reflection-heavy generic decoding, which adds overhead. So we accidentally found an edge case where the v2-backed compatibility path can be slower than v1.

In another run without decoding into `any`, we saw the struct decode performance gains promised by v2.

If you have a complex data structure, and `any` only occasionally appears in the struct, then the overall performance improvement from v2 can still offset the performance degradation caused by reflection.

In hindsight, you can't blame GPT-5.5 for being lazy. Sometimes, when facing mixed or complex data types, you tend to use `any`. Now we know the cost.

The software I mentioned at the beginning of the post will be released soon as part of [Reqfleet](https://reqfleet.com), the load testing service.
