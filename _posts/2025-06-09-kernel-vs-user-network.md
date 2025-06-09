---

layout: post

title: "Kernel vs. User-Level Networking: Don’t Throw Out the Stack with the Interrupts"

description: ""

category: system

tags: ["papers","system","networking"]

---

{% include JB/setup %}

I found this paper here: [https://www.sigmetrics.org/sigmetrics2024/accepted_papers.html](https://www.sigmetrics.org/sigmetrics2024/accepted_papers.html)

However, instead of reading through the whole paper by myself, I decided to get some help from Gemini. What I did was uploading the PDF and ask him(her) to summarise the paper. And this is the summary:

```
Of course. Here is a summary of the paper "Kernel vs. User-Level Networking: Don't Throw Out the Stack with the Interrupts" by Peter Cai and Martin Karsten.

1. Core Problem & Motivation
The paper addresses the widely-held belief that user-level networking and kernel-bypass stacks (like DPDK-based solutions) are inherently superior to the traditional kernel network stack for high-performance applications. While these user-level approaches show significant performance gains, the authors argue that the specific reasons for these gains are not well-quantified or understood. The paper aims to identify the true source of this performance gap and determine if the benefits of user-level networking can be achieved without completely abandoning the mature, feature-rich, and general-purpose Linux kernel stack.

2. Main Hypothesis
The authors' central hypothesis is that a major source of overhead in traditional kernel networking is not the stack's processing logic itself, but the direct and indirect costs of asynchronous hardware interrupt requests (IRQs).

IRQs disrupt the CPU's processing pipeline, causing context switches, cache pollution, and other micro-architectural inefficiencies. This leads to a lower Instructions Per Cycle (IPC), which throttles overall performance. User-level stacks avoid this problem by using a continuous polling model, which creates better temporal and spatial alignment between network processing and application logic.

3. Methodology
To prove their hypothesis, the authors use an indirect measurement approach:

Performance Model: They use a simple model where throughput is a function of Instructions Per Cycle (IPC) and Instructions Per Query (IPQ). This allows them to analyze whether performance changes are due to more efficient code (lower IPQ) or better CPU utilization (higher IPC).
Analytical Setups: They first evaluate two "impractical" kernel configurations to isolate the effect of IRQs:
IRQ Packing: All network interrupts are routed to a small, dedicated set of cores, separating them from application cores.
IRQ Suppression: Uses NIC hardware features (interrupt coalescing) to drastically reduce the rate of interrupts.
These setups confirm that reducing IRQs significantly improves performance, primarily by increasing IPC.
4. The Proposed Solution: "Kernel Polling"
Based on their findings, the authors propose a practical, minimally invasive solution called Kernel Polling. It requires a small modification (~30 lines of code) to the Linux kernel.

How it works:

It modifies the behavior of system calls like epoll_wait().
When an application is busy and has data to process, the kernel keeps the hardware interrupts for the corresponding network receive (RX) queue disabled.
Instead of waiting for an interrupt, the kernel polls the network card for new packets when the application is ready for more work (i.e., calls epoll_wait()).
Interrupts are only re-enabled as a fallback mechanism when the application becomes idle (i.e., there is no data to process), preventing wasted CPU cycles from continuous polling on an idle system.
This approach effectively mimics the synchronous, efficient processing of a user-level stack but does so within the existing kernel framework, retaining its benefits.

5. Key Results and Findings
The experimental evaluation, primarily using the Memcached key-value store, demonstrates the success of Kernel Polling:

Significant Throughput Gain: Kernel Polling improves throughput by up to 30-31% in a standard (UMA) setup and up to 45% in a multi-socket (NUMA) configuration compared to a vanilla Linux kernel.
Excellent Tail Latency: Unlike crude IRQ suppression, Kernel Polling achieves this throughput gain without compromising or degrading 99th-percentile tail latency.
Comparable to User-Level Stacks: With this modification, the kernel's performance becomes comparable to that of a comprehensive user-level stack (F-Stack), proving that abandoning the kernel is not necessary to achieve high performance.
IPC is Key: The performance gains are shown to come almost entirely from an increase in IPC, confirming the authors' initial hypothesis that avoiding interrupt-driven disruption is the critical factor.
Locality Matters in NUMA: The performance benefit is even greater across NUMA nodes because Kernel Polling ensures that network processing happens on the same core as the application thread, improving data locality.
6. Conclusion and Implications
The paper's title, "Don't Throw Out the Stack with the Interrupts," perfectly encapsulates its conclusion. The primary bottleneck in kernel networking is not the stack's design but its reliance on asynchronous interrupts.

The key takeaways are:

A minor, targeted change to the kernel can yield a significant portion of the performance benefits attributed to user-level networking.
Kernel Polling offers a practical path to boosting performance without the complexity, resource dedication (pinned cores), and feature loss of kernel-bypass solutions.
For researchers and practitioners, it is crucial to use a competitively configured baseline (with proper IRQ handling) when comparing new systems against the Linux kernel to avoid drawing misleading conclusions.

```

Then I started to ask a question to myself: the idea looks naive and it seems pretty straightforward to provide such a feature in the kernel. Why the kernel does not provide it?

Then I could not stop myself pasting the thinking back to Germini again and this is the answer he(she) provides:

```
That is an excellent and insightful question. The paper makes a compelling case for Kernel Polling, so it's natural to wonder why it's not a standard feature.

The short answer is that the Linux kernel is designed to be a general-purpose operating system, and a feature like Kernel Polling represents a trade-off that prioritizes one specific use case (high-throughput, low-latency servers) over the kernel's core principles of fairness, robustness, and universality.

Here are the key reasons why a feature like Kernel Polling isn't implemented by default and faces a high bar for inclusion:

1. The General-Purpose vs. Special-Purpose Trade-off
Kernel's Goal: The Linux kernel has to work well everywhere—on your laptop, your phone, a web server, a supercomputer, and an embedded device. Its default behavior must be a safe, fair, and reasonable compromise for all these scenarios.
Kernel Polling's Goal: Kernel Polling is an optimization specifically for applications that are I/O-bound and process data in a tight loop. For a desktop system running a web browser and a word processor, this model is not only unnecessary but could be detrimental. The default interrupt-driven model is far more efficient for handling a mix of sporadic events from different sources (mouse, keyboard, network, disk).
2. Risk of Misbehaving or Malicious Applications
This is the most critical technical barrier. Kernel Polling hands over control of when interrupts are re-enabled to a user-space application.

The "Hostage" Scenario: A poorly written or malicious application could call epoll_wait(), receive data, process it, but then never call epoll_wait() again. It might get stuck in a long computation or an infinite loop.
The Consequence: If this happens, the interrupts for that network queue would remain masked indefinitely. No new packets could ever be delivered to that queue, effectively starving the application and any other services that might rely on it. The network interface would appear to be "stuck" for that application.
The Kernel's Philosophy: The kernel's design principle is to never fully trust user-space. It must always be able to preempt or manage resources regardless of what an application does. Kernel Polling, in its simplest form, violates this principle.
3. Existing (But Imperfect) Mechanisms
The kernel already has mechanisms that try to address this problem, which shows that developers are aware of the issue. These include:

NAPI (New API): As the paper mentions, NAPI is a hybrid model that polls for a short time after an interrupt arrives. This is the kernel's first line of defense against interrupt storms.
SO_BUSY_POLL: This socket option allows the kernel to poll for a very short, fixed duration before putting a task to sleep. However, as the paper points out, it's not a complete solution because interrupts are immediately re-enabled after the system call returns, allowing new IRQs to disrupt the application while it's processing the data it just received.
XDP and AF_XDP: For extreme performance needs, the kernel community has invested heavily in the eXpress Data Path (XDP), which allows processing packets before they even enter the main network stack. This is the "official" path for kernel-bypass-like performance.
From the perspective of a kernel developer, the combination of NAPI, busy polling, and XDP already provides a spectrum of options. A new mechanism needs to prove it's significantly better and safer than the existing tools.

4. The Path to Adoption is Not Impossible
The authors of the paper are aware of these challenges. They explicitly state that their proof-of-concept would need enhancements to be accepted into the mainline kernel. The necessary changes would include:

Security/Permissions: The ability to use Kernel Polling would likely be restricted to privileged processes (e.g., requiring the CAP_NET_ADMIN capability), so a random application can't disrupt the system.
Safety Timeouts: The kernel would need a watchdog timer. If an application masks interrupts and doesn't call epoll_wait() again within a certain timeout (e.g., a few milliseconds), the kernel would forcibly re-enable the interrupts to prevent the queue from being starved.
With these safeguards, a patch for Kernel Polling would have a much better chance of being accepted, as it would balance the performance gains with the kernel's need for robustness and security. The paper's contribution is showing that this path is worth pursuing.

```

The answer is pretty impressive I would say. 
