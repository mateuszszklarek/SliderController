import UIKit
import SliderController

class ViewController: UIViewController, SliderControllerDelegate {

    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = .white
        embed(child: sliderController, in: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sliderController.unselectedTrackColor = .red
        sliderController.selectedTrackColor = .green
        sliderController.isThumbHidden = true
        sliderController.anchors = [0, 0.3, 0.6, 1.0]
        sliderController.anchorRadius = 15
        sliderController.trackHeight = 7.5
        sliderController.delegate = self
    }

    let sliderController = SliderController()

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

}

extension UIViewController {

    func embed(child: UIViewController, in targetView: UIView) {
        addChildViewController(child)
        targetView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.topAnchor.constraint(equalTo: targetView.topAnchor).isActive = true
        child.view.leftAnchor.constraint(equalTo: targetView.leftAnchor).isActive = true
        child.view.rightAnchor.constraint(equalTo: targetView.rightAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: targetView.bottomAnchor).isActive = true
        child.didMove(toParentViewController: self)
    }

}
