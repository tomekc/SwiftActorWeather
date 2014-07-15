# JSON to Swift object mapper

## Overview

This is an attempt to solve a problem of mapping JSON data onto matching Swift objects. Apparently, Swift language is designed to be more static than Objective-C, and some reflection voodoo is not going to work. It is hard to predict if it will be ever possible.

With JSONMapper, Swift objects which are mappable from JSON shall implement  `JSONSerializable` protocol. This is quite strong requirement: however, most likely you are owner of mapped objects and you can conform to multiple protocols.

## Features

JSONMapper is able to map

  * Strings
  * Integers
  * Booleans
  * Nested objects
  * Nested arrays
  
  
## Using JSONMapper

For given example JSON content

	{
      "id": 9001,
      "type": "EMPLOYEE",
      "active": true,
      "name": "John Appleseed",
      "address": {
        "city": "Cupertino",
        "state": "CA"
      },
	  "roles": [
		"ADMINISTRATOR",
		"EMPLOYEE"
	  ]
    }

You can create following classes:

	class Person : JSONSerializable {
        var name : String?
        var id : Int?
        var address : Address?
        var active : Bool?
        var roles : Array<String>
        
        init(_ c: JSONDeserializationContext)  {
            self.name = c.getString("name")
            self.id = c.getInt("id")
            self.address = c.getObject("address", ofClass: Address.self)
            self.active = c.getBool("active")
            self.roles = c.getArray("roles")
        }
    }
    
    class Address : JSONSerializable {
        var city : String?
        var state : String?
        
        init(_ c: JSONDeserializationContext) {
            println("Initializing Address with ")
            println(c)
            self.city = c.getString("city")
            self.state = c.getString("state")
        }
    }

    
`JSONSerializable` protocol specifies initializer which accepts one argument of `JSONDeserializationContext` type.

Inside initializer, you need to set all properties of object. Values are provided by JSONDeserializationContext by following methods:

  * getString(field: String)
  * getInt(field: String)
  * getBool(field: String)
  * getObject(field: String, ofClass: *TypeName*.self)
  * getArray(field: String)

Simple values are returned as Optional, thus the fields shall be defined that way.

Objects are returned as Optional.

Arrays are always returned, regardless the field exists or not. If value is missing, empty array is returned, following **Null object pattern**.


### Building deserialization context

JSONMapper is a wrapper on Apple's `NSJSONSerialization`, and similarly accepts `NSData` or `NSStream` as input.

You build context using `JSONMapper.context` class method.

	import JSONMapper
	// ...

	// data is NSData with JSON content
	let context = JSONMapper.context(data)
    let person = Person(context)

## Error handling

Missing and extranous fields in JSON are ignored.

When malformed JSON is provided, `JSONDeserializationContext`'s field `valid` is set to **false**. It also conforms to `LogicValue` protocol, so can be used in *if* statement:

	let context = JSONMapper.context(dataMalformed)
    let person = Person(context)
    
    if (context) {
    	// ... do something
    }

Note that, Person instance will be created even though deserialization context is invalid. This is conscious design decision :)        

## Limitations

This is working proof-of-concept, not ready yet for production use. Look into `JSONMapperTests.swift` for test cases.

### Known missing features

Only dictionaries as top-level objects are supported now.
