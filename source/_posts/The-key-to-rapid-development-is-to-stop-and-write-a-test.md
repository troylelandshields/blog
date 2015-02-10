title: The key to rapid development is to stop and write a test
date: 2015-02-01 02:53:55
tags:
---
Several months ago [Doug Leonard](https://twitter.com/dleonard00), [Colton Shields](https://twitter.com/kurtinlane), and [I](https://twitter.com/shieldstroy) started bringing an idea from Doug's mind into your reality. [bettrnet.com](http://www.bettrnet.com) was born (and has since been reborn a few times and surgically altered and is currently in the process of going through a painfully awkward puberty before it will likely be burned and rebirthed again like the beautiful phoenix we dream it to be).

At the time, the three of us collectively decided it was a bettr (hold the 'e' from now on) idea to prioritize getting a working product up and running over "wasting" time writing tests. The name of the game was rapid development and deployment.

I now wish I could go back and kick ourselves in the shins for making this decision. Here's why:

##Writing tests forces you to solve two problems

When are you furiously coding away without stopping to write a test you end up with code that fits very nicely into the single context of the problem or feature you were working on. Days or weeks or months later when you add functionality and need to reuse parts of this code, you may end up having to force a square peg into the round hole you created before. You weren't doing anything wrong, you just had a round peg at the time, that's all you were thinking about, so you made a round hole.

You jam the square peg in and pray that both the square peg and the round peg fit nicely. You of course have no easy way to verify that, so you spend the next twenty minutes manually shaking the board to see if the square or round pegs fall out.

I know now that if I had stopped furiously coding in the first place and taken a second to write a test, I would have been forced to think about something other than just the original round peg. I may not have thought of the square peg, but at the very least I considered other peg shapes for a moment. Thinking about writing code that causes a test to pass requires a different mental context than thinking about code that makes a feature work.

If I had written a test first, I guarantee that the square peg would have fit at least slightly nicer when the time came. I also wouldn't have had to spend much time at all manually testing because I would have had proof that the round peg still fit.

##Automated testing is about a billion times better than manual testing

In the beginning of a project, manually testing seems far easier and more satisfying than writing unit tests. Your project has very few dependencies, so getting it up and running locally is a snap. It does very little, so seeing the progress is both easy and rewarding.

After your project gets a little more complex, testing it becomes exponentially more difficult and time-consuming. A unit test can build, run, and verify if that code you just wrote is going to sink or float in less than a second. On the other hand, it might take me 5 minutes to fire up a test database, build the project, start up the server--oh shoot I forgot to add that new dependency to the guice module--fire up a test database, build the project, start up the server, open up a browser, navigate to the page, figure out what action I need to take to run my code--oh shoot it didn't work, back to the drawing board. It took me that much time and effort just to find out that something doesn't work.

<i>I should only have to manually test code that I am extremely confident is actually going to work.</i>

Automated tests are the gift that keeps on giving as well. Not only do they help you write and run code extremely quickly, they keep you feeling confident that your code is still working weeks or months later. The alternative is to keep adding to the ritual of manual tests you go through every time you make a change.

##Tests document your code

At a certain point you're going to make a change that breaks one of your tests. When this happens to me, my first instinct is to look at the offending code. I glance at it, scratch my head and realize that even though I wrote this a week ago I can't remember what in the Sam Hill it was supposed to do.

The test tells me two things: (1) that I changed some behavior and (2) what the behavior was supposed to be before. I have the information I need to look back at a very specific place in code and figure out if what I changed is OK or if this whole thing is coming down, whereas before I wouldn't even have known that I changed that piece of functionality or what I originally meant it to do!
