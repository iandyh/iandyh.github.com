---
layout: post
title: "We still need to read the code (Sometimes)"
description: "Why reading AI-generated code still matters for maintainability, refactoring, and engineering judgment."
category: ai
tags: [ai]
---

{% include JB/setup %}

Somebody has recently argued hard that even though the code looks hideous, it's OK because there is no need to [read the code any more](https://x.com/dhh/status/2104634425778585817). Of course, this is because of AI. AI is writing the code so fast and so well that humans no longer need to read the code.

Is this true?

To answer this question, we need to define it more clearly.

## Not all applications are born equal

IMHO, there are two types of applications:

- Toy apps. You build one, use it and forget about it. It probably has a dozen users at its peak. Given their nature, these apps are also simple. For example, for this year's Fuji Rock music festival, I built a simple app for exploring the performing artists: [Naeba FM](https://naeba-fm.reqfleet.io/).
- Apps that need maintenance. These apps are more complex and usually have more than one person maintaining them.

For the first type of app, even if AI writes horrible code, as long as it works, I guess it's not a big deal. You certainly need not look at it.

It's the second type we need to discuss.

## What is code and what is good (or bad) code?

By definition, code is logic written in a language. 

And when people are talking about good code, I usually find it covers two aspects: beautiful code and maintainable code.

### The beautiful code

Pure aesthetics, and usually it's subjective and abstract. One good example is the widely appreciated beauty of Python and Ruby. For example, in Python, when you need to make a new list with the elements in the old list multiplied by 2:

```python
numbers = [1, 2, 3, 4]
new_numbers = [item * 2 for item in numbers]
```

It's short and expressive compared to Go:

```go
s := make([]int, len(numbers))
for i, item := range numbers {
    s[i] = item * 2
}
```

### The maintainable code

This is where the standards become more objective:

- Is the code solving the actual problem with the correct approach?

- Does the code use concise expressions to solve the problem with the right abstractions?

- Can the code be tested easily? Does it have tests? Does it have comments where necessary?

- Is the code well organised? Does it have high cohesion and low coupling?

It's maintainable code that AI sometimes cannot figure out (or it simply doesn't care). As I'm writing this post, dear GPT has just chosen to skew the generated timestamp due to a time difference between the host and the VM (a known bug in the VM I'm using).

Even as it gets better, it still produces over-defensive code, and sometimes it's just like humans: it's lazy and produces lame code that only does the job superficially.

### Decay compounds

Let's assume that every working day, AI introduces an average of 1% decay into the codebase—actually, quite conservative without any human review. After 100 working days, or about five months, the code will become 2.7 times worse than before. That might make maintenance very difficult.

You can argue, hey, I can do the refactoring during those five months! Glad you mentioned it. If you have such a process, that means you either:

- Manually provide the prompt for refactoring. That means you know about the current code smells from looking at the code.
- Write an automated process to improve the quality. Then you introduce another moving part into the system. You need to ensure the refactoring does not break production. During this process, I found it hard to believe that people can completely ignore all the code written by AI.

## You need to understand your code to be useful

Many engineers have complained in the past that their managers do not understand how they feel. In some cases, they are right. Why? Because managers usually don't read the code or handle incidents, so they do not know what the front line looks like. Similarly, if you stop reading the code, you start to lose your grip on the codebase and eventually become the manager you are complaining about. The agent probably feels the same way: why is he asking me to do the same thing again?!

### Do we need to understand every line of change?

I think this question can be controversial. Conventional wisdom tells us that if a PR is too big and contains too many changes, that usually means the task is too big and should be split. On the other hand, even if the task has the appropriate granularity, AI is able to produce PRs at a pace that humans cannot keep up with. But my current take is that, in this case, experience matters. Humans need to find the balance between speed (productivity) and quality. Some PRs for sure will not need full attention, while others will.

## Learn from AI

One point that many people often neglect is learning from AI. I have to admit that models today have a much broader and deeper understanding of many fields than I do. By reading their code and discussing it with them, I've also learned a lot.

## No human in the loop?

Much of the work in the field now is on SRE agents that fix issues automatically and agents that can handle customer queries. If AI is able to exclude humans entirely from writing code and all those agents are fully integrated, then this article becomes obsolete.

But there is still a long way to go. I don't know when that day will arrive or what it will be like. At least for now, the infrastructure is not there yet, and AI is not smart enough yet. In the past, for any big and complex project in human history, the work was done collectively and not finished by a single human. I still don't know whether this will be the case for AI or, if so, how agents will need to work with each other.

Before that day comes, humans will be in the loop. If humans are in the loop, we need to take responsibility.

In the end, we also need to produce something we like and we cherish. 