internal extension CGContext {

    func addCircle(center: CGPoint, radius: CGFloat) {
        addArc(center: center,
               radius: radius,
               startAngle: 0,
               endAngle: CGFloat(2 * Double.pi),
               clockwise: true)
    }
    
}
