//
//  PegTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 2/2/24.
//

import XCTest
@testable import PeggleClone

final class PegTests: XCTestCase {
    func testInit() {
        let id = UUID()
        let position = CGPoint(x: 100, y: 200)
        let pegtype = PegType.NormalPeg
        let peg = Peg(id: id, position: position, pegtype: pegtype)

        XCTAssertEqual(peg.id, id, "Incorrect ID")
        XCTAssertEqual(peg.position, position, "Incorrect position")
        XCTAssertEqual(peg.pegtype, pegtype, "Incorrect peg type")
        XCTAssertEqual(peg.diameter, Peg.DEFAULT_PEG_DIAMETER, "Incorrect default diameter")
        XCTAssertEqual(peg.rotation, Peg.DEFAULT_PEG_ANGLE, "Incorrect default rotation")
    }

    func testSetPosition() {
        let initialPosition = CGPoint(x: 10, y: 20)
        let peg = Peg(id: UUID(), position: initialPosition, pegtype: .NormalPeg)

        let newPosition = CGPoint(x: 30, y: 40)
        peg.setPosition(newPosition: newPosition)
        XCTAssertEqual(peg.position, newPosition, "Peg position should be updated")

        let anotherNewPosition = CGPoint(x: 15, y: 25)
        peg.setPosition(newPosition: anotherNewPosition)
        XCTAssertEqual(peg.position, anotherNewPosition, "Peg position should be updated again")

        peg.setPosition(newPosition: anotherNewPosition)
        XCTAssertEqual(peg.position, anotherNewPosition, "Setting position to the same position should have no effect")

        let negativePosition = CGPoint(x: -5, y: 40)
        peg.setPosition(newPosition: negativePosition)
        XCTAssertEqual(peg.position, anotherNewPosition, "Should have no effect due to invalid position input")
    }

    func testSetRotation() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .NormalPeg)
        let newRotation = 90.0

        peg.setRotation(newAngle: newRotation)

        XCTAssertEqual(peg.rotation, newRotation, "Failed to set rotation")
    }

    func testSetDiameter() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .NormalPeg)
        let newDiameter = 60.0

        peg.setDiameter(newDiameter: newDiameter)

        XCTAssertEqual(peg.diameter, newDiameter, "Failed to set diameter")
    }
}
