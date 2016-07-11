---
layout: post
title: A Philosophy of Code
author: Noah Seger
excerpt: What is your philosophy of code?
---

> What is your philosophy of code?

That’s a question I’ve asked on both sides of a lot of interviews. Everyone can point to specific qualities in their code that have contributed to success or failure and talking about them reveals which ones are most valuable to individuals and teams and which ones they have never even thought about.

Often though, the answers to this question paint an astonishing double rainbow of shame around the many ways we harm ourselves and our projects with our coding practices, even when individuals know the good ones. And they almost always do! As teams, we just don’t think about it that hard.

Teams _should_ think about their own answers to this question and collaborate on a living document like this one. For extra fun you should try to round out or replace the (overused) stock quotes here with wisdom from your own team.

There aren’t many concrete examples, but I already said this is philosophy so I’m not sure where you got the idea that it might be useful.


----------

#### Code is a tool to solve hard technical problems

> Your scientists were so preoccupied with whether or not they could that they didn't stop to think if they should.
> — Jeff Goldblum as himself in “Jurassic Park”

If we’re going to have a philosophy of code we should understand [what code is](http://www.bloomberg.com/graphics/2015-paul-ford-what-is-code/) and when to use it. So before we talk any more about it, let’s establish some times when we won’t be writing code:


- We don’t have a problem
- The problem isn’t technical
- The problem is easy to solve by hand

This probably seems obvious, but too often we programmers end up writing some code anyways (it being kind of what we do).


#### Understand the problem

> A good developer can take a set of specs and implement them quickly, a great developer can produce the same thing with just a vague idea.
> — Chris Chang

If we really understand the problem we are trying to solve, we will invariably approach a more useful, a more global, or a more human solution. We may also realize that the problem has already been solved for us, and of course [the best code is no code at all](https://blog.codinghorror.com/the-best-code-is-no-code-at-all/)!

Even better than a solution that requires no code is a solution that removes code because it has simplified or eliminated some part of the problem.

Code is expensive to write and maintain. The single best time to solve bugs and architectural problems is before they are introduced.


#### Do the simplest thing that can possibly work

> If debugging is the process of removing bugs, then programming must be the process of putting them in.
> — Edsger Dijkstra

Be mindful of essential versus incidental complexity. Given alternatives between less and more, do less first and maybe more later.

Highlight essential complexity and share a vocabulary (a ubiquitous language) around it. Hide incidental complexity with abstractions to reduce cognitive load.

Counting lines of code is the worst metric for estimating bug count and software quality except for all the other metrics.


#### Talk about the problem

> If the implementation is hard to explain, it's a bad idea.
> If the implementation is easy to explain, it may be a good idea.
> — The Zen of Python

[Talking about ideas](/2016/01/10/the-workflow-is-not-about-code.html) is often the fastest way to validate them! If you can easily convince your peers that each component is going to work, you can start coding with confidence.

Learn to appreciate when discussion reveals a weakness in your ideas; it saved you a lot of time.


#### Break down the problem

> For each desired change, make the change easy (warning: this may be hard), then make the easy change.
> – Kent Beck

Big changes ensure that you are the only person on the team who really knows what changed. Nobody wants to review thousands of lines of code. Also, you probably missed something.

Even small changes can benefit from breaking down the problem if it means that part of a change can be shipped sooner! Remember that **unshipped code has negative value**.


#### Write code for readability

> Programs must be written for people to read, and only incidentally for machines to execute.
> — Abelson & Sussman, "Structure and Interpretation of Computer Programs"

Use full words. Everybody you’re working with can read and understand them.

Use meaningful names that make grammatical sense. The job of a good name is to reduce, never increase, the cognitive load required to understand the code.

Treat functions like paragraphs. They should present one idea, succinctly. Never write a function longer than 20 lines unless essential complexity demands it.

If you find yourself adding a comment, consider that your code can be written in a way that it is self-explanatory so the comment is not needed.

Remember that future readers won’t be as familiar with the problem, so do everything you can to help them out!


#### Style matters

Code with a deliberate style. A reasoned stylistic consistency is a powerful weapon against cognitive load. Understand why you choose a single style among alternatives and challenge your existing assumptions.

Be able and willing to explain your style to other people. Be open to changing your style in the face of a good argument. “The team agrees on the style” is a better argument than it seems at first.

Be aware that an esoteric coding style isolates you from your language community.

Wherever possible, automate the enforcement of a style that the team agrees on.


#### Don’t Repeat Yourself

> Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
> — Andy Hunt and Dave Thomas, "The Pragmatic Programmer”

This is a fundamental principle of clean code.

Duplicated code unnecessarily bloats code bases and makes it harder to refactor. Repeating the same process by hand is error-prone and a waste of time. See the [Rule of Three](https://en.wikipedia.org/wiki/Rule_of_three_(computer_programming)).

But remember that systems have boundaries and some abstractions will not translate.


#### Structure code for discoverability

As you read code, you should move from the “what” into the “how” as you look deeper in folder structures. The concerns of a package should be obvious at the top level of that package.

Where does the login view live? It would be nice if it lived in a module called `login` , maybe inside a package called `views` depending on our convention.

How easily can you go to the definition of the code being called? How easily can we discover the view code for the current URL? What if it’s in a third-party package?


#### Structure code for deletion

Code structured for easy deletion is less likely to contribute to technical debt because it can be easily removed or reimplemented.

Jack Hsu’s [litmus test for project structure](http://jaysoo.ca/2016/02/28/organizing-redux-application/#litmus-test-for-project-structure) is a great way to apply this principle:


> Every once in a while, pick a module in your application and **try to extract it as an external module**(e.g. a NodeJS module, Ruby gem, etc). You don’t have to actually do it, but at least think it through. If you can perform this extraction without much effort then you know it is well factored.

Code that is easier to delete has fewer dependencies. And vice versa. This is a rephrasing or maybe an extension of the [Law of Demeter](https://en.wikipedia.org/wiki/Law_of_Demeter) which instructs us to loosely couple to our collaborators.


#### The simplest solutions are usually immutable

Avoiding mutation is one of the easiest ways to eliminate cognitive load and the slew of common bugs that infest stateful code.

Data should be immutable by default. This will generally save a lot of time and tears.

Adopting a functional programming style by default is a great way to achieve these goals.


#### Unit tests are a catalogue of behaviors

By reading the test names, you should easily understand the what the system does. By reading the test bodies, you should easily understand the interface for accomplishing the behavior under test.

Behaviors are things like “redirects to the login page when the user is not logged in” and “retries an order that failed within the last week” and literally anything else your system does or does not do.

Some behaviors are less important than others.

Aim for tests that capture the problem with such clarity that you would prefer to lose your production code than to lose your tests. If you can rebuild your system from your tests, you can refactor with confidence.


#### Test every important behavior

Maintaining a discipline around testing each behavior you add to the system is a powerful counterbalance to complexity—it drives you toward the simplest code that can possibly work.

Code coverage is an essential tool that can help you find behaviors that you have forgotten to test—but it can’t tell you how well you’ve tested the behavior.

Finally, if the behavior is not important enough to test, why add it in the first place?


#### Tests are a tool for improving the design

Tests are a design tool because they alert you to code smells. If something is hard to test, the design can probably be improved.

Every bug that made it to production passed the tests, so we can’t treat tests *primarily* as a tool for preventing bugs. But by adding regression tests for every bug that does make it to production, it becomes obvious over time which areas of the code suffer from low quality or poor design.


#### Test at the highest practical level

The closer tests are to capturing behaviors the end user actually cares about, the better.

Testing implementation details is an investment in doing things a specific way, and converts to technical debt as soon as that way of doing things needs to change.

Avoid testing internals unless you need to as long as their covered by higher-level tests. You can often get the best of both worlds with a [functional approach to objects and data](https://www.destroyallsoftware.com/talks/boundaries).

On the other hand…


#### Tests should be fast and specific

When you want to work on file `foo.py`  you should be able to lean on the file `test_foo.py` as you iterate. When changing one logical statement, ideally only a single test will fail.

Avoid big hairy integration tests that take longer to run as more code is added. It’s often better to rewrite these when we find them in the project to gain the design benefit of unit testing.

A unit test that takes more than a second to run is broken. A test suite that takes less than a second to run is the holy grail.


#### Making it work is just the first step
> Make it work.
> Make it right.
> Make it fast.

After you’ve written some working code, you should review your work to see how it can improve. Is it as simple as possible? Will it be easy to maintain? Was it painful to produce in some way that indicates a flaw in the design of the system? Will the rest of the team find it easy to understand?

If you don’t know what this feels like from experience, there’s a mechanical approach to get started: simply remove as many `if` statements and other branching syntax as possible while keeping the code direct and understandable.

TDD is another great tool can help minimize the delta between “working” and “good”, especially with new and unfamiliar concepts.


#### Code review is essential communication

Code review is the process of discussing a change with our peers. It captures single problem and it yields a solution to that problem that is acceptable to the team and the stakeholders.

Without peer review code becomes factionalized, belonging to individuals instead of the team.

Pair programming works as a minimal code review process. When pairing, we should still open a request for comments on our work so everybody knows what’s changing.


#### Commit history is essential communication

Since we went through all the trouble of distilling the problem into a format everyone can understand, we should probably keep that in our history. Squashing the change into a single commit makes it easy to find all the context and discussion for the change in the future (via a link to the code review or otherwise).

Remember that we are communicating with our commit messages, and all communication has an audience. Good communication here makes it obvious what changed and why.

Adopt a single [commit message style](http://chris.beams.io/posts/git-commit/) for your team. I like to write a first paragraph that any stakeholder in the change could understand followed by additional technical detail directed at the maintainers.


#### Reproducibility is a requirement

Enable processes that anybody on the team can reproduce. A good way to do this is to write processes as executable code and to execute that code continually.

Being able to run the code during review without talking to the author is a good test for reproducibility.


#### Not improving is the same as getting worse
> Leave this world a little better than you found it.
> — Robert Baden-Powell

Code bases tend get messier over time. We need to actively improve them.

If we had to work hard understand some code, we should convert that understanding into better code. This means that other developers will not have to repeat the work (or incur the cost) of working with that bad code again.

There’s usually something we can improve: a variable name, an unused layer of abstraction, a bit of accidental complexity.

Note that this principle also applies to our own skills as programmers.


#### Professionalism begins after the tutorials end

Here are some things that you will not find in many introductory language tutorials:


- Logging and error handling
- Testing strategies that scale with your project
- Monitoring and performance tuning
- Debugging tools and strategies
- Packaging code for reuse
- The best way to deploy
- Navigating the language ecosystem

These tend to be things you have to pick up as you go. Reading and participating in open source software at any level can help speed you along.

We should take extra care to document how we do these things on our team.


#### Rewrite large systems as a last resort

Like democracy, it’s probably better to work with what we’ve got than to throw it away and expect something better. With enough iteration and application of the previous principles  we’ll end up with something resembling the system we want.
