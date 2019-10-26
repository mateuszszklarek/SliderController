import UIKit

extension UIViewController {

    func embed(child: UIViewController, in targetView: UIView) {
        addChild(child)
        targetView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.topAnchor.constraint(equalTo: targetView.topAnchor).isActive = true
        child.view.leftAnchor.constraint(equalTo: targetView.leftAnchor).isActive = true
        child.view.rightAnchor.constraint(equalTo: targetView.rightAnchor).isActive = true
        child.view.bottomAnchor.constraint(equalTo: targetView.bottomAnchor).isActive = true
        child.didMove(toParent: self)
    }

    public func embed(_ childController: UIViewController, using embeddingMethod: (UIView) -> Void) {
        addChild(childController)
        embeddingMethod(childController.view)
        childController.didMove(toParent: self)
    }

}
