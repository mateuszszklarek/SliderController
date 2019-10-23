import UIKit
import SliderController

class ViewController: UIViewController, SliderControllerDelegate {

    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = .white
        embed(child: sliderController.controller, in: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray

        sliderController.unselectedTrackColor = UIColor(red: 0.13, green: 0.20, blue: 0.30, alpha: 1.0)
        sliderController.selectedTrackColor = UIColor(red: 0.33, green: 0.11, blue: 0.73, alpha: 1.0)
        sliderController.unselectedAnchorColor = UIColor(red: 0.13, green: 0.20, blue: 0.30, alpha: 1.0)
        sliderController.selectedAnchorColor = UIColor(red: 0.33, green: 0.11, blue: 0.73, alpha: 1.0)
        sliderController.thumbStyle = .custom(#imageLiteral(resourceName: "slider_thumb"))
        sliderController.anchors = [0, 0.2, 0.4, 0.6, 0.8, 1.0]
        sliderController.anchorRadius = 4
        sliderController.trackHeight = 4
        sliderController.labels = ["0.0", "0.2", "0.4", "0.6", "0.8", "1.0"]
        sliderController.verticalLabelOffset = 15
        sliderController.minimumValue = 0
        sliderController.maximumValue = 1

        sliderController.selectedLabelColor = .white
        sliderController.selectedLabelFont = UIFont.default(size: 14, weight: .regular)
        sliderController.unselectedLabelColor = UIColor(red: 0.69, green: 0.66, blue: 0.73, alpha: 1.0)
        sliderController.unselectedLabelFont = UIFont.default(size: 14, weight: .regular)
        sliderController.currentValueLabelColor = .white
        sliderController.currentValueLabelFont = UIFont.default(size: 14, weight: .bold)

        sliderController.isStepSlider = true
    }

    let sliderController: SliderControlling = SliderController()

    // MARK: SliderControllerDelegate

    func sliderDidTap(atValue value: Float) {
        print("Did tap at value: \(value)") // TODO: Implement UI
    }

    func sliderValueDidChange(value: Float) {
        print("Slider value did change: \(value)") // TODO: Implement UI
    }

    func sliderDidStartSwiping() {
        print("Slider did start swiping") // TODO: Implement UI
    }

    func sliderDidEndSwiping() {
        print("Slider did end swiping") // TODO: Implement UI
    }

    func sliderLabelForValue(label: String?) {
        print("Slider label for value: \(label ?? "none")")
    }

}

extension UIViewController {

    func embed(child: UIViewController, in targetView: UIView) {
        addChild(child)
        targetView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.topAnchor.constraint(equalTo: targetView.topAnchor).isActive = true
        child.view.leftAnchor.constraint(equalTo: targetView.leftAnchor, constant: 10).isActive = true
        child.view.rightAnchor.constraint(equalTo: targetView.rightAnchor, constant: -10).isActive = true
        child.view.bottomAnchor.constraint(equalTo: targetView.bottomAnchor).isActive = true
        child.didMove(toParent: self)
    }

}

extension UIFont {

    public static func `default`(size: CGFloat, weight: Weight) -> UIFont {
        return UIFont(name: name(for: weight), size: size)!
    }

}

private extension UIFont {

    static func name(for weight: UIFont.Weight) -> String {
        switch weight {
        case .regular:
            return "AvenirNext-Regular"
        case .bold:
            return "AvenirNext-Bold"
        case .semibold:
            return "AvenirNext-DemiBold"
        case .medium:
            return "AvenirNext-Medium"
        default:
            fatalError("Unable to find app default font with weight \(weight)")
        }
    }

}
