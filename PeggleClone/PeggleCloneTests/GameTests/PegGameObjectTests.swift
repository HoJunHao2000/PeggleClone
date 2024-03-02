//
//  PegGameObjectTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 17/2/24.
//

import XCTest
@testable import PeggleClone

final class PegGameObjectTests: XCTestCase {
    func testInitialization() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject = NormalPegGameObject(peg: peg)

        XCTAssertNotNil(pegGameObject, "Peg game object not initialised.")
    }

    func testPegType() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject = NormalPegGameObject(peg: peg)

        let peg2 = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .GoalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject2 = NormalPegGameObject(peg: peg2)

        XCTAssertEqual(pegGameObject.pegtype, PegType.NormalPeg, "Wrong pegtype returned")
        XCTAssertEqual(pegGameObject2.pegtype, PegType.GoalPeg, "Wrong pegtype returned")
    }

    func testPowerUp() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject = NormalPegGameObject(peg: peg)

        let peg2 = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .KaboomPeg, diameter: 1.0, rotation: 90)
        let pegGameObject2 = KaboomPegGameObject(peg: peg2)

        XCTAssertNil(pegGameObject.powerup, "Powerup should be nil")
        XCTAssertNotNil(pegGameObject2.powerup, "Powerup should not be nil")
    }

    func testHitCount() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject = NormalPegGameObject(peg: peg)

        XCTAssertEqual(pegGameObject.hitCount, 0, "Hit count should be 0 initially")
    }

    func testDiameter() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject = NormalPegGameObject(peg: peg)

        let peg2 = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .GoalPeg, diameter: 2.0, rotation: 90)
        let pegGameObject2 = NormalPegGameObject(peg: peg2)

        XCTAssertEqual(pegGameObject.diameter, 1.0, "Diameter property does not return the correct diameter")
        XCTAssertEqual(pegGameObject2.diameter, 2.0, "Diameter property does not return the correct diameter")
    }

    func testRotation() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject = NormalPegGameObject(peg: peg)

        let peg2 = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .GoalPeg, diameter: 1.0, rotation: 180)
        let pegGameObject2 = NormalPegGameObject(peg: peg2)

        XCTAssertEqual(pegGameObject.rotation, 90, "Rotation property does not return the correct rotation")
        XCTAssertEqual(pegGameObject2.rotation, 180, "Rotation property does not return the correct rotation")
    }

    func testPosition() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject = NormalPegGameObject(peg: peg)

        let peg2 = Peg(id: UUID(), position: CGPoint(x: 200, y: 300), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject2 = NormalPegGameObject(peg: peg2)

        XCTAssertEqual(pegGameObject.position,
                       CGPoint(x: 100, y: 200),
                       "Position property does not return the correct position")
        XCTAssertEqual(pegGameObject2.position,
                       CGPoint(x: 200, y: 300),
                       "Position property does not return the correct position")
    }

    func testIsLit() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject = NormalPegGameObject(peg: peg)
        XCTAssertFalse(pegGameObject.isLit, "isLit property should be false initially")

        pegGameObject.physicsObject.incrementHitCount()

        XCTAssertTrue(pegGameObject.isLit, "isLit property should return true when hitCount is greater than 0")

        // test special case for health peg (needs more than 2 hits to be lit)
        let peg2 = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .HealthPeg, diameter: 1.0, rotation: 90)
        let pegGameObject2 = HealthPegGameObject(peg: peg2)

        pegGameObject2.physicsObject.incrementHitCount()
        XCTAssertFalse(pegGameObject2.isLit, "isLit property should return false for health peg")

        pegGameObject2.physicsObject.incrementHitCount()
        XCTAssertFalse(pegGameObject2.isLit, "isLit property should return false for health peg")

        pegGameObject2.physicsObject.incrementHitCount()
        XCTAssertTrue(pegGameObject2.isLit, "isLit property should return true for health peg")

        // test special case for stubborn peg (never lit)
        let peg3 = Peg(id: UUID(),
                       position: CGPoint(x: 100, y: 200),
                       pegtype: .StubbornPeg,
                       diameter: 1.0,
                       rotation: 90)
        let pegGameObject3 = StubbornPegGameObject(peg: peg3)

        pegGameObject3.physicsObject.incrementHitCount()
        XCTAssertFalse(pegGameObject3.isLit, "isLit property should return false for stubborn peg")
    }

    func testShouldRemove() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject = NormalPegGameObject(peg: peg)

        for _ in 0..<121 {
            XCTAssertFalse(pegGameObject.shouldRemove,
                           "shouldRemove property should return false when hitCount is lesser thn MAX_HIT_COUNT")
            pegGameObject.physicsObject.incrementHitCount()
        }

        XCTAssertTrue(pegGameObject.shouldRemove,
                      "shouldRemove property should return true when hitCount is greater than MAX_HIT_COUNT")

        // test special case for health peg (needs more than 3 hits to be removed)
        let peg2 = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .HealthPeg, diameter: 1.0, rotation: 90)
        let pegGameObject2 = HealthPegGameObject(peg: peg2)

        for _ in 0..<4 {
            XCTAssertFalse(pegGameObject2.shouldRemove,
                           "shouldRemove property should return false for health peg")
            pegGameObject2.physicsObject.incrementHitCount()
        }

        XCTAssertTrue(pegGameObject2.shouldRemove, "shouldRemove property should return true for health peg")
    }

    func testMovabilityOfStubbornPeg() {
        let peg = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .StubbornPeg, diameter: 1.0, rotation: 90)
        let pegGameObject = StubbornPegGameObject(peg: peg)

        let peg2 = Peg(id: UUID(), position: CGPoint(x: 100, y: 200), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject2 = NormalPegGameObject(peg: peg2)

        XCTAssertTrue(pegGameObject.physicsObject.isMoveable, "Stubborn peg should be movable")
        XCTAssertFalse(pegGameObject2.physicsObject.isMoveable, "Normal peg not should be movable")
    }

    func testHashability() {
        let peg1 = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject1 = NormalPegGameObject(peg: peg1)
        let peg2 = Peg(id: UUID(), position: CGPoint(x: 10, y: 20), pegtype: .NormalPeg, diameter: 1.0, rotation: 90)
        let pegGameObject2 = NormalPegGameObject(peg: peg2)
        let peg3 = Peg(id: UUID(), position: CGPoint(x: 30, y: 40), pegtype: .GoalPeg, diameter: 2.0, rotation: 90)
        let pegGameObject3 = NormalPegGameObject(peg: peg3)

        XCTAssertEqual(pegGameObject1, pegGameObject1, "Equal objects should be considered equal")
        XCTAssertNotEqual(pegGameObject1, pegGameObject2, "Similar peg objects should still be different")
        XCTAssertNotEqual(pegGameObject1, pegGameObject3, "Different objects should be different")
    }
}
