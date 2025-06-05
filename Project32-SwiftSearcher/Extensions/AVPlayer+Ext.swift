//  File: AVPlayer+Ext.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/4/25.

import AVKit
import AVFoundation

extension AVPlayer
{
    var isPlaying: Bool { return rate != 0 && error == nil }

}
