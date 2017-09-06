final internal class Slider: UISlider {

    // MARK: Interface

    var trackHeight: CGFloat = 10
    var selectedTrackColor: UIColor = .blue
    var unselectedTrackColor: UIColor = .white
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

        let selectedTrackImage = drawImage(color: selectedTrackColor)
        let unselectedTrackImage = drawImage(color: unselectedTrackColor)

        setMinimumTrackImage(selectedTrackImage, for: .normal)
        setMaximumTrackImage(unselectedTrackImage, for: .normal)

        isThumbHidden ? setThumbImage(UIImage(), for: .normal): setThumbImage(nil, for: .normal)
    }

    // MARK: Private

    private func drawImage(color: UIColor) -> UIImage? {
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

        drawLine(inContext: context, between: (startX + offset, endX - offset), color: color)
        drawCircles(inContext: context, between: (startX, endX), color: color)
        draw(texts: labels, between: (startX, endX), color: color)
 
        return UIGraphicsGetImageFromCurrentImageContext()?
            .resizableImage(withCapInsets: .zero)
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

    private func draw(texts: [String],
                      between: (startX: CGFloat, endX: CGFloat),
                      color: UIColor) {
        guard texts.count == anchors.count else {
            return
        }
        let horizontalOffset = horizontalLabelOffset ?? defaultHorizontalLabelOffset
        let verticalOffset = verticalLabelOffset ?? defaultVerticalLabelOffset

        texts.enumerated()
            .map { (idx, text) -> (String, CGPoint) in
                let pointX = anchors[idx] * frame.width
                let textWidth = (text as NSString).size(withAttributes: textAttributes).width
                let minX = between.startX + horizontalOffset
                let maxX = min(pointX - textWidth / 2, between.endX - textWidth - horizontalOffset)
                let x = max(minX, maxX)
                let y = frame.height / 2 + anchorRadius + verticalOffset
                let labelOrigin = CGPoint(x: x, y: y)
                return (text, labelOrigin)
            }
            .forEach { (string, point) -> Void in
                string.draw(at: point, withAttributes: textAttributes)
            }
    }

    private var textAttributes: [NSAttributedStringKey: Any] {
        return [
            NSAttributedStringKey.font: labelFont ?? defaultLabelFont,
            NSAttributedStringKey.foregroundColor: labelColor ?? defaultLabelColor
        ]
    }

    private func circleCenter(anchor: CGFloat, between: (startX: CGFloat, endX: CGFloat)) -> CGPoint {
        let pointX = anchor * frame.width
        let x = max(between.startX + anchorRadius, min(pointX, between.endX - anchorRadius))
        let y = frame.height / 2
        return CGPoint(x: x, y: y)
    }

    // MARK: - Default values

    private let defaultLabelFont: UIFont = UIFont.systemFont(ofSize: 12)
    private let defaultLabelColor: UIColor = .red
    private let defaultHorizontalLabelOffset: CGFloat = 2
    private let defaultVerticalLabelOffset: CGFloat = 10

}
