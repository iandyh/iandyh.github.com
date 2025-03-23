---

layout: post

title: "Meta ServiceLab"

description: ""

category: system

tags: ["papers"]

---

{% include JB/setup %}

This was a paper presented in the 2024 OSDI and won the best paper award.

Servicelab is a load testing platform developed in Meta(Facebook). Not only it can generate the traffic, but also it can make the decisions whether a load test is required, how the load test plan is constructed, and how the results can be interpreted, etc.

Below is a list of features of provided by ServiceLab:

- Traffic recording
- Traffic generation(treadmill)
- It uses DiffSuggester to make the decision whether a load test is needed
- Target service dependency management (User can create a self-contained service env)
- Side effects management （*In ServiceLab, most calls to downstream production services do not incur side effects because they are read-only or idempotent*）.
- Etc

I am particularly interested in how they manage the side effects when using the actual traffic recorded from production:

*Third, for a SUT that potentially can cause side effects on downstream production services, ServiceLab requires the service owner to modify the SUT’s behavior to prevent those side effects. For example, the SUT may use a mock interface of a database so that it writes data to a test database instead of the production database. Moreover, to prevent a SUT from accidentally accessing a production service, the RPC layer can be instructed to block all traffic to production services except those on an allowed list. Mocking or blocking traffic can result in certain code paths not being executed, potentially causing false negatives in testing results. However, § 6.1 shows that the false negative rate of ServiceLab is acceptable.*

Traffic recording part is also pretty interesting. With k8s becoming mainstreaming today, it should be farily simple for other people to replicate. Injecting a sidecar container and take the snapshots of the ingress/egress traffic should be fairly simple. In the past, people can only rely on customised client lib code to do that(In case of Meta, this is done via Thrift).

