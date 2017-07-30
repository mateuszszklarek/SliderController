final internal class Slider: UISlider {

    // MARK: Interface

    var trackHeight: CGFloat = 10
    var selectedTrackColor: UIColor = .blue
    var unselectedTrackColor: UIColor = .white
    var isThumbHidden: Bool = false

    var anchors: [CGFloat] = [0, 0.25, 0.5, 0.75, 1.0]
    var anchorRadius: CGFloat = 12

    // MARK: Overridden

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let superview = superview else {
            return
        }

        frame = superview.bounds

        let selectedTrackImage = drawImage(color: selectedTrackColor)
        let unselectedTrackImage = drawImage(color: unselectedTrackColor)

        setMinimumTrackImage(selectedTrackImage, for: .normal)
        setMaximumTrackImage(unselectedTrackImage, for: .normal)

        isThumbHidden ? setThumbImage(UIImage(), for: .normal): setThumbImage(nil, for: .normal)
    }

    // MARK: Private

    private let minOffset: CGFloat = 10

    private func drawImage(color: UIColor) -> UIImage? {
        let offset: CGFloat = max(minOffset, max(trackHeight / 2, anchorRadius))
        let startX: CGFloat = frame.origin.x + offset
        let endX: CGFloat = frame.size.width - offset * 1.3

        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        drawLine(inContext: context, between: (startX, endX), color: color)
        drawCircles(inContext: context, between: (startX, endX), color: color)

        defer {
            UIGraphicsEndImageContext()
        }

        return UIGraphicsGetImageFromCurrentImageContext()?
            .resizableImage(withCapInsets: .zero)
    }

    private func drawLine(inContext context: CGContext?,
                          between: (startX: CGFloat, endX: CGFloat),
                          color: UIColor) {
        let startLinePoint = CGPoint(x: between.startX, y: frame.height / 2)
        let endLinePoint = CGPoint(x: between.endX, y: frame.height / 2)

        context?.addLines(between: [startLinePoint, endLinePoint])
        context?.setLineWidth(trackHeight)
        context?.setLineCap(.round)
        context?.setStrokeColor(color.cgColor)
        context?.strokePath()
    }

    private func drawCircles(inContext context: CGContext?,
                             between: (startX: CGFloat, endX: CGFloat),
                             color: UIColor) {
        anchors.forEach { anchor in
            let pointX = anchor * frame.width
            let x = max(between.startX, min(pointX, between.endX))
            let y = frame.height / 2
            let circleCenter = CGPoint(x: x, y: y)

            context?.addArc(center: circleCenter,
                            radius: anchorRadius,
                            startAngle: 0,
                            endAngle: CGFloat(2 * Double.pi),
                            clockwise: true)
            context?.setFillColor(color.cgColor)
            context?.fillPath()
        }
    }

}
