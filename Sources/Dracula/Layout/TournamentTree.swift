//
//  TournamentTree.swift
//  Dracula
//
//  Created by Helge Heß on 05.10.21.
//

// TBD: Replace those w/ something something Swift?
import func Foundation.floor
import func Foundation.log
import func Foundation.pow

public extension Collection where Element: GraphNode {
  
  func layoutTournamentTree() -> Layout<Element.ID> {
    // To reverse the order of rendering, we need to find out the
    // absolute number of levels we have. simple log math applies.
    var layout = Layout<Element.ID>()

    let numNodes    = self.count
    let totalLevels = floor(log(Double(numNodes)) / log(2))

    var counter = 1.0
    self.forEach { node in
      let depth  = floor(log(counter) / log(2))
      let offset = pow(2, totalLevels - depth)
      let finalX = offset
                 + (counter - pow(2, depth)) * pow(2, (totalLevels - depth) + 1)
      layout[position: node.id] = LayoutPoint(
        x: finalX,
        y: depth
      )
      counter += 1
    }

    layout.bounds = layout.calculateBounds()
    return layout
  }
}
