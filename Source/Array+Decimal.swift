extension Array where Element == CGFloat {

    var decimal: [Decimal] {
        return map { $0.decimal }
    }

}
