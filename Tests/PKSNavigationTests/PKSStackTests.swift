import XCTest

@testable import PKSNavigation

final class PKSStackTests: XCTestCase {

    var stack: PKSStack<Int>!

    override func setUp() {
        super.setUp()
        stack = PKSStack<Int>()
    }

    override func tearDown() {
        stack = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertTrue(stack.isEmpty)
        XCTAssertEqual(stack.count, 0)
        XCTAssertNil(stack.peek())
    }

    func testPushAndCount() {
        stack.push(1)
        XCTAssertEqual(stack.count, 1)
        XCTAssertFalse(stack.isEmpty)

        stack.push(2)
        XCTAssertEqual(stack.count, 2)
    }

    func testPop() {
        stack.push(1)
        stack.push(2)

        XCTAssertEqual(stack.pop(), 2)
        XCTAssertEqual(stack.count, 1)

        XCTAssertEqual(stack.pop(), 1)
        XCTAssertTrue(stack.isEmpty)

        XCTAssertNil(stack.pop())
    }

    func testPeek() {
        XCTAssertNil(stack.peek())

        stack.push(1)
        XCTAssertEqual(stack.peek(), 1)
        XCTAssertEqual(stack.count, 1)

        stack.push(2)
        XCTAssertEqual(stack.peek(), 2)
        XCTAssertEqual(stack.count, 2)
    }

    func testClear() {
        stack.push(1)
        stack.push(2)
        stack.push(3)

        stack.clear()

        XCTAssertTrue(stack.isEmpty)
        XCTAssertEqual(stack.count, 0)
        XCTAssertNil(stack.peek())
    }

    func testThreadSafety() {
        let expectation = XCTestExpectation(description: "Thread safety test")
        let iterationCount = 1000
        let threadCount = 4

        DispatchQueue.concurrentPerform(iterations: threadCount) { _ in
            for i in 0..<iterationCount {
                self.stack.push(i)
            }
        }

        DispatchQueue.global().async {
            while self.stack.count < iterationCount * threadCount {
                // Wait for all pushes to complete
            }
            XCTAssertEqual(self.stack.count, iterationCount * threadCount)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
