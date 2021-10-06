//
//  GraphEdge.swift
//  Dracula
//
//  Created by Helge Heß on 06.10.21.
//

/**
 * A directed connection between two `GraphNode`s.
 *
 * The edge is `Identifiable` by the source/target ID (though technically
 * there could be multiple edges with different payloads, unsure whether
 * that is allowed by the algorithms).
 */
public protocol GraphEdge: GraphConnection, Identifiable {
  
  var sourceID : NodeID { get }
  var targetID : NodeID { get }
}

fileprivate struct SourceTargetID<NodeID: Hashable>: Hashable {
  let sourceID : NodeID
  let targetID : NodeID
}

extension GraphEdge {
    
  public var id : some Hashable {
    return SourceTargetID(sourceID: sourceID, targetID: targetID)
  }
}


