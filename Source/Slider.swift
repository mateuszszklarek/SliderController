final internal class Slider: UISlider {

    // MARK: Interface

    var trackHeight: CGFloat = 10
    var selectedTrackColor: UIColor = .blue
    var unselectedTrackColor: UIColor = .white
    var selectedAnchorColor: UIColor = .blue
    var unselectedAnchorColor: UIColor = .white
    var isThumbHidden: Bool = false
    var anchors: [CGFloat] = []
    var anchorRadius: CGFloat = 12

    var labels: [String] = []
    var labelFont: UIFont?
    var labelColor: UIColor?
    var horizontalLabelOffset: CGFloat?
    var verticalLabelOffset: CGFloat?

    // MARK: Overridden

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let selectedTrackImage = drawImage(trackColor: selectedTrackColor, anchorColor: selectedAnchorColor)
        let unselectedTrackImage = drawImage(trackColor: unselectedTrackColor, anchorColor: unselectedAnchorColor)

        setMinimumTrackImage(selectedTrackImage, for: .normal)
        setMaximumTrackImage(unselectedTrackImage, for: .normal)

        isThumbHidden ? setThumbImage(UIImage(), for: .normal): setThumbImage(nil, for: .normal)
    }

    // MARK: Private

    private func drawImage(trackColor: UIColor, anchorColor: UIColor) -> UIImage? {
        let startX = frame.minX + abs(frame.minX)
        let endX = frame.maxX - abs(frame.minX)
        let size = CGSize(width: endX - startX, height: frame.height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        let offset = trackHeight / 2

        drawLine(inContext: context, between: (startX + offset, endX - offset), color: trackColor)
        drawCircles(inContext: context, between: (startX, endX), color: anchorColor)
        drawLabels(labels, between: (startX, endX))

        return UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: .zero)
    }

    private func drawLine(inContext context: CGContext,
                          between: (startX: CGFloat, endX: CGFloat),
                          color: UIColor) {
        let startLinePoint = CGPoint(x: between.startX, y: frame.height / 2)
        let endLinePoint = CGPoint(x: between.endX, y: frame.height / 2)

        context.addLines(between: [startLinePoint, endLinePoint])
        context.setLineWidth(trackHeight)
        context.setLineCap(.round)
        context.setStrokeColor(color.cgColor)
        context.strokePath()
    }

    private func drawCircles(inContext context: CGContext,
                             between: (startX: CGFloat, endX: CGFloat),
                             color: UIColor) {
        anchors
            .map { circleCenter(anchor: $0, between: between) }
            .forEach { circleCenter in
                context.addCircle(center: circleCenter, radius: anchorRadius)
                context.setFillColor(color.cgColor)
                context.fillPath()
            }
    }

    private func drawLabels(_ labels: [String], between: (startX: CGFloat, endX: CGFloat)) {
        guard labels.count == anchors.count else {
            return
        }

        labels.enumerated()
            .map { (index, text) -> (String, CGPoint) in
                let textPosition = labelPosition(forText: text, anchor: anchors[index], between: between)
                return (text, textPosition)
            }
            .forEach { (string, point) -> Void in
                string.draw(at: point, withAttributes: textAttributes)
            }
    }

    private func circleCenter(anchor: CGFloat, between: (startX: CGFloat, endX: CGFloat)) -> CGPoint {
        let pointX = anchor * frame.width
        let x = max(between.startX + anchorRadius, min(pointX, between.endX - anchorRadius))
        let y = frame.height / 2

        return CGPoint(x: x, y: y)
    }

    private func labelPosition(forText text: String,
                               anchor: CGFloat,
                               between: (startX: CGFloat, endX: CGFloat)) -> CGPoint {
        let textWidth = (text as NSString).size(withAttributes: textAttributes).width
        let pointX = frame.width * anchor
        let minX = between.startX + horizontalOffset
        let maxX = min(pointX - textWidth / 2, between.endX - textWidth - horizontalOffset)

        return CGPoint(x: max(minX, maxX), y: frame.height / 2 + anchorRadius + verticalOffset)
    }

    private var horizontalOffset: CGFloat {
        return horizontalLabelOffset ?? defaultHorizontalLabelOffset
    }

    private var verticalOffset: CGFloat {
        return verticalLabelOffset ?? defaultVerticalLabelOffset
    }

    private var textAttributes: [NSAttributedStringKey: Any] {
        return [
            NSAttributedStringKey.font: labelFont ?? defaultLabelFont,
            NSAttributedStringKey.foregroundColor: labelColor ?? defaultLabelColor
        ]
    }

    // MARK: - Default values

    private let defaultLabelFont: UIFont = UIFont.systemFont(ofSize: 12)
    private let defaultLabelColor: UIColor = .red
    private let defaultHorizontalLabelOffset: CGFloat = 2
    private let defaultVerticalLabelOffset: CGFloat = 10

}
