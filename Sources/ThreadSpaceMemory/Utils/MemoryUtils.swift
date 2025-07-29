import Foundation

enum MemoryPeriod: String {
    case today, thisWeek, thisMonth, thisSeason
}

extension Date {
    func toMemoryPeriod() -> MemoryPeriod {
        let day = Calendar.current.component(.day, from: self)
        return day < 8 ? .thisMonth : .thisSeason
    }
}