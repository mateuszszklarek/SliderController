public protocol SliderControllerDelegate: class {
    func sliderDidTap(atValue value: Float)
    func sliderValueDidChange(value: Float)
    func sliderDidStartSwiping()
    func sliderDidEndSwiping()
}

public protocol SliderControlling: class {
    weak var delegate: SliderControllerDelegate? { get set }
    func setSlider(value: Float, animated: Bool)
    var sliderValue: Float { get }
    var minimumValue: Float { get set }
    var maximumValue: Float { get set }
    var controller: UIViewController { get }

    var trackHeight: CGFloat { get set }
    var selectedTrackColor: UIColor { get set }
    var unselectedTrackColor: UIColor { get set }

    var anchors: [CGFloat] { get set }
    var anchorRadius: CGFloat { get set }
    var selectedAnchorColor: UIColor { get set }
    var unselectedAnchorColor: UIColor { get set }

    var labels: [String] { get set }
    var labelFont: UIFont? { get set }
    var labelColor: UIColor? { get set }
    var horizontalLabelOffset: CGFloat? { get set }
    var verticalLabelOffset: CGFloat? { get set }
    var isThumbHidden: Bool { get set }
}

final public class SliderController: UIViewController, SliderControlling {

    public override func loadView() {
        view = UIView(frame: .zero)

        addSubviews()
        setUpLayout()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpSliderInteractions()
    }

    // MARK: - SliderControlling

    public weak var delegate: SliderControllerDelegate?

    public func setSlider(value: Float, animated: Bool) {
        slider.setValue(value, animated: animated)
    }

    public var sliderValue: Float {
        return slider.value
    }

    public var minimumValue: Float {
        set { slider.minimumValue = newValue }
        get { return slider.minimumValue }
    }

    public var maximumValue: Float {
        set { slider.maximumValue = newValue }
        get { return slider.maximumValue }
    }

    public var controller: UIViewController {
        return self
    }

    public var trackHeight: CGFloat {
        set {
            slider.trackHeight = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.trackHeight }
    }

    public var selectedTrackColor: UIColor {
        set {
            slider.selectedTrackColor = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.selectedTrackColor }
    }

    public var unselectedTrackColor: UIColor {
        set {
            slider.unselectedTrackColor = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.unselectedTrackColor }
    }

    public var anchors: [CGFloat] {
        set {
            slider.anchors = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.anchors }
    }

    public var anchorRadius: CGFloat {
        set {
            slider.anchorRadius = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.anchorRadius }
    }

    public var selectedAnchorColor: UIColor {
        set {
            slider.selectedAnchorColor = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.selectedAnchorColor }
    }

    public var unselectedAnchorColor: UIColor {
        set {
            slider.unselectedAnchorColor = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.unselectedAnchorColor }
    }

    public var labels: [String] {
        set {
            slider.labels = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.labels }
    }

    public var labelFont: UIFont? {
        set {
            slider.labelFont = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.labelFont }
    }

    public var labelColor: UIColor? {
        set {
            slider.labelColor = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.labelColor }
    }

    public var horizontalLabelOffset: CGFloat? {
        set {
            slider.horizontalLabelOffset = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.horizontalLabelOffset }
    }

    public var verticalLabelOffset: CGFloat? {
        set {
            slider.verticalLabelOffset = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.verticalLabelOffset }
    }

    public var isThumbHidden: Bool {
        set {
            slider.isThumbHidden = newValue
            slider.setNeedsDisplay()
        }
        get { return slider.isThumbHidden }
    }

    // MARK: - Interactions

    private func setUpSliderInteractions() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSlider(gestureRecognizer:)))
        slider.addGestureRecognizer(tapRecognizer)
        slider.addTarget(self, action: #selector(sliderValueDidChange(sender:)), for: .valueChanged)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(sliderDidSwipe(sender:)))
        panRecognizer.cancelsTouchesInView = false
        slider.addGestureRecognizer(panRecognizer)
    }

    @objc
    private func didTapSlider(gestureRecognizer: UITapGestureRecognizer) {
        let tappedPoint = gestureRecognizer.location(in: slider)

        let unitWidth = slider.maximumValue / Float(slider.frame.size.width)
        let targetValue = Float(tappedPoint.x - slider.frame.origin.x) * unitWidth

        slider.setValue(targetValue, animated: true)
        delegate?.sliderDidTap(atValue: targetValue)
    }

    @objc
    private func sliderValueDidChange(sender: UISlider) {
        delegate?.sliderValueDidChange(value: sender.value)
    }

    @objc
    private func sliderDidSwipe(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            delegate?.sliderDidStartSwiping()
        } else if sender.state == .ended {
            delegate?.sliderDidEndSwiping()
        }
    }

    // MARK: Subviews

    private(set) lazy var slider: Slider = Slider(frame: .zero)

    private func addSubviews() {
        view.addSubview(slider)
    }

    // MARK: Layout

    private func setUpLayout() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        slider.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
