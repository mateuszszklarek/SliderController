extension Float {

    var decimal: Decimal {
        Decimal(Double(self))
    }

}
