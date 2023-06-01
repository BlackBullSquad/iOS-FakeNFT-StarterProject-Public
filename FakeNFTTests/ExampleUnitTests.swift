@testable import FakeNFT
import XCTest

final class ExampleUnitTests: XCTestCase {
    func testExample() {
        let api: NftAPI = FakeNftAPI()
        let expectation = XCTestExpectation(description: "wait for result")
        api.getNfts {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
