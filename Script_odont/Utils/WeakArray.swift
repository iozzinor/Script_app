//
//  WeakArray.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

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
    
    fileprivate var objects_ = [WeakContainer<T>]()
    
    subscript(index: Int) -> T?
    {
        get {
            
            return objects_[index].referred
        }
        set {
            objects_[index] = WeakContainer<T>(t: newValue)
        }
    }
    
    func append(_ t: T?)
    {
        objects_.append(WeakContainer<T>(t: t))
    }
    
    func remove(at index: Int) -> WeakContainer<T>
    {
        return objects_.remove(at: index)
    }
    
    var count: Int {
        return objects_.count
    }
    
    func makeIterator() -> Iterator
    {
        return Iterator(array: self)
    }
}
