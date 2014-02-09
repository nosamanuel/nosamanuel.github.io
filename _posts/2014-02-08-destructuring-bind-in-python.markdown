---
layout: post
title: Destructuring Bind in Python
author: Noah Seger
---

I still spend most of my time in Python, but I like to learn new languages and I've noticed a nice trend recently around syntactic sugar for destructuring binds:

[CoffeeScript](http://coffeescript.org/#destructuring): `{ name, email } = User.get(...)`

[Clojure](http://clojure.org/special_forms#Special Forms--Binding Forms (Destructuring)): `(let [{:keys [name email]} (.get User ...)])`

[Elixir](http://elixir-lang.org/#content): `{ User, name, age } = User.get(...)`

Python: `???`

This makes me a jealous developer, and I wondered if I could add an equivalent feature to Python.


### Batteries Not Included

Python already has some nice ways to destructure iterables in the form of [unpacking](http://robert-lujo.com/post/40871820711/python-destructuring), but nothing that's meant to destructure objects by named attributes.

It also has a certain brand of destructuring bind in its `import` mechanism:

    from module import a, b

So in theory, you could do something like the following:

    import sys
    sys.modules['user'] = user
    from user import name, email

But that would make you a bad person.

Can we provide a more fluent construct specifically for the context of data processing? One with semantics distinct from import statements and tuple unpacking?


### Syntactic Macros

Here was my original idea for a Pythonic version of a destructuring bind using a [context manager](http://docs.python.org/2/library/contextlib.html):

    with destructure(user) as (name, email):
        print (name, email)

Explicit and simple! Unfortunately neither the `__enter__`/`__exit__` facilities nor the included `contextlib` helpers give us access to the "as-clause" variables—so it looks like we have no way to determine the requested properties by name.

It turns out there is a solution to this problem: __magic__. In Python, you import magic from the [`ast`](http://docs.python.org/2/library/ast.html) module. With some additional gymnastics using [`inspect`](http://docs.python.org/2/library/inspect.html), we can find the statement that called our context manager to parse out the variable names.

<script src="https://gist.github.com/nosamanuel/8892238.js"></script>


### Future Work

By parsing different kinds of calling statements (other than `ast.With`), the macro could be adapted to accommodate these binding scenarios using the `__iter__` magic method:

- `name, email = destructure(user)`
- `for name, email in destructure(users): ...`

Of course, it would be much easier if Python added something like an `__assign__` hook that received the left-hand side of the assignment, or if it sent the variable names as arguments to the `__enter__` method.


### Conclusion

All this was just intended as a fun thought exercise. Probably nobody should use it. It's almost certainly never worth the performance hit of having to re-parse the calling code. Still, the project confirmed something I really think Python embodies (sorry Perl)—that easy things should be simple and hard things should be possible. (Also readable.)

If you want a hygienic version of this macro you should probably just use [Hy](http://docs.hylang.org/en/latest/), where it would be trivial to add destructuring to the `let` macro or to implement a new `destructure` macro that does all this during the read step.

[Python, like science, is whatever we want it to be!](http://www.youtube.com/watch?v=y_yilOh4COQ)
