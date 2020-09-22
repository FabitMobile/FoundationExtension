import Foundation

public func hoursMinutesFromSeconds(_ seconds: Int) -> (hours: Int, minutes: Int) {
    let hours = Int(Double(seconds) / 60 / 60)
    let minutes = Int(Double(seconds) / 60) - hours * 60
    return (hours, minutes)
}
