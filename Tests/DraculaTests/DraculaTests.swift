//
//  DraculaTests.swift
//  DraculaTests
//
//  Created by Helge Heß on 05.10.21.
//

import XCTest
@testable import Dracula

class DraculaTests: XCTestCase {
  
  enum Fixtures {
    
    static var fruits : Graph<SimpleGraphNode<String, Void, Void>> {
      var g = Graph<SimpleGraphNode<String, Void, Void>>()
      g.addEdge("strawberry", "cherry")
      g.addEdge("strawberry", "apple")
      g.addEdge("strawberry", "tomato")

      g.addEdge("tomato", "apple")
      g.addEdge("tomato", "kiwi")

      g.addEdge("cherry", "apple")
      g.addEdge("cherry", "kiwi")
      return g
    }
  }

  func testSetup() {
    let g = Fixtures.fruits
    
    XCTAssertEqual(g.nodes.count, 5)
    XCTAssertEqual(g.edges.count, 7)
    
    XCTAssertEqual(g.nodes.keys.sorted(),
                   [ "apple", "cherry", "kiwi", "strawberry", "tomato" ])
    
    XCTAssertNotNil(g[node: "strawberry"])
    XCTAssertNil(g[node: "cucumber"])
  }
  
  
  // MARK: - Layouts
  
  func testSpring() {
    let g = Fixtures.fruits
    
    let layout = g.nodes.values.springLayout()

    // The positions are random
    XCTAssertFalse(layout.positions.isEmpty)
    XCTAssertEqual(layout.positions.count, 5)
    
    // have a distance between the nodes
    if let a = g.nodes.values.first,
       let b = g.nodes.values.dropFirst().first
    {
      let aPos = layout[position: a.id]
      let bPos = layout[position: b.id]
      let diffX = abs(aPos.x - bPos.x)
      let diffY = abs(aPos.y - bPos.y)
      assert(diffX > 0)
      assert(diffY > 0)
    }
    
    // has layout props
    XCTAssertNotNil(layout.bounds)
  }

  
  // MARK: - Renderers

  #if false
  func testRenderer() {
    let g = Fixtures.fruits
    
    let layouter = Spring(g)
    layouter.layout()

    let renderer = TheRenderer(layouter)
    renderer.draw()
  }
  #endif
  
  
  // MARK: - Algorithms
  
  func testSingleStepBellmanFord() {
    let g = Fixtures.fruits
    guard let cherry = g[node: "cherry"] else {
      XCTAssert(false, "found no cherry?")
      return
    }
    
    let distances = g.bellmanFord(for: cherry)
    
    // Note: While the "strawberry" is also connected to the "cherry", the edge
    //       has the wrong direction.
    XCTAssertEqual(distances["cherry"], 0.0)
    XCTAssertEqual(distances["apple"],  1.0)
    XCTAssertEqual(distances["kiwi"],   1.0)

    XCTAssertNil(distances["strawberry"])
    XCTAssertNil(distances["tomato"])
  }
  
  func testDualStepBellmanFord() {
    let g = Fixtures.fruits
    guard let node = g[node: "strawberry"] else {
      XCTAssert(false, "found no strawberry?")
      return
    }
    
    let distances = g.bellmanFord(for: node)
    print("DISTANCES:", distances)
    
    // Note: While the "strawberry" is also connected to the "cherry", the edge
    //       has the wrong direction.
    XCTAssertEqual(distances["strawberry"], 0)
    
    // also connected via strawberry > cherry > apple
    XCTAssertEqual(distances["apple"],  1)

    XCTAssertEqual(distances["cherry"], 1)
    XCTAssertEqual(distances["tomato"], 1)
    
    // strawberry > cherry > kiwi
    // strawberry > tomato > kiwi
    XCTAssertEqual(distances["kiwi"], 2)
  }
}
