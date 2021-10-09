import SliderController
import UIKit

class NonThumbSliderController: UIViewController, SliderControllerDelegate {

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
        print("NonThumbSlider - did tap at value: \(value)") // TODO: Implement UI
    }

    func sliderValueDidChange(value: Float) {
        print("NonThumbSlider - value did change: \(value)") // TODO: Implement UI
    }

    func sliderDidStartSwiping() {
        print("NonThumbSlider - did start swiping") // TODO: Implement UI
    }

    func sliderDidEndSwiping() {
        print("NonThumbSlider - did end swiping") // TODO: Implement UI
    }

    func sliderLabelForValue(label: String?) {
        print("NonThumbSlider - label for value: \(label ?? "none")")
    }

    // MARK: - Private

    private lazy var sliderController: SliderController = {
        let slider = SliderController()
        slider.unselectedTrackColor = UIColor.red.withAlphaComponent(0.5)
        slider.selectedTrackColor = .green
        slider.unselectedAnchorColor = .red
        slider.selectedAnchorColor = .green
        slider.thumbStyle = .hidden
        slider.anchors = [0, 0.3, 0.6, 1.0]
        slider.anchorRadius = 14
        slider.trackHeight = 7.5
        slider.labels = ["A", "B", "C", "D"]
        slider.horizontalLabelOffset = 0
        slider.verticalLabelOffset = 0
        slider.selectedLabelColor = .black
        slider.selectedLabelFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        slider.unselectedLabelColor = .black
        slider.unselectedLabelFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        slider.delegate = self
        return slider
    }()

    required init?(coder: NSCoder) { nil }

}
