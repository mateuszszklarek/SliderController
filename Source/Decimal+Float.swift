extension Decimal {

    var float: Float {
        (self as NSDecimalNumber).floatValue
    }

}
