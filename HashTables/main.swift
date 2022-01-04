//
//  main.swift
//  HashTables
//
//  Created by Ben Garrison on 1/4/22.
//

import Foundation

/*
 Key/value pair structure for searching super fast. Swift Dictionary = hash table.
 In Swift, all built in data structures (String, Int, etc.) already have a hash value. Just add .hashValue to end of variable name to retrieve its hash value.
 Has tables are super fast!! --> standard case O(1), worst case O(n). Assume O(1) for interview purposes.
 
 You can use the modulo operator to reduce the aray size of your hash value array:
 Ex:
 let mainBase = GridPoint(x: 131, y: 541)
 let hashCode = mainBase.hashValue
 
 let initialSize = 16
 let index = hashCode % initialSize // guaranteed fit
 let indexPositive = abs(index)
 
 Sometimes two hashes will collide at the same index. At that point, we can save them both to a linked list pointing to the same head node (aka "chaining")

 */

//MARK: Building a hash table from scratch:

//linked List

class HashEntry {
    var key: String
    var value: String
    var next: HashEntry?
    
    init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
}

class HashTable {
    private static let initialSize = 256
    private var entries = Array<HashEntry?>(repeating: nil, count: initialSize)
    
    func put(_ key: String, _ value: String) {
        //get the index
        let index = getIndex(key)
        
        //create entry
        let entry = HashEntry(key, value)
        
        //if no existing entry - store it
        if entries[index] == nil {
            entries[index] = entry
        }
        else {
            var collisions = entries[index]
            
            //walk to the end
            while collisions?.next != nil {
                collisions = collisions?.next
            }
            
            //add collision here
            collisions?.next = entry
        }
    }
    
    func get(_ key: String) -> String? {
        //get the index
        let index = getIndex(key)
        
        // get current list of entries for this index
        let possibleCollisions = entries[index]
        
        // walk likned list looking for possible key match
        var currentEntry = possibleCollisions
        while currentEntry != nil {
            if currentEntry?.key == key {
                return currentEntry!.value
            }
            currentEntry = currentEntry?.next
        }
        return nil
    }
    
    private func getIndex(_ key: String) -> Int {
        //get the key's hash code
        let hashCode = abs(key.hashValue)
        
        //normalize it into an acceptable index
        let index = hashCode % HashTable.initialSize
        print("\(key) \(hashCode) \(index)")
        
        //forced collision for demonstration purposes (not working?)
        if key == "Ben Garrison" || key == "Hana Inoue" {
            return 152
        }
        return index
    }
    
    func prettyPrint() {
        for entry in entries {
            if entry == nil {
                continue
            }
            if entry?.next == nil {
                print("key: \(String(describing: entry?.key)) value: \(String(describing: entry?.value))")
            } else {
                //collisions
                var currentEntry = entry
                while currentEntry?.next != nil {
                    print("💥!!! key: \(String(describing: currentEntry?.key)) value: \(String(describing: currentEntry?.value))")
                    currentEntry = currentEntry?.next
                }
                print("💥!!! key: \(String(describing: currentEntry?.key)) value: \(String(describing: currentEntry?.value))")
            }
        }
    }
    
    subscript(key: String) -> String? {
        get {
            get(key)
        }
        set (newValue) {
            guard let value = newValue else { return }
            put(key, value)
        }
    }
}

let hashTable = HashTable()
hashTable.put("Ben Garrison", "521-1234")
hashTable.put("Lisa Smith", "521-8976")
hashTable.put("Sam Doe", "521-5030")
hashTable.put("Hana Inoue", "521-9655")
hashTable.put("Ted Baker", "418-4165")

hashTable.prettyPrint()


