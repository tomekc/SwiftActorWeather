# Swift Actor Framework, JSON Mapper and Optionals extension demo

This project was intented to demo an Actor framework I am developing, [Swift Actors](https://github.com/tomekc/SwiftActors). In addition, I used [JSON to Swift object mapper](https://github.com/tomekc/SwiftJSONMapper) and small [extensions to Swift's Optionals](https://gist.github.com/tomekc/a1e21f588eacdad1c860) 

## What are actors?

Actor model is an approach to concurrency known in Erlang, and implemented in Scala. For JVM there is popular framework, [Akka](http://www.akka.io)

Actor model is an approach to make massive concurrency much easier by eliminating locking and synchronization, which is hard to master and may lead to difficult to detect bugs.

Altough iOS apps are not going to tackle such problems, I found actors as a interesting abstraction over concurrent computation. 

In a nutshell, actor is a small task processor with inbox to which it is accepting messages. This is why sometimes actor model is called *message-passing style of concurrency*. Messages are sent asynchronously, but actor is processing them one at time. Processing outcome is usually sending a message to another actor, and so on.
Most likely, last actor in "chain" will be responsible for output.

Messages sent to actors are (should be) immutable, so Swift's struct are good fit, making syntax similar to Scala's case classes.

Actors can handle any type of message, and Swift's pattern matching (just like in Scala) is used inside actor.

Actors are created by extending **Actor** or **ActorUI** class and overriding `receive(message: Any)` method.

## Example app

Example app has one view with UITableView presenting current weather conditions for number of cities. Weather data is [Open Weather Map](http://www.openweathermap.org/).

Example is built on two actors: 

  * WeatherDownloader - which checks for messages of `WeatherFetchMessage` type, downloads data by REST API, and sends a update message to:
  * TableViewUpdateActor - which updates single TableView cells.
  
Internally actors are run on GCD, which greatly simplifies operation. Two types of actors are available:

  * Actor - Generic actor, build on GCD background queue
  * ActorUI - executes on main thread, therefore can be used for UI updates
  
### Files to look at

**WeatherService.swift**
Model classes (mapped from JSON using my other project, SwiftJSONMapper), message structures, actor classes.

## Caveats

Swift's classes are scoped per module, yet there is no easy way to drop dependency in and use my custom frameworks (Actors, JSON Mapper). CocoaPods still wins.

No abstract or private methods in Swift makes harder to tell which methods have to be overloaded.

I'm not happy with some names and they may change in future.

# Contact me

  * Twitter [@tomekcejner](http://twitter.com/tomekcejner)
  * E-Mail tomek dot cejner at gmail com
  