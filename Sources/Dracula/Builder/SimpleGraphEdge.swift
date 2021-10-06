//
//  SimpleGraphEdge.swift
//  Dracula
//
//  Created by Helge Heß on 06.10.21.
//

/**
 * A directed connection between two `GraphNode`s.
 *
 * Can carry an own payload (can be `Void` too).
 */
public struct SimpleGraphEdge<NodeID: Hashable, EdgeData>: GraphEdge {
  
  public let sourceID : NodeID
  public let targetID : NodeID
  public let payload  : EdgeData
}

extension SimpleGraphEdge where EdgeData == Void {
  
  init(sourceID: NodeID, targetID: NodeID) {
    self.init(sourceID: sourceID, targetID: targetID, payload: ())
  }
}

extension SimpleGraphEdge: Equatable where EdgeData: Equatable {

  public static func ==(lhs: SimpleGraphEdge<NodeID, EdgeData>,
                        rhs: SimpleGraphEdge<NodeID, EdgeData>) -> Bool
  {
    return lhs.sourceID == rhs.sourceID
        && lhs.targetID == rhs.targetID
        && lhs.payload  == rhs.payload
  }
}
