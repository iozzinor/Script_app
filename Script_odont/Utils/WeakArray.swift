//
//  WeakArray.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// An array of weak references.
class WeakArray<T>: Sequence
{
    struct Iterator: IteratorProtocol
    {
        var count = -1
        var array: WeakArray<T>
        
        init(array: WeakArray<T>)
        {
            self.array = array
        }
        
        mutating func next() -> T?
        {
            count += 1
            if count > array.count - 1
            {
                    return nil
            }
            
            return array[count]
        }
    }
    
    /// An array of the held object.
    fileprivate var objects_ = [WeakContainer<T>]()
    
    /// Get the referred object at index `index`.
    subscript(index: Int) -> T?
    {
        get {
            
            return objects_[index].referred
        }
        set {
            objects_[index] = WeakContainer<T>(t: newValue)
        }
    }
    
    /// Add a new object at the end of the array.
    ///
    /// - parameter t: The new object.
    func append(_ t: T?)
    {
        objects_.append(WeakContainer<T>(t: t))
    }
    
    /// Remove the object at the given index.
    ///
    /// - parameter index: The index for the object to remove.
    ///
    /// - returns: The removed object.
    func remove(at index: Int) -> WeakContainer<T>
    {
        return objects_.remove(at: index)
    }
    
    /// The number of held weak objects.
    var count: Int {
        return objects_.count
    }
    
    /// - returns: An iterator over the weak objects.
    func makeIterator() -> Iterator
    {
        return Iterator(array: self)
    }
}
