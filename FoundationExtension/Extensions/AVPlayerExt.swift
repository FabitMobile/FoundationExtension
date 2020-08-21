import AVFoundation
import Foundation

public extension AVPlayer {
    var isPlaying: Bool {
        ((rate != 0) && (error == nil))
    }
}
