---

layout: post

title: "Some random thoughts on AI and its future"

description: ""

category: "ai"

tags: [ai]

---

## Paradigm shift

A while back I read a quote from Armin, and I've kept thinking about it:

> Do I program any faster? Not really. But it feels like I’ve gained 30% more time in my day because the machine is doing the work.

This is the same feeling. While sometimes AI can implement a feature in less than five minutes (although I feel like with Codex it often takes longer now), to make it work and to make it less verbose still requires plenty of iterations. It certainly does not make me program faster either.

However, I realised it has gradually changed the way I program.

I started programming very early. I learned BASIC when I was in primary school. In middle school I programmed in Pascal on a blue screen with white text. Later, at university and at work, it was Java, Lisp, C++, Python, Lua, JavaScript, etc. All these languages are so-called high-level programming languages: they sit between human and machine. They translate real-world abstractions into bits and bytes for computers. Still, they are languages with limited vocabularies and expressions. They must balance the expressiveness of natural language with the precision of machine instructions. So, in order to master a programming language, the programmer usually needs to fully grasp its keywords, vocabulary, and expressions.

With AI, when I'm writing TypeScript I shamelessly admit that I no longer know the language as well as I know Python or Go, because I don't write TypeScript directly anymore. I interact with the machine using natural language. In the past, compilers (interpreters) translated high-level languages into machine code. Now, LLMs translate natural language into TypeScript, which is then translated into machine code.

One of the biggest benefits of high-level programming languages is that they lower the bar to becoming a programmer. With AI, the bar is lowered even further. Is this a good thing? Of course. Look at how humanity progressed when mass literacy became a reality.


## Thought experiment on an AI-only software world

Before we start the thought experiment, we should define what software and a program are. There is a big difference between a program and software. A program is usually a piece of code solving a specific small problem—for example, a program to find a specific user in the database or draw a rectangle on the screen. Software is a combination of programs, and this is usually where the complexity lies.

Today, when we develop software we follow some well-recognised principles:

* KISS — Keep it simple, stupid
* DRY — Don't repeat yourself
* Abstraction and encapsulation
* Low coupling and high cohesion


All these principles emerged because the capacity of the human brain is limited. We can quickly be overwhelmed by complexity as programs accumulate in software. When software needs to communicate with other systems, we design succinct communication protocols and data formats in plain text so humans can understand them.

All these design decisions sacrifice efficiency at the machine level in exchange for readability and maintainability at the human level.

But what if in the future humans no longer need to program? When AI does all the heavy lifting, given the capabilities they have, will they still need to follow the principles I mentioned above?

In other words, if the computer architecture remains the same and we let AI design the programming languages, tooling, network protocols, and data exchange formats, what would it be like? What levels of complexity would be acceptable for AI?

Implicitly, the principles I mentioned above are collective consensus built over years of development. Each AI model will surely have its own level of capability. Will they try to find common ground via social activities as humans do? More importantly, all the current knowledge sources for AI are from humans. How and when can they start to realise they are different from humans and explore their own complexity boundaries?


At this stage it's difficult to answer. After all, today AI is instructed by humans. Kids could never grow up if they're never let go by their parents.

Let's assume somehow they can make their own decisions. What kind of decisions could they make? Before answering that, maybe we should first discuss what capabilities AI will have that humans do not. The biggest difference I see today is an almost unlimited capacity for text processing and pattern matching. A good example is debugging. If I'm given a log message to debug an issue in a project, it might take me a while to find the related repository, search the code, read it, reason about it, and figure out a potential cause. For AI, this might only take less than five minutes.


Given its superpower in text processing and pattern matching, one thing I'm pretty sure of is that data exchange formats such as XML and YAML will be replaced by much more machine-friendly binary protocols.

Writing well-abstracted and encapsulated code? I'm not so sure. One thing humans learn from years of development is the importance of good APIs. Exposing too many details to the outside world is considered a drawback because it can impose unnecessary cognitive load on humans. But this seems less of an issue for AI. Writing good code for others to understand is a challenging task for both AI and humans. If the readers have superpowers, writing spaghetti code may well be acceptable.

If the above two things happen, what will humans do? Will we even notice? On broader terms, what will the transition be like?

The good thing is that, as long as humans remain in control or involved, accumulated wisdom will still be valued.

{% include JB/setup %}

