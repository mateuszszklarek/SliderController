import UIKit
import SliderController

class ViewController: UIViewController {

    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = .white
        embed(child: sliderController, in: view)
    }

    let sliderController = SliderController()

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
