final internal class Slider: UISlider {

    // MARK: Interface

    var trackHeight: CGFloat = 10
    var selectedTrackColor: UIColor = .blue
    var unselectedTrackColor: UIColor = .white
    var selectedAnchorColor: UIColor = .blue
    var unselectedAnchorColor: UIColor = .white
    var isThumbHidden: Bool = false
    var thumbImage: UIImage?
    var anchors: [CGFloat] = []
    var anchorRadius: CGFloat = 12

    var selectedLabelFont: UIFont?
    var unselectedLabelFont: UIFont?
    var selectedLabelColor: UIColor?
    var unselectedLabelColor: UIColor?
    var currentValueLabelFont: UIFont?
    var currentValueLabelColor: UIColor?

    var labels: [String] = []
    var horizontalLabelOffset: CGFloat?
    var verticalLabelOffset: CGFloat?

    // MARK: Overridden

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let selectedTrackImage = drawImage(trackColor: selectedTrackColor, anchorColor: selectedAnchorColor)
        let unselectedTrackImage = drawImage(trackColor: unselectedTrackColor, anchorColor: unselectedAnchorColor)

        setMinimumTrackImage(selectedTrackImage, for: .normal)
        setMaximumTrackImage(unselectedTrackImage, for: .normal)

        isThumbHidden ? setThumbImage(UIImage(), for: .normal): setThumbImage(thumbImage, for: .normal)
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
            .map { (index, text) -> (String, CGPoint, CGFloat) in
                let textPosition = labelPosition(forText: text, anchor: anchors[index], between: between)
                return (text, textPosition, anchors[index])
            }
            .forEach { string, point, anchor in
                let textAttributes = attributes(for: isSelected(anchor: anchor))
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
        let textAttributes = attributes(for: isSelected(anchor: anchor))
        let textWidth = (text as NSString).size(withAttributes: textAttributes).width
        let pointX = frame.width * anchor
        let minX = between.startX + horizontalOffset
        let maxX = min(pointX - textWidth / 2, between.endX - textWidth - horizontalOffset)

        return CGPoint(x: max(minX, maxX), y: frame.height / 2 + anchorRadius + verticalOffset)
    }

    private func isSelected(anchor: CGFloat) -> SelectionType {
        let anchorsRange: CGFloat = 1
        let valuesRange = CGFloat(maximumValue - minimumValue)
        let normalizedAnchorValue = (anchor * valuesRange) + CGFloat(minimumValue)
        return selectionType(for: normalizedAnchorValue, sliderValue: CGFloat(value))
    }

    enum SelectionType {
        case unselcted
        case currentValue
        case selected
    }

    private var horizontalOffset: CGFloat {
        return horizontalLabelOffset ?? defaultHorizontalLabelOffset
    }

    private var verticalOffset: CGFloat {
        return verticalLabelOffset ?? defaultVerticalLabelOffset
    }

    private func selectionType(for anchorValue: CGFloat, sliderValue: CGFloat) -> SelectionType {
        switch (anchorValue, sliderValue) {
        case let (x, y) where x == y:
            return .currentValue
        case let (x, y) where x > y:
            return .unselcted
        default:
            return .selected
        }
    }

    private func attributes(for selectionType: SelectionType) -> [NSAttributedString.Key: Any] {
        switch selectionType {
        case .currentValue:
            return currentValueTextAttributes
        case .selected:
            return selectedTextAttributes
        case .unselcted:
            return unselectedTextAttributes
        }
    }

    private var selectedTextAttributes: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: selectedLabelFont ?? defaultLabelFont,
            NSAttributedString.Key.foregroundColor: selectedLabelColor ?? defaultLabelColor
        ]
    }

    private var unselectedTextAttributes: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: unselectedLabelFont ?? defaultLabelFont,
            NSAttributedString.Key.foregroundColor: unselectedLabelColor ?? defaultLabelColor
        ]
    }

    private var currentValueTextAttributes: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: currentValueLabelFont ?? defaultLabelFont,
            NSAttributedString.Key.foregroundColor: currentValueLabelColor ?? defaultLabelColor
        ]
    }

    // MARK: - Default values

    private let defaultLabelFont: UIFont = UIFont.systemFont(ofSize: 12)
    private let defaultLabelColor: UIColor = .red
    private let defaultHorizontalLabelOffset: CGFloat = 2
    private let defaultVerticalLabelOffset: CGFloat = 10

}
