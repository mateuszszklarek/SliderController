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
