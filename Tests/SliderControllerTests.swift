@testable import SliderController
import XCTest
import EarlGrey
import EarlGreySnapshots

class SliderControllerTests: XCTestCase {

    var sut: SliderController!
    var delegateSpy: SliderControllerDelegateSpy!
    var application: UIApplication!

    override func setUp() {
        super.setUp()

        GREYTestHelper.enableFastAnimation()

        delegateSpy = SliderControllerDelegateSpy()

        sut = SliderController()
        sut.anchors = [0, 0.25, 0.5, 0.75, 1.0]
        sut.unselectedTrackColor = .blue
        sut.selectedTrackColor = .red
        sut.delegate = delegateSpy

        application = UIApplication.shared
        application.keyWindow?.backgroundColor = .white
        application.keyWindow?.rootViewController = sut
    }

    override func tearDown() {
        super.tearDown()

        sut = nil
        delegateSpy = nil
        application = nil
    }

    // MARK: - Delegate functions tests

    func testMoveSliderToValue0_7ShouldInvokeDelegateMethodSliderValueDidChange() {
        let targetValue: Float = 0.7

        EarlGrey.select(elementWithMatcher: grey_kindOfClass(UISlider.self))
            .perform(grey_moveSliderToValue(targetValue))
            .assert(delegateSliderValueDidChangeCall(withValue: targetValue))
    }

    func testMoveSliderToValue0_8ShouldInvokeDelegateMethodDidStartSwipingAndDidEndSwiping() {
        let targetValue: Float = 0.8

        EarlGrey.select(elementWithMatcher: grey_kindOfClass(UISlider.self))
            .perform(grey_moveSliderToValue(targetValue))
            .assert(delegateSliderDidStartSwipingCall())
            .assert(delegateSliderDidEndSwipingCall())
    }

    func testSwipeOnRightShouldInvokeDelegateMethodDidStartSwipingAndDidEndSwiping() {
        EarlGrey.select(elementWithMatcher: grey_kindOfClass(UISlider.self))
            .perform(grey_swipeFastInDirection(GREYDirection.right))
            .assert(delegateSliderDidStartSwipingCall())
            .assert(delegateSliderDidEndSwipingCall())
    }

    func testTapOnSliderAtMiddlePointShouldInvokeDelegateMethodSliderDidTap() {
        let fullWidth = sut.view.frame.width
        let targetPoint = CGPoint(x: fullWidth / 2, y: 0)

        EarlGrey.select(elementWithMatcher: grey_kindOfClass(UISlider.self))
            .perform(grey_tapAtPoint(targetPoint))
            .assert(delegateSliderDidTapCall(atValue: 0.5))
    }

    // MARK: - UI tests

    func testMoveSliderToValue0_8() {
        let targetValue: Float = 0.8

        EarlGrey.select(elementWithMatcher: grey_kindOfClass(UISlider.self))
            .perform(grey_moveSliderToValue(targetValue))
            .assert(grey_sliderValueMatcher(grey_equalTo(targetValue)))
    }

    func testTapOnSliderAtMiddlePoint() {
        let fullWidth = sut.view.frame.width
        let targetPoint = CGPoint(x: fullWidth / 2, y: 0)

        EarlGrey.select(elementWithMatcher: grey_kindOfClass(UISlider.self))
            .perform(grey_tapAtPoint(targetPoint))
            .assert(grey_sliderValueMatcher(grey_equalTo(0.5)))
    }

    // MARK: - UI + snapshots tests

    func testMoveSliderToValue0_7_5ShouldLooksProperly() {
        let targetValue: Float = 0.75

        EarlGrey.select(elementWithMatcher: grey_kindOfClass(UISlider.self))
            .perform(grey_moveSliderToValue(targetValue))
            .assert(grey_verifyDeviceAgnosticSnapshot())
    }

}
