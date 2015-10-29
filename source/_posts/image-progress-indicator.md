title: Image Progress Indicator for CSS Dummies such as myself
date: 2015-07-12 16:25:57
tags:
---
I pretty much hate CSS. It's black magic that's hard to debug and almost never does what I expect it to. I think Bootstrap and other such frameworks are incredibly helpful. That being said, sometimes you just have to cowboyorgirl up and write some custom CSS to get the job done.

It's a pretty common usecase to want to show a progress indicator of some cute graphic being revealed towards some goal. For example, you are raising money for an ice cream party, and you want to reveal an ice cream bar as you get closer to your goal. Or maybe you have a game with a finite number of points and you want the user to see what portion of a trophy they have earned.

Below is just such a game. The rules of the game are that you click the button and you get a random amount of points. Go ahead and play it for the next 20 minutes to fully understand and enjoy the demo.

<p data-height="268" data-theme-id="0" data-slug-hash="NqMQPb" data-default-tab="result" data-user="troylelandshields" class='codepen'>See the Pen <a href='http://codepen.io/troylelandshields/pen/NqMQPb/'>progress</a> by Troy Shields (<a href='http://codepen.io/troylelandshields'>@troylelandshields</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//assets.codepen.io/assets/embed/ei.js"></script>

<!-- more -->

Your first instinct (if you're a CSS dummy like me) when building something like this might be take an image and create different versions of it that represent the user's progress.
 
E.g,

1. trophy_10percent.jpg
2. trophy_20percent.jpg
3. trophy_etc.jpg

This is problematic though because it's freaking annoying to deal with so many different images. You have to calculate the percentage complete and then decide which image their score is closest to. It's also not nearly as enjoyable for the user because they only see progress on the progress indicator in steps. Most importantly, if you ever want to change the picture then it's a huge nightmare to have to prepare all the pictures again.

It's much better to do something more dynamic that will work for all levels of progress and for any picture you might want to show.

The implementation turns out to be dead simple too. Just put a div next to an image, set it's position to absolute and make sure it's the same size. This is your overlay, and it will be partially transparent. Anytime there is a change in the player's score just adjust the height of the overlay using the player's percentage complete. And now you have a cute progress indicator with whatever image you choose.