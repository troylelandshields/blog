title: firebase-alphaqueuejs
date: 2016-08-11 22:45:51
tags: firebase firebase-queue
excerpt: true
---

## Firebase is awesome. 
Every sideproject I work on will utilize Firebase in some form or another. It is too simple and too fast to ignore when trying to prototype or build something quickly; there really is no substitute. You have instant access to a fast, scalable, real-time database from basically any client that needs to store or retrieve data. You spend exactly zero minutes configuring Apache servers when you use Firebase. In short, it's dope AF. 

## Firebase, however, is not perfect.
I use Firebase to store data about the infinite grid of 64 px by 64 px boxes on [Murinal](http://shldz.us/murinal). Even on a small project like _Murinal_, the interaction with Firebase gets messy very quickly. If you've used Firebase a couple of times I think you know what I'm talking about. (If you've used it more than a couple of times, maybe you've learned how to avoid the messiness and I implore you to share with the rest of us).

<!-- more -->

Why does Firebase get or feel messy? It turns out that the accessibility that Firebase offers is also one of its biggest problems: _ALL of the clients have access to ALL of the data ALL of the time._ There is no domain-level abstraction to protect your data. After three weeks of moonlighting on your project you will open it one day and suddenly realize you have _no idea_ which functions are accessing what data in your application.

This problem is compounded by the fact that proper use of Firebase requires a surprising amount of data duplication. I won't get into it too deeply, but most relationships between data types have to exist in both directions. For example, when setting the `eats` field of `cheetah` to `gazelle`, you musn't forget to set `eatenBy` field of `gazelle` to `cheetah`. Suddenly updating one simple field requires touching two entirely different pieces of data in your database. Abstracting this to a higher-level API can understandably become messy.

The problem is *even further compounded* by the fact that you would have to duplicate this logic in your web, iOS, and Android apps. We have to break one of the cardinal rules of the [Pragmatic Programmer](https://www.amazon.com/Pragmatic-Programmer-Journeyman-Master/dp/020161622X) _twice_ just to update a single relationship.

Firebase requires that you duplicate data throughout your database and duplicate logic throughout your clients. It ends up being very important to get your data structure correct in the beginning of your prototyping because making even small changes later becomes a huge PITA.

## Firebase Queue to the rescue.

I was recently introduced to [Firebase Queue](https://github.com/firebase/firebase-queue) by my good friend Doug Leonard. This library utilizes your Firebase database to define a pipeline of tasks. You can push data onto a task where it will wait for a worker process to pick it up and carry it through the task lifecycle, updating the state as it goes. The [Firebase Queue Guide](https://github.com/firebase/firebase-queue/blob/master/docs/guide.md#purpose-of-a-queue) lists a myriad of reasons for why you might use it, but I want to focus on one in-particular: "fanning data out to multiple locations in your Firebase database." I have already mentioned the horrible sin we have to commit of duplicating logic and data to use Firebase, but Firebase Queue gives us the capability to funnel the data duplication through a single piece of code, thereby eliminating the need to duplicate logic.

So what does this look like? Well, you define a task for updating the `eats` field of an animal, for example. Every animal `eats` something, and every animal can have an `eatenBy` field as well. You create an `updateEatsWorker` that will wait for an `updateEatsTask` to be created. Instead of setting the `eats` and `eatenBy` data directly into your database, you push it as a task to the `updateEatsTask` queue and allow your worker to create the relationship between predator and prey and vice-versa.

With this approach, all of your clients (Android, iOS, web, Windows 95, etc.) can execute the exact same single interaction with Firebase without having to worry about the business logic of how to associate predator animals with prey animals. If the structure of the relationship between these two entities ever changes, you simply need update one area of code instead of 3 or infinite. Using Firebase Queue to fan out data in this way really does greatly simplify the work each client has to do when adding data to the database. The only complication is that at least 1 worker process has to be running on a machine somewhere ready to process `updateEatsTasks`. Admittedly, we are moving back towards a `server-client` configuration (although still immensely simpler). 

You can see how creating an `updateEatsWorker` that executes some process when an `updateEatsTasks` is created is very similar to passing data to a server through an API. It allows a single point of entry to your data and helps you protect your database from being touched by every part of the application(s).

## Alpha Queue ups the ante.

Doug pretty much blew my mind with Firebase Queue. It is absolutely awesome. In fact, it is so awesome that I think they were much too conservative with their list of recommended uses. Firebase Queue should be the _only_ way you access or update data from your any of your clients. It is my new belief that you should never directly touch any data in your Firebase Database from your client, opting instead to push tasks to the queue.

The new model is what we just described: clients push various tasks into your queue; worker does work on tasks; clients wait for results from the worker. Your clients only touch _a single child_ in your Firebase database: tasks. They push specific tasks to do specific work, and all of the business logic is handled by your queue worker(s). What once was a huge mess becomes highly organized. The available tasks you can create act as a domain-level abstraction or API that protects your Firebase data from yourself-3-weeks-ago, mitigating one of Firebase's huge weakness.

To make this even easier to practice for myself, I built a JavaScript library to allow interacting with Firebase Queue in exactly this way that is dead-simple to use. `Firebase-AlphaQueue` is meant to be used by your clients to push tasks to your Firebase Queue and receive results when those tasks are completed by workers. You simply tell the AlphaQueue the names of the tasks (or jobs) you want to be able to access and it makes an API available for you to interact with your data. Here is an example:

```js
//Get a ref to the task child of your firebsae database
var firebaseTaskRef = rootFirebaseRef.child("queue").child("tasks")

//Instantiate a new Alpha Queue service with the names of your tasks.
//AlphaQueue assumes your specs define states in the following way:
//      starting state = taskName_start
//      error state = taskName_error
//      finished state = taskName_finished
var animalSvc := new AlphaQueue(firebaseTaskRef, [
    "createAnimal",
    "feedAnimal",
    "petAnimal",
    "findAnimal"
]);
```

The `animalSvc` now has methods called `createAnimal`, `feedAnimal`, `petAnimal`, and `findAnimal` and is ready to start being used.

```js
//Push data to the queue and get a promise back
var dogPromise = animalSvc.createAnimal({
    name: "dog",
    slogan: "man's best friend"
});
```

When you call these methods you are actually pushing a task onto your Firebase Queue and AlphaQueue is listening to tell you via a promise when it is either finished or errored out so that you can use the results of that task.

```js
//The promise is resolved when the task is finished (or rejected on error)
dogPromise.then(function(dog){

    var catPromise = animalSvc.createAnimal({
        name: "cat",
        slogan: "alpha queue up",
        chases: {
            dog.id: true
        }
    });

    catPromise.then(function(cat){
        animalSvc.feedAnimal(cat.id)
    });
});

var cowPromise = animalSvc.findAnimal("cow");

cowPromise.then(function(cow) {
    console.log("Found:", cow)
}, function(error) {
    console.log("Not found:", error)
});

```

Neat right!? This client doesn't have to know or care _at all_ where dog or cat or cow are stored; it doesn't have to know how the relationship between them is defined. You now don't have to worry about getting your database structure exactly correct from the beginning of your project because you can easily change it later without affecting 10 different pieces of code in your client(s). You can even utilize versioned tasks to emulate a versioned API.

If you are using Firebase you should absolutely be protecting your data from yourself, but you don't need to go back to the old way of creating a heavy-handed web API service. Utilize Firebase Queue and AlphaQueueJS to keep your clients *dumb* about how you store your data without sacrificing any of the simplicity of Firebase.

I am sure there are other ways to achieve the same goal, but I intend to use AlphaQueue throughout the building of our latest [side project](https://github.com/troylelandshields/call-distributor) to see how it helps reduce the "messiness" that I have always experienced with Firebase.
