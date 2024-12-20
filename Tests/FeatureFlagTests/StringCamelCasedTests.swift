import XCTest

final class StringCamelCasedTests: XCTestCase {

    func testCamelCased_withNormalString() {
        let input = "hello world"
        let expectedOutput = "helloWorld"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func testCamelCased_withMultipleSpaces() {
        let input = "hello    world"
        let expectedOutput = "helloWorld"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func testCamelCased_withSpecialCharacters() {
        let input = "hello-world_test"
        let expectedOutput = "helloWorldTest"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func testCamelCased_withUppercaseCharacters() {
        let input = "HELLO WORLD"
        let expectedOutput = "helloWorld"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func testCamelCased_withNumbers() {
        let input = "hello 123 world"
        let expectedOutput = "hello123World"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func testCamelCased_withEmptyString() {
        let input = ""
        let expectedOutput = ""
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func testCamelCased_withSingleWord() {
        let input = "hello"
        let expectedOutput = "hello"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }
}
