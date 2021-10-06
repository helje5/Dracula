//
//  Layout.swift
//  Dracula
//
//  Created by Helge Heß on 05.10.21.
//


/**
 * Result value for distributing nodes algorithms.
 *
 * A Layout is just an array of positions keyed on the node IDs now.
 */
public struct Layout<ID: Hashable>: Equatable {
  // The original stores the positions in the Graph / Graph nodes,
  // this uses Hashes, which is quite a bit slower. Depends on the
  // graph size...
  // TODO: wrap the Nodes into own LayoutNodes, which carry the info
  
  public typealias Point = LayoutPoint
  
  public struct Bounds: Equatable { // like a CGRect, but let keep it plain
    public var minx: Double
    public var maxx: Double
    public var miny: Double
    public var maxy: Double
  }

  public internal(set) var bounds : Bounds {
    set { _bounds = newValue }
    get { return _bounds ?? calculateBounds() }
  }

  internal var _bounds : Bounds?

  // Used to store the position for each node. Dracula stores this in-object.
  public var positions = [ ID : Point ]()
  
  // MARK: - Access
  
  public subscript(position nodeID: ID) -> Point {
    set { positions[nodeID] = newValue }
    get { return positions[nodeID] ?? .zero }
  }

  mutating func move(_ nodeID: ID, by dx: Double, _ dy: Double) {
    positions[nodeID, default: .zero].moveBy(dx, dy)
  }
  
  func calculateBounds() -> Bounds {
    guard !positions.isEmpty else {
      return Bounds(minx: 0, maxx: 0, miny: 0, maxy: 0)
    }
    
    var minx =  Double.infinity
    var maxx = -Double.infinity
    var miny =  Double.infinity
    var maxy = -Double.infinity

    positions.values.forEach { point in
      if point.x > maxx { maxx = point.x }
      if point.x < minx { minx = point.x }
      if point.y > maxy { maxy = point.y }
      if point.y < miny { miny = point.y }
    }
    
    return Bounds(minx: minx, maxx: maxx, miny: miny, maxy: maxy)
  }
}

public struct LayoutPoint: Equatable {

  public var x: Double
  public var y: Double
  
  public static let zero = LayoutPoint(x: 0, y: 0)

  @inlinable
  public mutating func moveBy(_ dx: Double, _ dy: Double) {
    x += dx
    y += dy
  }
  
  @inlinable
  public mutating func scaleBy(_ xScale: Double, _ yScale: Double) {
    x *= xScale
    y *= yScale
  }
}

