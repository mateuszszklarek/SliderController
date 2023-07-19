import SliderController
import UIKit

class CustomStepSliderController: UIViewController, SliderControllerDelegate {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        embed(child: sliderController, in: view)
    }

    // MARK: - SliderControllerDelegate

    func sliderDidTap(atValue value: Float) {
        print("CustomStepSlider - did tap at value: \(value)") // TODO: Implement UI
    }

    func sliderValueDidChange(value: Float) {
        print("CustomStepSlider - value did change: \(value)") // TODO: Implement UI
    }

    func sliderDidStartSwiping() {
        print("CustomStepSlider - did start swiping") // TODO: Implement UI
    }

    func sliderDidEndSwiping() {
        print("CustomStepSlider - did end swiping") // TODO: Implement UI
    }

    func sliderLabelForValue(label: String?) {
        print("CustomStepSlider - label for value: \(label ?? "none")")
    }

    // MARK: - Private

    private lazy var sliderController: SliderController = {
        let slider = SliderController()
        slider.unselectedTrackColor = UIColor(red: 0.13, green: 0.20, blue: 0.30, alpha: 1.0)
        slider.selectedTrackColor = UIColor(red: 0.33, green: 0.11, blue: 0.73, alpha: 1.0)
        slider.unselectedAnchorColor = UIColor(red: 0.13, green: 0.20, blue: 0.30, alpha: 1.0)
        slider.selectedAnchorColor = UIColor(red: 0.33, green: 0.11, blue: 0.73, alpha: 1.0)
        slider.thumbStyle = .custom(#imageLiteral(resourceName: "slider_thumb"))
        slider.anchors = [0, 0.2, 0.4, 0.6, 0.8, 1.0]
        slider.anchorRadius = 4
        slider.trackHeight = 4
        slider.labels = ["0.0", "0.2", "0.4", "0.6", "0.8", "1.0"]
        slider.verticalLabelOffset = 15
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.selectedLabelColor = .darkGray
        slider.selectedLabelFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        slider.unselectedLabelColor = .lightGray
        slider.unselectedLabelFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        slider.currentValueLabelColor = .gray
        slider.currentValueLabelFont = UIFont.systemFont(ofSize: 14, weight: .bold)
        slider.isStepSlider = true
        slider.delegate = self
        return slider
    }()

    required init?(coder: NSCoder) { nil }

}
