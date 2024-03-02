//
//  PersistenceTests.swift
//  PeggleCloneTests
//
//  Created by Ho Jun Hao on 2/2/24.
//

import XCTest
@testable import PeggleClone

final class PersistenceTests: XCTestCase {
    func testSaveGameboard() {
        let coreDataDelegate = GameboardCoreDataDelegate()
        let gameboard = Gameboard(id: UUID(),
                                  name: "Test",
                                  boardSize: CGSize(width: 10, height: 10),
                                  pegs: [],
                                  blocks: [])

        coreDataDelegate.saveGameboard(gameboard: gameboard)
        let gameboards = coreDataDelegate.getGameboards()
        XCTAssertTrue(gameboards.contains { $0.id == gameboard.id }, "Failed to save gameboard")
        XCTAssertEqual(gameboards.filter { $0.id == gameboard.id }[0].name,
                       "Test",
                       "Failed to save gameboard with correct name")
        XCTAssertEqual(gameboards.filter { $0.id == gameboard.id }[0].height,
                       10,
                       "Failed to save gameboard with correct board height size")
        XCTAssertEqual(gameboards.filter { $0.id == gameboard.id }[0].width,
                       10,
                       "Failed to save gameboard with correct board width size")

        // delete gameboard
        coreDataDelegate.deleteGameboard(id: gameboard.id)
    }

    func testSaveGameboardWithSameID() {
        let coreDataDelegate = GameboardCoreDataDelegate()
        let id = UUID()
        let gameboard1 = Gameboard(id: id,
                                   name: "Test1",
                                   boardSize: CGSize(width: 10, height: 10),
                                   pegs: [],
                                   blocks: [])
        let gameboard2 = Gameboard(id: id,
                                   name: "Test2",
                                   boardSize: CGSize(width: 20, height: 20),
                                   pegs: [],
                                   blocks: [])
        coreDataDelegate.saveGameboard(gameboard: gameboard1)
        coreDataDelegate.saveGameboard(gameboard: gameboard2)
        let gameboards = coreDataDelegate.getGameboards()
        XCTAssertEqual(gameboards.filter { $0.id == id }.count, 1, "Failed to save gameboard with same ID")
        XCTAssertEqual(gameboards.filter { $0.id == id }[0].name,
                       "Test2",
                       "Failed to update existing gameboard with same ID")

        // delete gameboard
        coreDataDelegate.deleteGameboard(id: id)
    }

    func testGetGameboards() {
        let coreDataDelegate = GameboardCoreDataDelegate()
        let gameboardsCount = coreDataDelegate.getGameboards().count
        let gameboard1 = Gameboard(id: UUID(),
                                   name: "Test1",
                                   boardSize: CGSize(width: 10, height: 10),
                                   pegs: [],
                                   blocks: [])
        let gameboard2 = Gameboard(id: UUID(),
                                   name: "Test2",
                                   boardSize: CGSize(width: 20, height: 20),
                                   pegs: [],
                                   blocks: [])
        coreDataDelegate.saveGameboard(gameboard: gameboard1)
        coreDataDelegate.saveGameboard(gameboard: gameboard2)
        let gameboards = coreDataDelegate.getGameboards()
        XCTAssertEqual(gameboards.count, gameboardsCount + 2, "Incorrect number of gameboards fetched")

        // delete gameboards
        coreDataDelegate.deleteGameboard(id: gameboard1.id)
        coreDataDelegate.deleteGameboard(id: gameboard2.id)
    }

    func testDeleteGameboard() {
        let coreDataDelegate = GameboardCoreDataDelegate()
        let id = UUID()
        let gameboard = Gameboard(id: id, name: "Test", boardSize: CGSize(width: 10, height: 10), pegs: [], blocks: [])
        coreDataDelegate.saveGameboard(gameboard: gameboard)
        let gameboards = coreDataDelegate.getGameboards()
        XCTAssertTrue(gameboards.contains { $0.id == id }, "Failed to save gameboard before deletion")
        coreDataDelegate.deleteGameboard(id: id)
        let gameboards2 = coreDataDelegate.getGameboards()
        XCTAssertFalse(gameboards2.contains { $0.id == id }, "Failed to delete gameboard")
    }

    func testDeleteNonExistingGameboard() {
        let coreDataDelegate = GameboardCoreDataDelegate()
        let id = UUID()
        let gameboards = coreDataDelegate.getGameboards()
        XCTAssertFalse(gameboards.contains { $0.id == id }, "Gameboard was incorrectly found before deletion")
        coreDataDelegate.deleteGameboard(id: id)
        let gameboards2 = coreDataDelegate.getGameboards()
        XCTAssertFalse(gameboards2.contains { $0.id == id }, "Gameboard was incorrectly found after deletion")

    }

    func testGetNonExistingGameboard() {
        let coreDataDelegate = GameboardCoreDataDelegate()
        let id = UUID()
        let gameboard = coreDataDelegate.getGameboard(id: id)
        XCTAssertNil(gameboard, "Non-existing gameboard was incorrectly fetched")
    }

    func testGetExistingGameboard() {
        let coreDataDelegate = GameboardCoreDataDelegate()
        let gameboard = Gameboard(id: UUID(),
                                  name: "Test",
                                  boardSize: CGSize(width: 10, height: 10),
                                  pegs: [],
                                  blocks: [])
        coreDataDelegate.saveGameboard(gameboard: gameboard)
        let fetchedGameboard = coreDataDelegate.getGameboard(id: gameboard.id)
        XCTAssertEqual(fetchedGameboard?.id, gameboard.id, "Failed to fetch existing gameboard")

        // delete gameboard
        coreDataDelegate.deleteGameboard(id: gameboard.id)
    }
}
