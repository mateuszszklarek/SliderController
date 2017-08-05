import EarlGrey

extension SliderControllerTests {

    func delegateSliderValueDidChangeCall(withValue value: Float) -> GREYAssertionBlock {
        let name = "Assert change slider value to: \(value)"
        return GREYAssertionBlock
            .assertion(withName: name) { [weak self] (_, errorOrNil: UnsafeMutablePointer<NSError?>?) -> Bool in
                guard let `self` = self else { return false }
                if self.delegateSpy.sliderValueDidChange.call == false {
                    let errorInfo = [NSLocalizedDescriptionKey: "sliderValueDidChange(value:) function not called"]
                    errorOrNil?.pointee = NSError(domain: kGREYInteractionErrorDomain, code: 2, userInfo: errorInfo)
                } else if self.delegateSpy.sliderValueDidChange.value != value {
                    let description = "sliderValueDidChange(value:) was called " +
                    "with incorrect value: \(self.delegateSpy.sliderValueDidChange.value)"
                    let errorInfo = [NSLocalizedDescriptionKey: description]
                    errorOrNil?.pointee = NSError(domain: kGREYInteractionErrorDomain, code: 2, userInfo: errorInfo)
                }
                return self.delegateSpy.sliderValueDidChange.call == true &&
                    self.delegateSpy.sliderValueDidChange.value == value
        }
    }

}
