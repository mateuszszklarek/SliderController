import UIKit

class ViewController: UIViewController {

    override func loadView() {
        view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        embedChildren()
    }

    // MARK: - Private

    private lazy var customView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let customStepSliderController = CustomStepSliderController()
    private let nonThumbSliderController = NonThumbSliderController()

    private func embedChildren() {
        [customStepSliderController, nonThumbSliderController].forEach {
            embed($0) { customView.addArrangedSubview($0) }
        }
    }

}
