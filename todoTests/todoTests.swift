//
//  todoTests.swift
//  todoTests
//
//  Created by Ashutosh Singh on 24/05/25.
//

import XCTest
@testable import todo

final class todoTests: XCTestCase {
    
    var viewModel: TodoViewModel?
    
    override func setUpWithError() throws {
        viewModel = TodoViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testAdd() {
        
        let expectation = XCTestExpectation(description: "Todo update called")
        viewModel?.onTodosUpdated = {
            expectation.fulfill()
        }
        
        viewModel?.addTodo(title: "Hey", colorHex: "#ffffff")
        
        XCTAssertEqual(viewModel?.count, 1)
        XCTAssertEqual(viewModel?.getTodo(at: 0)?.title, "Hey")
        XCTAssertEqual(viewModel?.getTodo(at: 0)?.colorHex, "#ffffff")
        
        wait(for: [expectation], timeout: 1)
        
    }
    
    func testUpdate() {
        
        viewModel?.addTodo(title: "Hey-1", colorHex: "#ffffff")
        
        guard let id = viewModel?.getTodo(at: 0)?.id else {
            XCTFail("No ID found")
            return
        }
        
        viewModel?.updateTodo(id: id, newTitle: "Hey-2", newColorHex: "#fffffe")
        
        XCTAssertEqual(viewModel?.count, 1)
        XCTAssertEqual(viewModel?.getTodo(at: 0)?.title, "Hey-2")
        XCTAssertEqual(viewModel?.getTodo(at: 0)?.colorHex, "#fffffe")
        
        
    }
    
    func testDelete() {
        
        viewModel?.addTodo(title: "Hey-3", colorHex: "#ffffff")
        
        let intialCount = viewModel?.count
        
        guard let id = viewModel?.getTodo(at: 0)?.id else {
            XCTFail("No ID found")
            return
        }
        
        viewModel?.deleteTodo(id: id)
        
        XCTAssertEqual(viewModel?.count, (intialCount ?? 0) - 1)
    }
    
}
