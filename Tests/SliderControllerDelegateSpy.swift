@testable import SliderController

class SliderControllerDelegateSpy: SliderControllerDelegate {

    private(set) var sliderDidTap: (call: Bool, value: Float) = (false, 0.0)
    private(set) var sliderValueDidChange: (call: Bool, value: Float) = (false, 0.0)
    private(set) var sliderDidStartSwipingCall: Bool = false
    private(set) var sliderDidEndSwipingCall: Bool = false

    func sliderDidTap(atValue value: Float) {
        sliderDidTap = (true, value.round(toPlaces: 2))
    }

    func sliderValueDidChange(value: Float) {
        sliderValueDidChange = (true, value)
    }

    func sliderDidStartSwiping() {
        sliderDidStartSwipingCall = true
    }

    func sliderDidEndSwiping() {
        sliderDidEndSwipingCall = true
    }

    func sliderLabelForValue(label: String?) {

    }

}

extension Float {

    func round(toPlaces: Int) -> Float {
        let divisor = pow(10.0, Float(toPlaces))
        return (self * divisor).rounded() / divisor
    }
    
}
