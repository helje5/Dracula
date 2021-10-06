//
//  SimpleGraphNode.swift
//  Dracula
//
//  Created by Helge Heß on 06.10.21.
//


public struct SimpleGraphNode<ID: Hashable, Data, EdgeData>
              : EdgeEditableGraphNode
{
  // TBD: The "ID" is kinda superfluous?
  //      Presumably the whole thing should be a protocol!
  
  public typealias Edge = SimpleGraphEdge<ID, EdgeData>
  
  public let id      : ID
  public let payload : Data // can be Void
  
  // This is more like an optimization, because the graph itself also carries
  // the edges? Makes it harder to decouple the node type?
  public internal(set) var edges = [ Edge ]()
  
  public init(id: ID, payload: Data) {
    self.id      = id
    self.payload = payload
  }

  public mutating func addEdge(_ edge: Edge) {
    edges.append(edge)
  }
}

public extension SimpleGraphNode where Data == Void, EdgeData == Void {
  
  init(_ id: ID) {
    self.init(id: id, payload: ())
  }
}

extension SimpleGraphNode: Equatable where Data: Equatable, EdgeData: Equatable
{
  
  public static func ==(lhs: SimpleGraphNode<ID, Data, EdgeData>,
                        rhs: SimpleGraphNode<ID, Data, EdgeData>) -> Bool
  {
    return lhs.id      == rhs.id
        && lhs.payload == rhs.payload
        && lhs.edges   == rhs.edges
  }
}
