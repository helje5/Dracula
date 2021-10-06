//
//  GraphBuilder.swift
//  Dracula
//
//  Created by Helge Heß on 06.10.21.
//

// We have those to support the easy-to-edit setup similar to Dracula.

public protocol EdgeEditableGraphNode: GraphNode {

  associatedtype Data
  associatedtype EdgeData

  init(id: ID, payload: Data)

  mutating func addEdge(_ edge: Edge)

  var payload : Data { get } // TBD: not really necessary for the algorithms?!

}
public extension EdgeEditableGraphNode where Data == Void {
  var payload: Data { return () }
}

public extension Graph where Node: EdgeEditableGraphNode {
  
  @discardableResult
  mutating func addNode(_ id: ID, _ payload: Node.Data) -> Node {
    // Don't create a new node if it already exists
    if let node = nodes[id] { return node }
    
    return addNode(Node(id: id, payload: payload))
  }
}

public extension Graph where Node: EdgeEditableGraphNode,
                             Node.Data: Identifiable, Node.Data.ID == ID
{
  
  mutating func addNode(_ data: Node.Data) -> Node {
    return addNode(data.id, data)
  }
}
public extension Graph where Node: EdgeEditableGraphNode, Node.Data == Void {
  
  mutating func addNode(_ id: ID) -> Node {
    return addNode(id, ())
  }
}

#if canImport(Foundation)
  import struct Foundation.UUID

  public extension Graph where Node: EdgeEditableGraphNode, Node.ID == UUID {
    mutating func addNode(_ payload: Node.Data) -> Node {
      return addNode(UUID(), payload)
    }
  }
#endif // canImport(Foundation)


// MARK: - Edges

public extension Graph where Node: EdgeEditableGraphNode,
                             Node.Edge == SimpleGraphEdge<Node.ID, Node.EdgeData>
{
  
  /**
   * This adds the Edge to BOTH sides of a node.
   */
  mutating func addEdge(_ source: Node, _ target: Node,
                        _ payload: Node.EdgeData)
  {
    addNode(source) // make sure they are added
    addNode(target)
    let edge =
      Node.Edge(sourceID: source.id, targetID: target.id, payload: payload)
    edges.append(edge)
    nodes[source.id]?.addEdge(edge)
    nodes[target.id]?.addEdge(edge)
  }
}

public extension Graph where Node: EdgeEditableGraphNode,
                             Node.Edge == SimpleGraphEdge<Node.ID, Node.EdgeData>,
                             Node.EdgeData == Void
{
  
  /**
   * This adds the Edge to BOTH sides of a node.
   */
  mutating func addEdge(_ source: Node, _ target: Node) {
    addEdge(source, target, ())
  }
}

public extension Graph where Node: EdgeEditableGraphNode,
                             Node.Edge == SimpleGraphEdge<Node.ID, Node.EdgeData>,
                             Node.Data == Void, Node.EdgeData == Void 
{

  /**
   * This adds the Edge to BOTH sides of a node.
   */
  mutating func addEdge(_ source: ID, _ target: ID) {
    let source = addNode(source)
    let target = addNode(target)
    addEdge(source, target, ())
  }
}
