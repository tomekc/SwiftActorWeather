//
//  JSONMapperTests.swift
//  JSONMapperTests
//
//  Created by Tomek Cejner on 08/07/14.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import XCTest
import JSONMapper

class JSONMapperTests: XCTestCase {
    
    var data : NSData?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        data = loadFromFile("example")

    }
    
    func loadFromFile(name:String) -> NSData {
        let filepath = NSBundle(forClass: JSONMapperTests.self).pathForResource(name, ofType: "json")
        return NSData.dataWithContentsOfFile(filepath, options: nil, error: nil)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func testSimple() {
        
        let object = Person(JSONMapper.context(data!))
        
        XCTAssertEqual(object.name!, "John Appleseed", "String field don't match")
        XCTAssertEqual(object.id!, 9001, "Integer field don't match")
        XCTAssertEqual(object.active!, true, "Boolean don't match")
    
    }
    
    func testNestedObject() {
        let object = Person(JSONMapper.context(data!))
        let state = object.address?.state
        
        XCTAssertEqual(state!, "CA", "State in nested object do not match")
        
    }
    
    func testArray() {
        let object = Person(JSONMapper.context(data!))
        let tab = object.roles
        
        XCTAssertEqualObjects(["ADMINISTRATOR","EMPLOYEE"], tab, "Arrays don't match")
    }
    
    func testIncomplete() {
        let dataIncomplete = loadFromFile("example-incomplete")
        let object = Person(JSONMapper.context(dataIncomplete))
        
        XCTAssertEqual(object.id!, 9001)
        XCTAssert( object.name == .None, "Name should be blank")
        XCTAssertFalse( object.address, "Nested object should be blank")
        XCTAssertEqualObjects(object.roles, [])
    }
    
    func testMalformedJSON() {
        let dataMalformed = loadFromFile("example-invalid")
        let context = JSONMapper.context(dataMalformed)
        let person = Person(context)
        
        XCTAssertFalse(context)
        XCTAssertFalse(context.valid)
        XCTAssert(person.name == .None, "Person should be non-blank")
        XCTAssertFalse( person.address, "Nested object should be blank")
        XCTAssertEqualObjects(person.roles, [])

    }
}
