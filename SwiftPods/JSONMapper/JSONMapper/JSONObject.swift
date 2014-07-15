//
//  JSONObject.swift
//  JSONMapper
//
//  Created by Tomek Cejner on 08/07/14.
//  Copyright (c) 2014 Tomek Cejner. All rights reserved.
//

import Foundation

protocol JSONSerializable {
    
    init(_ c:JSONDeserializationContext)
    
}

class JSONDeserializationContext : LogicValue {
    
    var source:NSDictionary
    var valid:Bool
    
    init(source:NSDictionary?) {
        if let dic = source {
            valid = true
            self.source = source!            
        } else {
            valid = false
            self.source = NSDictionary.dictionary()
        }
    }
    
    func getLogicValue() -> Bool {
        return valid
    }
    
    func getString(field:String) -> String? {
        return self.source[field] as String?
    }
    
    func getInt(field:String) -> Int? {
        return self.source[field] as Int?
    }
    
    func getBool(field:String) -> Bool? {
        return self.source[field] as Bool?
    }
    
    func getObject<T:JSONSerializable>(field:String, ofClass:T.Type) -> T? {
        if let dataField: AnyObject! = source[field] {
            return ofClass(JSONMapper.buildContext(dataField))            
        } else {
            return Optional<T>.None
//            return ofClass(JSONMapper.buildContext(NSDictionary.dictionary()))
        }
    }
    
    func getArray<T>(field:String) -> Array<T> {
        if let array = source[field] as? Array<T> {
                return array
        } else {
            return []
        }
        
    }
    
}

class JSONMapper {
    class func context(data:NSData) -> JSONDeserializationContext {
        if let obj:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
            return buildContext(obj)
        } else {
            return buildContext([])
        }
    }
    
    class func context(stream:NSInputStream) -> JSONDeserializationContext {
        let obj:AnyObject = NSJSONSerialization.JSONObjectWithStream(stream, options: nil, error: nil)
        return buildContext(obj)
    }
    

    class func buildContext(jsonObject:AnyObject) -> JSONDeserializationContext {
        switch (jsonObject) {
            // TODO support arrays as top-level objects
        case let dic as NSDictionary:
            return JSONDeserializationContext(source: dic)
        default:
            return JSONDeserializationContext(source: nil)
        }
        
    }
    
    
}
