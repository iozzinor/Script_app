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
/// STL load errors
enum StlError: Error
{
    /// The file size is smaller than expected.
    case fileToSmall(size: Int)
    
    /// The file size does not match the expected one.
    case unexpectedFileSize(actual: Int, expected: Int)
    
    // Wrong triangles count.
    case trianglesCountMismatch(actual: Int, expected: Int)
}

extension SCNNode
{
    /// Load a node from an STL file.
    ///
    /// - parameter stlFileUrl: The file URL.
    /// - parameter meshOnly: Whether the object is loaded with faces or meshes.
    /// - parameter parseColors: Whether the triangles 2 byte attributes are used
    /// to define the colors.
    ///
    /// - returns: The loaded node.
    static func load(stlFileUrl: URL, meshOnly: Bool = false, parseColors: Bool = false) throws -> SCNNode
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
        var colors = [UIColor]()
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
            
            if parseColors
            {
                colors.append(colorFromAttributes(triangle.attributes))
            }
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
            if !parseColors
            {
                let triangleMaterial = SCNMaterial()
                triangleMaterial.diffuse.contents = UIColor.white
                materials.append(triangleMaterial)
                elements.append(countedTriangles)
            }
            else
            {
                generateColors(elements: &elements, materials: &materials, colors: colors)
            }
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
/// A triangle.
private struct Triangle_
{
    /// The normal vector.
    var normal: SCNVector3
    /// The first vector.
    var vertex1: SCNVector3
    /// The second vector.
    var vertex2: SCNVector3
    /// The third vertex.
    var vertex3: SCNVector3
    /// The attributes.
    var attributes: UInt16
}

private extension SCNVector3
{
    /// Convert the vertex to binary representation.
    mutating func unsafeData() -> Data
    {
        return Data(buffer: UnsafeBufferPointer(start: &self, count: 1))
    }
    
    /// Whether the vertex is null.
    var isNull: Bool
    {
        return x == 0 && y == 0 && z == 0
    }
    
    /// The vertex length.
    var length: Float
    {
        return sqrt(x * x + y * y + z * z)
    }
    
    /// Update the vertex to keep its direction and sens, but set its length to
    /// `1`.
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
    /// Convert a data interval to its value representation.
    ///
    /// - parameter start: The data interval start.
    /// - parameter length: The data interval length.
    func scanValue<T>(start: Int, length: Int) -> T
    {
        return self.subdata(in: start..<start+length).withUnsafeBytes { $0.pointee }
    }
}

// -----------------------------------------------------------------------------
// MARK: - FUNCTIONS
// -----------------------------------------------------------------------------
/// - returns: The vector passing by the two vertices.
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

/// Find a normal vector to the triangle face.
///
/// - parameter triangle: The triangle for which the normal is computed.
///
/// - returns: The new normal vector.
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

/// Extract the color from the triangle attributes.
///
/// - parameter attributes: The STL triangle attributes.
///
/// - returns: The encoded color.
private func colorFromAttributes(_ attributes: UInt16) -> UIColor
{
    let red     = CGFloat(attributes >> 11) / 31.0
    let green   = CGFloat((attributes >> 6) & 0x1F) / 31.0
    let blue    = CGFloat((attributes >> 1) & 0x1F) / 31.0
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

/// Add colors attribytes to the SceneKit elements.
private func generateColors(elements: inout [SCNGeometryElement], materials: inout [SCNMaterial], colors: [UIColor])
{
    let sortedColors = getSortedColors(colors: colors)
    for (color, triangleIndexes) in sortedColors
    {
        let triangleMaterial = SCNMaterial()
        triangleMaterial.diffuse.contents = color
        triangleMaterial.isDoubleSided = true // TEMP
        
        materials.append(triangleMaterial)
        
        var indexes: [UInt32] = []
        for triangleIndex in triangleIndexes
        {
            indexes.append(triangleIndex * 3)
            indexes.append(triangleIndex * 3 + 1)
            indexes.append(triangleIndex * 3 + 2)
        }
        
        elements.append(SCNGeometryElement(indices: indexes, primitiveType: .triangles))
    }
}

/// - returns: An dictionary of colors. The keys are the colors, and the values the indexes of the input colors.
private func getSortedColors(colors: [UIColor]) -> [UIColor: [UInt32]]
{
    let maximumColors = 65535
    
    var result = [UIColor: [UInt32]]()
    
    // get the colors count
    var colorsCount = [UIColor: Int]()
    for color in colors
    {
        if !colorsCount.keys.contains(color)
        {
            colorsCount[color] = 0
        }
        colorsCount[color]! += 1
    }
    
    // map the colors count as an array
    var colorsCountArray = [(UIColor, Int)]()
    for (color, count) in colorsCount
    {
        colorsCountArray.append((color, count))
    }
    // sort by occurence
    colorsCountArray.sort(by: { (a, b) -> Bool in
        return a.1 > b.1
    })
    
    var possibleColors = [UIColor]()
    for (i, colorCount) in colorsCountArray.enumerated()
    {
        if i > maximumColors - 1
        {
            break
        }
        possibleColors.append(colorCount.0)
    }
    
    // get the colors remap
    var colorRemap = [UIColor: UIColor]()
    for (i, colorCount) in colorsCountArray.enumerated()
    {
        if i < maximumColors
        {
            colorRemap[colorCount.0] = colorCount.0
        }
        else
        {
            colorRemap[colorCount.0] = findClosestColor(colorChoices: possibleColors, color: colorCount.0)
        }
    }
    
    // add indexes
    for (i, color) in colors.enumerated()
    {
        let closestColor = colorRemap[color] ?? UIColor.white
        
        if !result.keys.contains(closestColor)
        {
            result[closestColor] = []
        }
        
        result[closestColor]!.append(UInt32(i))
    }
    
    return result
}

/// Find the closest color.
///
/// - parameter colorChoices: list of colors, in which the result color is.
/// - parameter color: The target color.
///
/// - returns: The color from the list that is the closest to `color`.
private func findClosestColor(colorChoices: [UIColor], color: UIColor) -> UIColor
{
    var result = UIColor.white
    var minProximity: CGFloat = 3.0
    for colorChoice in colorChoices
    {
        let currentProximity = getColorProximity(colorChoice, color)
        
        if minProximity > currentProximity
        {
            minProximity = currentProximity
            result = colorChoice
        }
    }
    
    return result
}

/// - parameter a: The first color.
/// - parameter b: The second color.
///
/// - returns: The color proximity: the lower, the closer the colors are.
private func getColorProximity(_ a: UIColor, _ b: UIColor) -> CGFloat
{
    var aRed: CGFloat   = 0.0
    var aGreen: CGFloat = 0.0
    var aBlue: CGFloat  = 0.0
    var bRed: CGFloat   = 0.0
    var bGreen: CGFloat = 0.0
    var bBlue: CGFloat  = 0.0
    
    a.getRed(&aRed, green: &aGreen, blue: &aBlue, alpha: nil)
    b.getRed(&bRed, green: &bGreen, blue: &bBlue, alpha: nil)
    
    return abs(aRed - bRed) + abs(aGreen - bGreen) + abs(aBlue - bBlue)
}
