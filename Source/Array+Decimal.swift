import Foundation

extension Array where Element == CGFloat {

    var decimal: [Decimal] {
        map { $0.decimal }
    }

}
