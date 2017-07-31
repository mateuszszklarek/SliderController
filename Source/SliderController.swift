public protocol SliderControllerDelegate: class {
    func sliderDidTap(atValue value: Float)
    func sliderValueDidChange(value: Float)
    func sliderDidStartSwiping()
    func sliderDidEndSwiping()
}

final public class SliderController: UIViewController {

    public weak var delegate: SliderControllerDelegate?

    public override func loadView() {
        view = UIView(frame: .zero)
        addSubviews()
        setUpLayout()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpSliderInteractions()
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
