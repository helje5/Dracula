//
//  Spring.swift
//  Dracula
//
//  Created by Helge Heß on 05.10.21.
//

// TBD: Replace those w/ something something Swift?
import func Foundation.sqrt
import func Foundation.log

public extension Collection where Element: GraphNode {
  
  /**
   * TODO take ratio into account
   * TODO use integers for speed
   */
  func springLayout(iterations                : Int    = 500,
                    maxRepulsiveForceDistance : Double = 6,
                    k                         : Double = 2,
                    c                         : Double = 0.01,
                    maxVertexMovement         : Double = 0.5,
                    edgeAttractions: [ Element.Edge.ID : Double ] = [:])
       -> Layout<Element.Edge.NodeID>
  {
    // TBD: Is the edge attractions thing an issue? (not really used)
    //      I think the idea is that the attraction might be set from the
    //      outside?
    // TBD: Do we want to use a static set of "random" numbers for consistent
    //      results, or does that fight the algorithm?
    typealias Node = Element
    typealias Edge = Node.Edge
    typealias ID   = Node.Edge.NodeID
    
    var layout = Layout<ID>()
    let edges  = collectEdges() // cache

    var forces = [ ID : ( x: Double, y: Double) ]()

    func layoutIteration() {
      // Forces on nodes due to node-node repulsions
      var prev = [ Node ]()
      
      self.forEach { node1 in
        prev.forEach { node2 in
          layoutRepulsive(node1, node2)
        }
        prev.append(node1)
      }

      // Forces on nodes due to edge attractions
      edges.forEach { edge in
        layoutAttractive(edge)
      }

      // Move by the given force
      self.forEach { node in
        let ( layoutForceX, layoutForceY ) = forces[node.id] ?? ( 0, 0 )
        var xmove = c * layoutForceX
        var ymove = c * layoutForceY

        let max = maxVertexMovement

        if xmove >  max { xmove =  max }
        if xmove < -max { xmove = -max }
        if ymove >  max { ymove =  max }
        if ymove < -max { ymove = -max }
        
        layout.move(node.id, by: xmove, ymove)
        forces.removeValue(forKey: node.id)
      }
    }
    
    func layoutRepulsive(_ node1: Node, _ node2: Node) {
      let node2Pos = layout[position: node2.id]
      let node1Pos = layout[position: node1.id]
      
      var dx = node2Pos.x - node1Pos.x
      var dy = node2Pos.y - node1Pos.y
      var d2 = dx * dx + dy * dy
      if (d2 < 0.01) {
        dx = 0.1 * Double.random(in: 0.0..<1.0) + 0.1
        dy = 0.1 * Double.random(in: 0.0..<1.0) + 0.1
        d2 = dx * dx + dy * dy
      }
      let d = sqrt(d2)
      guard d < maxRepulsiveForceDistance else { return }
      
      let repulsiveForce = k * k / d
      
      let node2Force = forces[node2.id] ?? ( 0, 0 )
      let node1Force = forces[node1.id] ?? ( 0, 0 )
      forces[node2.id] = (
        x: node2Force.x + (repulsiveForce * dx / d),
        y: node2Force.y + (repulsiveForce * dy / d)
      )
      forces[node1.id] = (
        x: node1Force.x - (repulsiveForce * dx / d),
        y: node1Force.y - (repulsiveForce * dy / d)
      )
    }

    func layoutAttractive(_ edge: Edge) {
      let node2Pos = layout[position: edge.targetID]
      let node1Pos = layout[position: edge.sourceID]

      var dx = node2Pos.x - node1Pos.x
      var dy = node2Pos.y - node1Pos.y
      var d2 = dx * dx + dy * dy
      if d2 < 0.01 {
        dx = 0.1 * Double.random(in: 0.0..<1.0) + 0.1
        dy = 0.1 * Double.random(in: 0.0..<1.0) + 0.1
        d2 = dx * dx + dy * dy
      }
      var d = sqrt(d2)
      if d > maxRepulsiveForceDistance {
        d  = maxRepulsiveForceDistance
        d2 = d * d
      }
      var attractiveForce = (d2 - k * k) / k
      let edgeAttraction  = edgeAttractions[edge.id] ?? 1.0
      attractiveForce *= log(edgeAttraction) * 0.5 + 1

      let node2Force = forces[edge.targetID] ?? ( 0, 0 )
      let node1Force = forces[edge.sourceID] ?? ( 0, 0 )
      forces[edge.targetID] = (
        x: node2Force.x - (attractiveForce * dx / d),
        y: node2Force.y - (attractiveForce * dy / d)
      )
      forces[edge.sourceID] = (
        x: node1Force.x + (attractiveForce * dx / d),
        y: node1Force.y + (attractiveForce * dy / d)
      )
    }

    // MARK: - Layout

    for _ in 0..<iterations {
      layoutIteration()
    }
    
    layout.bounds = layout.calculateBounds()
    return layout
  }
}
