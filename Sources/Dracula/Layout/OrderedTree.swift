//
//  OrderedTree.swift
//  Dracula
//
//  Created by Helge Heß on 05.10.21.
//

// TBD: Replace those w/ something something Swift?
import func Foundation.floor
import func Foundation.log
import func Foundation.pow

public extension Collection where Element: GraphNode {
  
  /**
   * OrderedTree is like Ordered but assumes there is one root
   * This way we can give non random positions to nodes on the Y-axis
   * It assumes the ordered nodes are of a perfect binary tree
   */
  func layoutOrderedTree() -> Layout<Element.ID> {
    var layout = Layout<Element.ID>()

    // To reverse the order of rendering, we need to find out the
    // absolute number of levels we have. simple log math applies.
    let numNodes    = self.count
    let totalLevels = floor(log(Double(numNodes)) / log(2))

    var counter = 1.0
    self.forEach { node in
      // Rank aka x coordinate
      let rank = floor(log(counter) / log(2))
      // File relative to top
      let file = counter - pow(rank, 2)

      layout[position: node.id] = LayoutPoint(
        x: totalLevels - rank,
        y: file
      )
      counter += 1
    }
    
    layout.bounds = layout.calculateBounds()
    return layout
  }
}
