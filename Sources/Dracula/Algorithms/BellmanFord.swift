//
//  BellmanFord.swift
//  Dracula
//
//  Created by Helge Heß on 05.10.21.
//

import Foundation

extension Graph {
  
  /**
   * Bellman-Ford
   *
   * Path-finding algorithm, finds the shortest paths from one node to all nodes.
   *
   * ### Complexity
   *
   *       O( |E| · |V| ), where E = edges and V = vertices (nodes)
   *
   * ### Constraints
   *
   * Can run on graphs with negative edge weights as long as they do not have
   * any negative weight cycles.
   *
   *
   * - Parameters:
   *   - source  : The node to calculate distances for
   *   - weights : Optional weights attached to the edges.
   * - Returns   : A dictionary containing the distance to all other nodes
   *               (considering the edge direction!)
   */
  func bellmanFord(for source: Node,
                   weights: [ Edge.ID : Double ] = [:])
       -> [ Node.ID : Double ]
  {
    // TBD(hh): Should this return `[ID:Int]`? But it uses weights during
    //          processing.
    
    /* STEP 1: initialisation */
    var distances = [ Node.ID : Double ]()
    func distance(for nodeID: Node.ID) -> Double {
      return distances[nodeID] ?? .infinity
    }
    func weight(for edge: Edge) -> Double {
      return weights[edge.id] ?? 1.0 // TBD
    }
    
    /* predecessors are implicitly zero */
    distances[source.id] = 0.0

    // Initially, all distances are infinite and all predecessors are null.
    
    /* STEP 2: relax each edge (this is at the heart of Bellman-Ford) */
    /* repeat this for the number of nodes minus one */
    var i = 1, l = nodes.count
    while i < l {
      defer { i += 1}

      /* for each edge */
      for edge in edges {
        let sourceDistance = distance(for: edge.sourceID)
        if (sourceDistance + weight(for: edge)) < distance(for: edge.targetID) {
          // 'Relax edge between', edge.source.id, 'and', edge.target.id, '.'
          distances[edge.targetID] = sourceDistance + weight(for: edge)
          #if false // predecessors are not used?
            edge.target.predecessor = edge.source
          #endif
        }
        // Added by Jake Stothard (Needs to be tested)
        // if(!edge.style.directed) {
          // if(edge.target.distance + edge.weight < edge.source.distance) {
            // g.snapShot("Relax edge between " + edge.target.id + " and " + edge.source.id + ".");
            // edge.source.distance = edge.target.distance + edge.weight;
            // edge.source.predecessor = edge.target;
          // }
        // }
      }
    }
    // Ready.

    /* STEP 3: TODO Check for negative cycles */
    /* For now we assume here that the graph does not contain any negative
       weights cycles. (this is left as an excercise to the reader[tm]) */
    
    return distances
  }
}
