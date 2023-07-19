import Foundation

extension CGFloat {

    var decimal: Decimal {
        Decimal(Double(self))
    }

}
