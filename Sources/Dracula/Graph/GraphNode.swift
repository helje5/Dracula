//
//  GraphNode.swift
//  Dracula
//
//  Created by Helge Heß on 06.10.21.
//

/**
 * A node in a graph has to properties:
 * - an identity (expressed using `Identifiable`
 * - a set of connections to other nodes, called `Edge`s.
 */
public protocol GraphNode: Identifiable {
  
  associatedtype Edge : GraphEdge where Edge.NodeID == ID
  
  var id    : ID       { get }
  var edges : [ Edge ] { get }
}

public extension Collection where Element : GraphNode {
  
  /**
   * Collects all edges of the nodes in the collection.
   */
  func collectEdges() -> [ Element.Edge ] {
    var edges = [ Element.Edge ]()
    edges.reserveCapacity(count * 2)
    for node in self {
      edges.append(contentsOf: node.edges)
    }
    return edges
  }
}
