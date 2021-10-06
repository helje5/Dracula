//
//  GraphConnection.swift
//  Dracula
//
//  Created by Helge Heß on 06.10.21.
//

/**
 * A directed connection to another `GraphNode`.
 */
public protocol GraphConnection {
  
  associatedtype NodeID : Hashable
  
  var targetID : NodeID { get }
}
