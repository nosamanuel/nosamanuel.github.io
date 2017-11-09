---
layout: post
title: Expecting failure with Mocha and Chai
author: Noah Seger
excerpt: How to succeed while you’re failing.
---

> How to succeed while you’re failing.

When writing software, we often discover problems that—for any number of reasons—we can’t solve right now. Because [unit tests are a catalogue of behaviors](http://nosamanuel.github.io/2016/07/10/a-philosophy-of-code.html), I like to encode the problem in a test as an **expected failure.**

The idea behind expecting a unit test to fail is that we want to:


1. Document some known shortcoming of the system in a unit test
2. Leave the test in a pending state so we don’t forget about it
3. Still allow the whole test suite to pass

If we were to write our test in Mocha, but wrap it in [`it.skip`](https://mochajs.org/#inclusive-tests), then the code would never execute when we run our suite. This means that the next time we actually try to run the test, it might fail for a completely different reason. Even worse, it might succeed for reasons we don’t understand!

Expecting failures has always been easy to do in [other languages](https://docs.python.org/2/library/unittest.html#unittest.expectedFailure), but [it’s not an explicit part of the Mocha API](https://github.com/mochajs/mocha/issues/1048). The key to making it work in Mocha is the programmatic `this.skip()` method, which marks the current test as skipped:


```javascript
const { assert, AssertionError } = require('chai')

class ServiceError extends Error {}

const ExampleService = {
  getWithError: () => Promise.reject(new ServiceError()),
  getWithFailure: () => Promise.resolve({ ok: false })
}

describe('Expected failures', function () {

  /**
   * This test should pass, but it fails for reason X.
   * When X is fixed, remove the skip and test like normal.
   */
  it('fails synchronously', function () {
    assert.throws(
      () => assert.equal('foo', 'bar'),
      AssertionError
    )
    this.skip()
  });

  /**
   * This test should pass, but it fails for reason Y.
   * When Y is fixed, remove the skip and test like normal.
   */
  it('fails when a Promise is rejected', function () {
    return ExampleService.getWithError()
      .then(result => {
        // Ideal behavior; broken because of the error.
        assert.deepEqual(result, { ok: true })
      })
      .then(assert.fail, error => {
        // Current behavior; expected failure.
        assert.instanceOf(error, ServiceError)
        this.skip()
      })
  });

  /**
   * This test should pass, but it fails for reason Z.
   * When Z is fixed, remove the skip and test like normal.
   */
  it('fails when asserting a Promise result', function () {
    return ExampleService.getWithFailure()
      .then(result => {
        // Ideal behavior; currently broken.
        assert.deepEqual(result, { ok: true })
      })
      .then(assert.fail, error => {
        // Expected failure.
        assert.instanceOf(error, AssertionError)
        this.skip()
      })
  });
});
```

Now when our test suite runs, these two cases will be marked as pending instead of successes or failures!


![](https://d2mxuefqeaa7sj.cloudfront.net/s_D6FAF9210B147D71B13F9E8C88294365B98BEAECF9513F56974290D13F897ECD_1501867262090_Screen+Shot+2017-08-04+at+12.20.32+PM.png)


If our tests fail for any other reason than expected, the test will throw an unhandled error and will be recorded as **failed** instead of **skipped**—exactly what we want.

When using promises, we pass [`assert.fail`](http://chaijs.com/api/assert/#failactual-expected-message-operator) as the [`onFulfilled`](https://github.com/promises-aplus/promises-spec#the-then-method) [handler](https://github.com/promises-aplus/promises-spec#the-then-method) so that if the promise unexpectedly succeeds then our test fails right away. Alternatively, we can make an assertion about the ideal result that we expect to fail, and handle it in the next `onRejected` handler as in the last example.


**Caveats**

Only use this pattern when it is impossible or impractical to fix the problem now. Otherwise, you’re just creating [a mess](https://sites.google.com/site/unclebobconsultingllc/a-mess-is-not-a-technical-debt) for future developers.

Start your test descriptions with the word **“fails”** so when scanning a full test report you can differentiate them from normal skipped tests.

Most important, make sure to leave a note about the problems with the current design of the code that are making the test fail. You’re going to want as much context as possible for the next time you revisit this test, which could realistically be a long time—or never.


![](http://i.imgur.com/EjVu5mb.gif)


**Conclusion**

For now [it doesn’t seem like there’s any interest](https://github.com/mochajs/mocha/issues/1048) in adding expected failures as a first-class testing mechanism in Mocha, but maybe a contribution like an `it.fails` could make this slightly less cumbersome in the future. If you’re using the [Mocha TAP Reporter](https://www.npmjs.com/package/mocha-tap-reporter) it might be easy to add support for expected failures using the result from the [protocol](https://testanything.org/tap-version-13-specification.html), but I haven’t done any more research.

It also looks like this pattern is not possible using Jest or Jasmine, since there is no support for programmatically skipping a test while it is running, but I’m less familiar with those libraries.

If you’re using Mocha as your test runner hope this pattern is useful. I hope to follow up with more articles on testing patterns in the future—and may your expected failures be few and far between!
