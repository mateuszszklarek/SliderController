class Slider: UISlider {

    // MARK: Interface

    var trackHeight: CGFloat = 10
    var selectedTrackColor: UIColor = .blue
    var unselectedTrackColor: UIColor = .white
    var selectedAnchorColor: UIColor = .blue
    var unselectedAnchorColor: UIColor = .white
    var thumbStyle: ThumbStyle = .hidden
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

    func roundToNearestAnchor(value: Float) -> Decimal? {
        let valueInAnchorRS = anchorsReferenceSystem(value: value.decimal)
        guard let nearest = anchors.decimal.nearest(value: valueInAnchorRS) else { return nil }
        return sliderReferenceSystem(value: nearest)
    }

    func labelForSliderValue(value: Decimal) -> String? {
        let valueInAnchroRS = anchorsReferenceSystem(value: value)
        guard let index = anchors.decimal.firstIndex(of: valueInAnchroRS) else { return nil }
        return labels.indices.contains(index) ? labels[index] : nil
    }

    func targetValue(tappedPoint: CGPoint) -> Float {
        let unitWidth = maximumValue.decimal / frame.size.width.decimal
        return ((tappedPoint.x.decimal - frame.origin.x.decimal) * unitWidth).float
    }

    // MARK: Overridden

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let selectedTrackImage = drawImage(trackColor: selectedTrackColor, anchorColor: selectedAnchorColor)
        let unselectedTrackImage = drawImage(trackColor: unselectedTrackColor, anchorColor: unselectedAnchorColor)

        setMinimumTrackImage(selectedTrackImage, for: .normal)
        setMaximumTrackImage(unselectedTrackImage, for: .normal)

        setThumbImage(thumbStyle.thumbImage, for: .normal)
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

        drawLine(inContext: context, between: (startX, endX), color: trackColor)
        drawCircles(inContext: context, between: (startX, endX), color: anchorColor)
        drawLabels(labels, between: (startX, endX))

        return UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: .zero)
    }

    private func drawLine(inContext context: CGContext,
                          between: (startX: CGFloat, endX: CGFloat),
                          color: UIColor) {
        let startLinePoint = CGPoint(x: between.startX + startXLineOffset, y: frame.height / 2)
        let endLinePoint = CGPoint(x: between.endX - endXLineOffset, y: frame.height / 2)

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
                let textAttributes = attributes(for: selection(for: anchor))
                string.draw(at: point, withAttributes: textAttributes)
            }
    }

    private func circleCenter(anchor: CGFloat, between: (startX: CGFloat, endX: CGFloat)) -> CGPoint {
        let pointX = between.startX + anchor * sliderWidth
        let x = max(between.startX + circleOffset, min(pointX + circleOffset, between.endX - circleOffset))
        let y = frame.height / 2

        return CGPoint(x: x, y: y)
    }

    private func labelPosition(forText text: String,
                               anchor: CGFloat,
                               between: (startX: CGFloat, endX: CGFloat)) -> CGPoint {
        let textAttributes = attributes(for: selection(for: anchor))
        let textWidth = (text as NSString).size(withAttributes: textAttributes).width

        let pointX = labelOffset + sliderWidth * anchor
        let minX = between.startX + horizontalOffset
        let maxX = min(pointX - textWidth / 2, between.endX - textWidth - horizontalOffset)

        return CGPoint(x: max(minX, maxX), y: frame.height / 2 + anchorRadius + verticalOffset)
    }

    // MARK: - Helpers

    private enum SelectionType {
        case unselcted
        case currentValue
        case selected
    }

    private func selection(for anchor: CGFloat) -> SelectionType {
        let newValue = anchor.decimal
            .normalizeToRange(newMax: maximumValue.decimal, newMin: minimumValue.decimal, oldMax: 1, oldMin: 0)
        switch (newValue.float, value) {
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

    private func sliderReferenceSystem(value: Decimal) -> Decimal {
        value.normalizeToRange(newMax: maximumValue.decimal, newMin: minimumValue.decimal, oldMax: 1, oldMin: 0)
    }

    private func anchorsReferenceSystem(value: Decimal) -> Decimal {
        value.normalizeToRange(newMax: 1, newMin: 0, oldMax: maximumValue.decimal, oldMin: minimumValue.decimal)
    }

    private var thumbOffset: CGFloat {
        thumbStyle.thumbWidth / 2
    }

    private var sliderOffset: CGFloat {
        2
    }

    private var horizontalOffset: CGFloat {
        horizontalLabelOffset ?? defaultHorizontalLabelOffset
    }

    private var verticalOffset: CGFloat {
        verticalLabelOffset ?? defaultVerticalLabelOffset
    }

    private var selectedTextAttributes: [NSAttributedString.Key: Any] {
        [
            NSAttributedString.Key.font: selectedLabelFont ?? defaultLabelFont,
            NSAttributedString.Key.foregroundColor: selectedLabelColor ?? defaultLabelColor
        ]
    }

    private var unselectedTextAttributes: [NSAttributedString.Key: Any] {
        [
            NSAttributedString.Key.font: unselectedLabelFont ?? defaultLabelFont,
            NSAttributedString.Key.foregroundColor: unselectedLabelColor ?? defaultLabelColor
        ]
    }

    private var currentValueTextAttributes: [NSAttributedString.Key: Any] {
        [
            NSAttributedString.Key.font: currentValueLabelFont ?? defaultLabelFont,
            NSAttributedString.Key.foregroundColor: currentValueLabelColor ?? defaultLabelColor
        ]
    }

    private var labelOffset: CGFloat {
        switch thumbStyle {
        case .custom, .system:
            return thumbOffset - sliderOffset
        case .hidden:
            return anchorRadius
        }
    }

    private var startXLineOffset: CGFloat {
        switch thumbStyle {
        case .custom, .system:
            return thumbOffset - sliderOffset + (trackHeight / 2)
        case .hidden:
            return trackHeight / 2
        }
    }

    private var endXLineOffset: CGFloat {
        switch thumbStyle {
        case .custom, .system:
            return thumbOffset + sliderOffset - (trackHeight / 2)
        case .hidden:
            return trackHeight / 2
        }
    }

    private var sliderWidth: CGFloat {
        switch thumbStyle {
        case .custom, .system:
            return frame.width - 2 * thumbOffset
        case .hidden:
            return frame.width
        }
    }

    private var circleOffset: CGFloat {
        switch thumbStyle {
        case .custom, .system:
            return thumbOffset - sliderOffset
        case .hidden:
            return anchorRadius
        }
    }

    // MARK: - Default values

    private let defaultLabelFont: UIFont = UIFont.systemFont(ofSize: 12)
    private let defaultLabelColor: UIColor = .red
    private let defaultHorizontalLabelOffset: CGFloat = 2
    private let defaultVerticalLabelOffset: CGFloat = 10

}

public enum ThumbStyle: Equatable {
    case system
    case hidden
    case custom(UIImage)

    var thumbImage: UIImage? {
        switch self {
        case .system:
            return nil
        case .hidden:
            return UIImage()
        case .custom(let image):
            return image
        }
    }

    var thumbWidth: CGFloat {
        switch self {
        case .system:
            return 31
        case .hidden:
            return 0
        case .custom(let image):
            return image.size.width
        }
    }
}
