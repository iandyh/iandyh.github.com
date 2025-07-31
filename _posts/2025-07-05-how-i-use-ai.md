---

layout: post

title: "How I use AI tools"

description: ""

category: tools

tags: ["tools","ai"]

---


In the fast-evolving AI world, this article might soon become obsolete. So taking a snapshot now can help us glimpse back from the future.


There are several areas where I'm heavily using AI tools:

* Travel route planning
  * e.g. Could you help me find a mountain to trek that is within 2 hours' drive and suitable for kids
* Document polishing (including this article)
* General knowledge query
* Programming
* Financial report analysis
  * Here is the latest financial report of Google. Could you list the main revenue sources and where the main capital expenses are? (Gemini is best for this task)

I'll go into the details of programming.

### Main tools I'm using

I was an Emacs user before switching to VS Code about 7 or 8 years ago. Even after switching to VS Code, I still use Emacs keybindings in Code.


VS Code comes with some free Copilot credits. The tab-to-complete feature is pretty amazing. I almost use up all the credits just after a couple of days each month. Cursor is a natural replacement given the good reviews.


However, one thing I am horrified by is forking an upstream application. That usually requires deep knowledge of the application and years of dedication. So when I heard Cursor forked VS Code, I could not pull the trigger. Adopting an editor that's central to my professional life from a startup with an unknown future is a big risk.


So I started paying for GitHub Copilot. One immediate additional benefit is Copilot Pull Review. This is very helpful since I've been working on a project by myself. Having an additional eye is a big plus.


Here are the areas where I've found AI excels, as well as those where it still has room for improvement.

#### lib code


In one of my projects, I needed to write client code to implement a broker based on Redis. In the past, code like this would probably cost me 30 minutes with test cases. With Copilot's help, this was done within 1 minute with well-covered test cases. The produced code did not even need any editing. It's written and ready to be used.

#### test cases


Writing test cases manually is a pain. Designing a complete test suite is even more difficult. However, with Copilot, this has become a joy. All you need to do is:

```
/tests please create a test case for the newly created func in the xxx package.
```


After several seconds, a comprehensive test case is created and can be run immediately. This has helped me find many edge cases that previous implementations had not considered.

#### Frontend work


I also started working on a GUI project with Next.js and TypeScript. The experience so far has been amazing. I haven't written a single line of code for a week since I started working on it. All I do is `cmd + ctrl + i` to trigger the agent mode in GitHub Copilot and provide a prompt like this:


```
I need you to add an XX feature to the page. The state management is here: xxx.ts. You can check how the YY feature is implemented and I want to have the same UX.
```


It can finish the feature within a couple of minutes and it usually does not require additional tweaks.


I also notice that Claude Code Sonnet 4 performs marginally better than others when doing frontend work.

#### Finding repeated pattern


More often than not, projects have repeated patterns for certain logic. A well locally indexed Copilot is sharp at picking up the pattern and suggesting the edit. This has saved me a tremendous amount of time. For example, since I'm not a fan of ORM, the price I pay is writing a lot of repeated code for getting a DB connection, preparing the statement, and executing the statement. Without AI in the past, this was definitely not pleasant. However, with Copilot, once I finish the function name, it has already filled in the implementation.


Of course, there are certain areas Copilot does not do well.

#### Complex scaffolding


Copilot agent was published a while back. When it was announced, I decided to give it a go with a big feature at hand. I wanted to check whether it could at least build some foundation work. So I gave the requirements to the agent and it started to work.


Putting the detailed implementation aside, the main problem with the solution is the lack of package design. Everything was put under the same package, and much logic was cluttered into the same file. While you can provide feedback to the agent, this certainly takes more time.

#### Working too much


A lot of the time, I know what I am doing and I don't need any suggestions, or maybe just simple suggestions to finish typing. But Copilot is often suggesting big chunks of code that are never needed.

### Gemini-cli


Since Gemini-cli (Claude code) came out, I've been wanting to give it a try. I recently started a new experimental project and began to use Gemini-cli. Clearly, it requires guidance and iteration. The first implementation was not ideal.


Another piece of work it has done is helping me resolve issues found by `staticcheck`. I have a legacy project that has many places failing the Go `staticcheck`.

```
foo.go:1248:4: unnecessary use of fmt.Sprintf (S1039)
```


I simply copy all the errors like above into Gemini-cli and ask it to resolve them. It successfully resolved 75 of them in one go. This again saved me at least 1 hour of work.

## Final words


In our day-to-day professional life, much of the repeated work no longer needs manual effort—the copy and paste days are gone. However, it requires us engineers to be able to:


* Explain the problem clearly to AI. It's like product managers writing requirements to engineers in the past.
* Establish a quick feedback loop to either understand the solution AI provides or validate the correctness of the solution. (Unit testing, CI are even more valuable)

The productivity boost is real. I can fully expect many new things to be created in the future and create more opportunities for everyone. At the same time, working closely with AI for the last half year also makes me think about the value of human engineers: if AI can work out your idea within minutes, that certainly means your idea is no longer novel. If it struggles, it might mean the idea is worth exploring and may indicate where the innovation lies.

{% include JB/setup %}