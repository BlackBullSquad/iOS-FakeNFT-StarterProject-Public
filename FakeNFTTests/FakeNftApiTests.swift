@testable import FakeNFT
import XCTest

final class FakeNftApiTests: XCTestCase {
    func testUpdateProfile() {
        let api: NftAPI = FakeNftAPI()
        let expectation = XCTestExpectation(description: "wait for result")

        let newName = UUID().uuidString
        let newDescription = UUID().uuidString
        let newWebsite = URL(string: "https://ya.ru/\(UUID().uuidString)")!
        let newLikes = [Int].init(repeating: .random(in: 0...10), count: .random(in: 1...10))

        api.updateProfile(name: newName,
                          description: newDescription,
                          website: newWebsite,
                          likes: newLikes) {
            defer { expectation.fulfill() }

            guard case let .success(profile) = $0 else {
                XCTFail("Failed request")
                return
            }

            XCTAssertEqual(newName, profile.name)
            XCTAssertEqual(newDescription, profile.description)
            XCTAssertEqual(newWebsite, profile.website)
            XCTAssertEqual(newLikes, profile.likes)
        }

        wait(for: [expectation], timeout: 1)
    }
}
