extension Decimal {

    var float: Float {
        return (self as NSDecimalNumber).floatValue
    }

}
