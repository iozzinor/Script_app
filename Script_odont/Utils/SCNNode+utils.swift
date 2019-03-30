//
//  SCNNode+utils.swift
//  Script_odont
//
//  Created by Régis Iozzino on 30/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation
import SceneKit

// -----------------------------------------------------------------------------
// MARK: - STRUCTURES
// -----------------------------------------------------------------------------
fileprivate struct Vector_
{
    var x: Double
    var y: Double
    var z: Double
    
    var scnVertex: SCNVector3 {
        return SCNVector3(x: Float(x), y: Float(y), z: Float(z))
    }
    
    var debugString: String {
        return "\(x) \(y) \(z)"
    }
}

fileprivate struct Triangle_
{
    var normal: Vector_
    var vertex1: Vector_
    var vertex2: Vector_
    var vertex3: Vector_
    
    var attribute: UInt16
}

fileprivate func readInteger_<Integer: FixedWidthInteger>(from data: Data, offset: Int) -> Integer
{
    var result = Integer(0)
    
    for i in 0..<MemoryLayout<Integer>.size
    {
        let currentByte = Integer(data[i + offset])
        
        result += currentByte << (i * 8)
    }
    
    return result
}

fileprivate func readReal_(from data: Data, offset: Int) -> Double
{
    // the number is read as big endian
    let number: UInt32 = readInteger_(from: data, offset: offset)
    
    let sign = Int(number >> 31) == 1 ? -1 : 1
    let exponent = Int((number >> 23) & 0xFF)
    let fractionInteger = Int(number & ((1 << 24) - 1))
    var fraction = 1.0
    
    for i in 0..<23
    {
        let currentBit = fractionInteger >> i & 1
        
        fraction += Double(currentBit) * pow(2.0, Double(i - 23))
    }
    
    return Double(sign) * pow(2.0, Double(exponent - 127)) * fraction
}

fileprivate func readVector_(from data: Data, offset: Int) -> Vector_
{
    let x = readReal_(from: data, offset: offset)
    let y = readReal_(from: data, offset: offset + 4)
    let z = readReal_(from: data, offset: offset + 8)
    
    return Vector_(x: x, y: y, z: z)
}

fileprivate func readTriangle_(from data: Data, offset: Int) -> Triangle_
{
    let normal              = readVector_(from: data, offset: offset)
    let vector1             = readVector_(from: data, offset: offset + 12)
    let vector2             = readVector_(from: data, offset: offset + 24)
    let vector3             = readVector_(from: data, offset: offset + 36)
    let attribute: UInt16   = readInteger_(from: data, offset: offset + 48)
    
    return Triangle_(normal: normal, vertex1: vector1, vertex2: vector2, vertex3: vector3, attribute: attribute)
}

fileprivate func readTriangles_(from data: Data, trianglesCount: UInt32) -> [Triangle_]
{
    var offset = SCNNode.stlHeaderSize_ + 4
    var triangles = [Triangle_]()
    for _ in 0..<trianglesCount
    {
        let newTriangle = readTriangle_(from: data, offset: offset)
        offset += 50
        
        triangles.append(newTriangle)
    }
    return triangles
}

fileprivate func verticesGeometry_(inputTriangles: [Triangle_]) -> SCNGeometry
{
    var vertices = [SCNVector3]()
    var indices: [UInt16] = []
    var normals = [SCNVector3]()
    
    for (i, triangle) in inputTriangles.enumerated()
    {
        vertices.append(triangle.vertex1.scnVertex)
        vertices.append(triangle.vertex2.scnVertex)
        vertices.append(triangle.vertex3.scnVertex)
        
        normals.append(contentsOf: Array<SCNVector3>(repeating: triangle.normal.scnVertex, count: 3))
        
        for j in 0..<3
        {
            indices.append(UInt16(3 * i + j))
        }
    }
    
    let verticesSource = SCNGeometrySource(vertices: vertices)
    let verticesElement = SCNGeometryElement(indices: indices, primitiveType: .triangles)
    let normalsSource = SCNGeometrySource(normals: normals)
    
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.white
    let result = SCNGeometry(sources: [verticesSource, normalsSource], elements: [verticesElement])
    result.materials = Array<SCNMaterial>(repeating: material, count: inputTriangles.count)
    return result
}

extension SCNNode
{
    // The size of an STL header in bytes.
    fileprivate static let stlHeaderSize_ = 80
    
    static func fromStlFile(filePath: String) -> SCNNode?
    {
        guard let fileData = FileManager.default.contents(atPath: filePath),
            fileData.count > SCNNode.stlHeaderSize_ else
        {
            return nil
        }
        
        // triangles count
        let trianglesCount: UInt32 = readInteger_(from: fileData, offset: SCNNode.stlHeaderSize_)
        let triangles = readTriangles_(from: fileData, trianglesCount: trianglesCount)
        
        let geometry = verticesGeometry_(inputTriangles: triangles)
        
        let newNode = SCNNode(geometry: geometry)
        return newNode
    }
}
