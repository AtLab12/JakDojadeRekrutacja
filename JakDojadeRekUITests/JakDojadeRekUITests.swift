//
//  JakDojadeRekUITests.swift
//  JakDojadeRekUITests
//
//  Created by Mikolaj Zawada on 09/05/2024.
//

import XCTest

final class JakDojadeRekUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testStationSelection() throws {
        let stationsTable = app.tables["StationsTable"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: stationsTable, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        addUIInterruptionMonitor(withDescription: "Location Permission") { (alert) -> Bool in
            if alert.buttons["Allow While Using App"].exists {
                alert.buttons["Allow While Using App"].tap()
                return true
            }
            return false
        }
        
        app.tap()
        
        let firstCellExists = stationsTable.cells.element(boundBy: 0).waitForExistence(timeout: 10)
        XCTAssertTrue(firstCellExists, "No stations are displayed in the table.")
        stationsTable.cells.element(boundBy: 0).tap()
        
        // Checking the existance of station details
        let stationNameLabel = app.staticTexts["StationNameLabel"]
        XCTAssertTrue(stationNameLabel.exists)
    }
}
