title: Fragment Identifiers in URLs
date: 2015-04-17 14:21:54
tags:
---

![](http://cnsnews.com/sites/default/files/imagecache/medium/images/aaa2_512.jpg)


## Fragment Identifiers - The URL Hashtag

Fragment identifiers are the optional #loremipsum part of a URL (e.g., http://shldz.us/travels/<b>#Provo</b>).

Fragment identifiers are only used on the client's browser and are not sent to the server. Using these can be incredibly useful for dynamically altering the content on a webpage without having to request the entire page from the server again. (These can be contrasted with query strings which follow the question mark in a URL and <i>are</i> sent to the server. e.g., http://google.com?q=unicorn+hippo).

Popular Javascript frameworks such as [Angular.js](https://angularjs.org/) use the fragment identifier as a crucial part of navigation. The below examples are entirely independent of Angular, but still might serve to help you understand the fragment identifier better.

##An Example of the Usefulness of Fragment Identifiers

I have some Javascript code at shldz.us/travels that uses the fragment identifier to open specific images in my lightbox viewer, making a link such as http://shldz.us/travels/#Winter+http://shldz.us/travels/Now/2014/2013/Winter/IMG_0001.JPG open to our travels page and subsequently show the correct image.

As far as the server knows it just served the client the resource at shldz.us/travels and that's it, but then my Javascript code on the client knew to also grab the image in the fragment identifier and open it up.

That's great, because as someone is cycling through the images in a gallery I can change the URL to the current image without sending and receiving a whole new request to the server.

##The Problem with Facebook's Like Button (and other such features)

Using fragment identifiers can be difficult if you are trying to do something like add a Facebook 'Like' button to your dynamic page.

To tell Facebook you want Likes on your page, your server code will create some special Facebook tags to tell Facebook about the current webpage. In my example (shldz.us/travels), I want each image to be seen to Facebook as a separate page with its own 'Likes.'

When the page is created you add the "meta property='og:url' content='$url'" tag, which is used to tell Facebook what URL to consider for Likes. <b>But the server doesn't know what we actually want Liked because it is described in the fragment identifier, <i>which the server never gets to see</i></b>!!

##The Solution

There are probably several answers to solve this problem, but the one I came up with is pretty simple: just write your code to respond to a query string (the stuff following a ?) by sending the user to the same exact URL with a fragment identifier instead.

For example, if your server receives a request for shldz.us/travels?anawesomeimage, you will be able to create the Facebook meta tags with this URL (in case Facebook is checking up on us) and return the page to the client. So you would have something like the following at the beginning of your page (PHP example):

```php
$qs = $_SERVER['QUERY_STRING'];
if($qs){
  $url = "http://" . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
  echo "<meta property='og:url' content='$url' />";
  //Create any other tags you want....
}
```

This page gets returned to the requester, satisfying any requests from Facebook robots.

Then, you could write your client code to respond to query strings and fragment identifiers the exact same way, but I chose a less elegant and more easier approach:

```javascript
if(location.search){ //Check if there is a query string in the URL
    var temp = location.search.substring(1); //Get the query string without the '?'
    var url = 'http://shldz.us/travels/#' + temp; //Use the query string as the fragment identifier
    window.location = url; //Redirect the user
}
```

Javascript simply redirects the user to shldz.us/travels#anawesomeimage, and from here your client code will know what to do. This is admittedly inelegant since it means redirecting a user as soon as a page is received, but for my situation it seems fine.

Now, whenever you are talking to Facebook about your web resources (in code or when posting on Facebook) you will always use the URL with the query string. Users will be able to click it to visit your site and not know the difference.

Go ahead, visit http://shldz.us/travels/?New_York+http://shldz.us/travels/Now/2014/2013/New_York/IMG_1583.JPG and look for the query string once the page has loaded (hint: there won't be one, even though the link has one).

This solved my problem but might not solve everyone's, so take it for what it's worth (free).
