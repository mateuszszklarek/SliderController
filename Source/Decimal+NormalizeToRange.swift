import Foundation

extension Decimal {

    func normalizeToRange(newMax: Decimal, newMin: Decimal, oldMax: Decimal, oldMin: Decimal) -> Decimal {
        (((self - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) + newMin
    }

}
