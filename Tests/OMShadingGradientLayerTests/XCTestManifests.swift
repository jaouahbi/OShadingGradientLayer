import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OMShadingGradientLayerTests.allTests),
    ]
}
#endif
