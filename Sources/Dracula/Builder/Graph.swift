//
//  Dracula.swift
//  Dracula
//
//  Created by Helge Heß on 05.10.21.
//

/**
 * This is more of a builder, as the Nodes themselves track the edges they
 * own.
 *
 * https://www.graphdracula.net
 *
 *     var g = new Dracula.Graph();
 *
 *     g.addEdge("strawberry", "cherry");
 *     g.addEdge("strawberry", "apple");
 *     g.addEdge("strawberry", "tomato");
 *
 *     g.addEdge("tomato", "apple");
 *     g.addEdge("tomato", "kiwi");
 *
 *     g.addEdge("cherry", "apple");
 *     g.addEdge("cherry", "kiwi");
 *
 *     var layouter = new Dracula.Layout.Spring(g);
 *     layouter.layout();
 *
 *     var renderer = new Dracula.Renderer.Raphael('canvas', g, 400, 300);
 *     renderer.draw();
 */
public struct Graph<Node: GraphNode> {
  
  public typealias ID   = Node.ID
  public typealias Edge = Node.Edge

  public internal(set) var nodes = [ ID : Node ]()
  public internal(set) var edges = [ Edge ]()
  
  public init(nodes: [ ID : Node ] = [:], edges: [ Edge ] = []) {
    self.nodes = nodes
    self.edges = edges
  }
  
  public init(nodes: [ Node ] = [], edges: [ Edge ] = []) {
    var nodeMap = [ ID : Node ]()
    nodeMap.reserveCapacity(nodes.count)
    for node in nodes {
      assert(nodeMap[node.id] == nil)
      nodeMap[node.id] = node
    }
    self.init(nodes: nodeMap, edges: edges)
  }
  public init(nodes: [ Node ] = []) {
    self.init(nodes: nodes, edges: nodes.reduce([], { edges, node in
      return edges + node.edges
    }))
  }

  
  public subscript(node id: ID) -> Node? {
    return nodes[id]
  }
}

public extension Graph {
  
  @discardableResult
  mutating func addNode(_ node: Node) -> Node {
    nodes[node.id] = node
    return node
  }
}
