import XCTest

final class StringCamelCasedTests: XCTestCase {

    func test_通常の文字列をキャメルケースに変換() {
        let input = "hello world"
        let expectedOutput = "helloWorld"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func test_複数のスペースを含む文字列をキャメルケースに変換() {
        let input = "hello    world"
        let expectedOutput = "helloWorld"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func test_特殊文字を含む文字列をキャメルケースに変換() {
        let input = "hello-world_test"
        let expectedOutput = "helloWorldTest"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func test_大文字を含む文字列をキャメルケースに変換() {
        let input = "HELLO WORLD"
        let expectedOutput = "helloWorld"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func test_数字を含む文字列をキャメルケースに変換() {
        let input = "hello 123 world"
        let expectedOutput = "hello123World"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func test_空文字列をキャメルケースに変換() {
        let input = ""
        let expectedOutput = ""
        XCTAssertEqual(input.camelCased, expectedOutput)
    }

    func test_単語のみの文字列をキャメルケースに変換() {
        let input = "hello"
        let expectedOutput = "hello"
        XCTAssertEqual(input.camelCased, expectedOutput)
    }
}
