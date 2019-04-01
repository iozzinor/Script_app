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
// MARK: - STL ERROR
// -----------------------------------------------------------------------------
enum StlError: Error
{
    case fileToSmall(size: Int)
    case unexpectedFileSize(actual: Int, expected: Int)
    case trianglesCountMismatch(actual: Int, expected: Int)
}

extension SCNNode
{
    static func load(stlFileUrl: URL, meshOnly: Bool = false) throws -> SCNNode
    {
        let data = try Data(contentsOf: stlFileUrl, options: .alwaysMapped)
        guard data.count > 84 else
        {
            throw StlError.fileToSmall(size: data.count)
        }
        
        let triangleTarget: UInt32 = data.scanValue(start: 80, length: 4)
        let triangleBytes = MemoryLayout<Triangle_>.size
        let expectedFileSize = 84 + triangleBytes * Int(triangleTarget)
        guard data.count == expectedFileSize else
        {
            throw StlError.unexpectedFileSize(actual: data.count, expected: expectedFileSize)
        }
        
        var normals = Data()
        var vertices = Data()
        var trianglesCounted = 0
        
        for index in stride(from: 84, to: data.count, by: triangleBytes)
        {
            trianglesCounted += 1
            
            let triangleData = data.subdata(in: index..<index+triangleBytes)
            var triangle: Triangle_ = triangleData.withUnsafeBytes { $0.pointee }
            var normal = triangle.normal
            if normal.isNull
            {
                normal = createNormal(triangle: triangle)
            }
            let normalData = normal.unsafeData()
            normals.append(normalData)
            normals.append(normalData)
            normals.append(normalData)
            
            vertices.append(triangle.vertex1.unsafeData())
            vertices.append(triangle.vertex2.unsafeData())
            vertices.append(triangle.vertex3.unsafeData())
        }
        
        guard triangleTarget == trianglesCounted else
        {
            throw StlError.trianglesCountMismatch(actual: trianglesCounted, expected: Int(triangleTarget))
        }
        
        let vertexSource = SCNGeometrySource(data: vertices,
                                             semantic: .vertex,
                                             vectorCount: trianglesCounted * 3,
                                             usesFloatComponents: true,
                                             componentsPerVector: 3,
                                             bytesPerComponent: MemoryLayout<Float>.size,
                                             dataOffset: 0,
                                             dataStride: MemoryLayout<SCNVector3>.size)
        
        let normalSource = SCNGeometrySource(data: normals,
                                             semantic: .normal,
                                             vectorCount: trianglesCounted * 3,
                                             usesFloatComponents: true,
                                             componentsPerVector: 3,
                                             bytesPerComponent: MemoryLayout<Float>.size,
                                             dataOffset: 0,
                                             dataStride: MemoryLayout<SCNVector3>.size)
        
        let use8BitIndices = MemoryLayout<UInt8>.size
        let countedTriangles = SCNGeometryElement(data: nil, primitiveType: .triangles, primitiveCount: trianglesCounted, bytesPerIndex: use8BitIndices)
        
        
        var lines: [UInt32] = []
        for i in 0..<trianglesCounted
        {
            let index = UInt32(i)
            lines.append(index * 3)
            lines.append(index * 3 + 1)
            lines.append(index * 3 + 2)
            lines.append(index * 3)
        }
        var materials = [SCNMaterial]()
        var elements = [SCNGeometryElement]()
        
        if meshOnly
        {
            let lineMaterial = SCNMaterial()
            lineMaterial.diffuse.contents = UIColor.blue
            materials.append(contentsOf: Array<SCNMaterial>(repeating: lineMaterial, count: lines.count / 2))
            
            let linesElement = SCNGeometryElement(indices: lines, primitiveType: .line)
            linesElement.pointSize = 3.0
            
            elements.append(linesElement)
        }
        else
        {
            let triangleMaterial = SCNMaterial()
            triangleMaterial.diffuse.contents = UIColor.white
            
            materials.append(contentsOf: Array<SCNMaterial>(repeating: triangleMaterial, count: trianglesCounted * 3))
            
            elements.append(countedTriangles)
        }
        let geometry = SCNGeometry(sources: [vertexSource, normalSource], elements: elements)
        
        geometry.materials = materials
        
        let result = SCNNode(geometry: geometry)
        return result
    }
}

// -----------------------------------------------------------------------------
// MARK: - STRUCTURES
// -----------------------------------------------------------------------------
private struct Triangle_
{
    var normal: SCNVector3
    var vertex1: SCNVector3
    var vertex2: SCNVector3
    var vertex3: SCNVector3
    var attributes: UInt16
}

private extension SCNVector3
{
    mutating func unsafeData() -> Data
    {
        return Data(buffer: UnsafeBufferPointer(start: &self, count: 1))
    }
    
    var isNull: Bool
    {
        return x == 0 && y == 0 && z == 0
    }
    
    var length: Float
    {
        return sqrt(x * x + y * y + z * z)
    }
    
    mutating func normalize()
    {
        let currentLength = length
        if currentLength > 0
        {
            self.x /= currentLength
            self.y /= currentLength
            self.z /= currentLength
        }
    }
}

private extension Data
{
    func scanValue<T>(start: Int, length: Int) -> T
    {
        return self.subdata(in: start..<start+length).withUnsafeBytes { $0.pointee }
    }
}

// -----------------------------------------------------------------------------
// MARK: - FUNCTIONS
// -----------------------------------------------------------------------------
private func vector(_ vertex1: SCNVector3, _ vertex2: SCNVector3) -> SCNVector3
{
    return SCNVector3(vertex2.x - vertex1.x, vertex2.y - vertex1.y, vertex2.z - vertex1.z)
}

private func computeNormal(_ v1: SCNVector3, _ v2: SCNVector3) -> SCNVector3
{
    let x = v1.y * v2.z - v1.z * v2.y
    let y = v1.z * v2.x - v1.x * v2.z
    let z = v1.x * v2.y - v1.y * v2.x
    var result = SCNVector3(x, y, z)
    result.normalize()
    return result
}

private func createNormal(triangle: Triangle_) -> SCNVector3
{
    var normal = SCNVector3()
    var vector1 = vector(triangle.vertex1, triangle.vertex2)
    var vector2 = vector(triangle.vertex1, triangle.vertex3)
    normal = computeNormal(vector1, vector2)
    
    if normal.isNull
    {
        vector1 = vector(triangle.vertex1, triangle.vertex3)
        vector2 = vector(triangle.vertex2, triangle.vertex3)
        normal = computeNormal(vector1, vector2)
    }
    return normal
}
