extension Decimal {

    func normalizeToRange(newMax: Decimal, newMin: Decimal, oldMax: Decimal, oldMin: Decimal) -> Decimal {
        return (((self - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) + newMin
    }

}
