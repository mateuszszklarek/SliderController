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

    func delegateSliderDidStartSwipingCall() -> GREYAssertionBlock {
        let name = "Assert start swiping"
        return GREYAssertionBlock
            .assertion(withName: name) { [weak self] (_, errorOrNil: UnsafeMutablePointer<NSError?>?) -> Bool in
                guard let `self` = self else { return false }
                if self.delegateSpy.sliderDidStartSwipingCall == false {
                    let errorInfo = [NSLocalizedDescriptionKey: "sliderDidStartSwiping() function not called"]
                    errorOrNil?.pointee = NSError(domain: kGREYInteractionErrorDomain, code: 2, userInfo: errorInfo)
                }
                return self.delegateSpy.sliderDidStartSwipingCall == true
        }
    }

    func delegateSliderDidEndSwipingCall() -> GREYAssertionBlock {
        let name = "Assert end swiping"
        return GREYAssertionBlock
            .assertion(withName: name) { [weak self] (_, errorOrNil: UnsafeMutablePointer<NSError?>?) -> Bool in
                guard let `self` = self else { return false }
                if self.delegateSpy.sliderDidStartSwipingCall == false {
                    let errorInfo = [NSLocalizedDescriptionKey: "sliderDidEndSwiping() function not called"]
                    errorOrNil?.pointee = NSError(domain: kGREYInteractionErrorDomain, code: 2, userInfo: errorInfo)
                }
                return self.delegateSpy.sliderDidEndSwipingCall == true
        }
    }

}
