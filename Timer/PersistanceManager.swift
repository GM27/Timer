//
//  Persistance.swift
//  Timer
//
//  Created by Jeremy Merezhko on 8/14/22.
//

import Foundation


// creating a model to hold all of the information that we want to presist:
struct EncodingItems: Codable {
// All the data that we are going to save:
    // ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// all the main data about timers:
 var timers = [Timer2]()
 var originalTimers = [TimeToReset]()
 var cells = [CellModel]()
// The objects created is a cruicial proprty of Timer2:
var objectsCreated: Int
var exitDate = Date()
// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
// initializers empty and standart:
    init() {
   timers = [Timer2]()
    objectsCreated = 0
    originalTimers = [TimeToReset]()
    cells = [CellModel]()
    }
    
    init(timers: [Timer2], objectsCreated: Int,  originalTimers: [TimeToReset] , cells: [CellModel]) {
        self.timers = timers
        self.originalTimers = originalTimers
        self.objectsCreated = objectsCreated
        self.cells = cells
    }

// adding conformance to Encodable/Decodable Protocol:
// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    enum CodingKeys: String, CodingKey {
        case timers
        case objectsCreated
        case originalTimers
        case cells
        case exitDate
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cells, forKey: .cells)
        try container.encode(originalTimers, forKey: .originalTimers)
        try container.encode(objectsCreated, forKey: .objectsCreated)
        try container.encode(timers, forKey: .timers)
        try container.encode(exitDate, forKey: .exitDate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timers = try container.decode([Timer2].self, forKey: .timers)
        self.objectsCreated = try container.decode(Int.self, forKey: .objectsCreated)
        self.originalTimers = try container.decode([TimeToReset].self, forKey: .originalTimers)
        self.cells = try container.decode([CellModel].self, forKey: .cells)
        self.exitDate = try container.decode(Date.self, forKey: .exitDate)
      }
// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}


// Type that we are going to do all the encoding with:
struct Encode {
    // encoding and taking in the instance of EncodingItems, which holds all the data that we are going to presist:
    static func encode(encodingItems: EncodingItems) {
        print("encoding")
         let propertyListEncoder = PropertyListEncoder()
         if let encodedNote = try? propertyListEncoder.encode(encodingItems) {
             try? encodedNote.write(to: archieveURL, options: .noFileProtection)
          
         }
     }
    
  // decoding all the data and returning EncodingItems
    static func decode() -> EncodingItems {
        print("decoded")
        var decodedData1 = EncodingItems()
        let propertyListDecoder = PropertyListDecoder()
        if let retreivedData = try? Data(contentsOf: archieveURL), let decodedData = try? propertyListDecoder.decode(EncodingItems.self, from: retreivedData) {
           decodedData1 = decodedData
        
        }
        
        return decodedData1
    }
}

// The URL where we are going to archieve all the information:
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archieveURL = documentDirectory.appendingPathComponent("timer_persist").appendingPathExtension("plist")
