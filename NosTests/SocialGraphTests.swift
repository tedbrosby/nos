//
//  SocialGraphTests.swift
//  NosTests
//
//  Created by Matthew Lorentz on 4/18/23.
//

import XCTest
import CoreData

// swiftlint:disable implicitly_unwrapped_optional

final class SocialGraphTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var testContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        persistenceController = PersistenceController(inMemory: true)
        testContext = persistenceController.container.viewContext
    }

    func testEmpty() async throws {
        // Arrange
        _ = try Author.findOrCreate(by: KeyFixture.alice.publicKeyHex, context: testContext)
        
        // Act
        let sut = await SocialGraph(userKey: KeyFixture.alice.publicKeyHex, context: testContext)
        try testContext.save()
        
        // Assert
        let followedKeys = await sut.followedKeys
        XCTAssertEqual(followedKeys, [KeyFixture.alice.publicKeyHex])
    }
    
    func testOneFollower() async throws {
        // Arrange
        let alice = try Author.findOrCreate(by: KeyFixture.alice.publicKeyHex, context: testContext)
        let bob = try Author.findOrCreate(by: KeyFixture.bob.publicKeyHex, context: testContext)
        let follow = try Follow.findOrCreate(
            source: alice,
            destination: bob,
            context: testContext
        )
        
        // Add to the current user's follows
        alice.follows = (alice.follows ?? NSSet()).adding(follow)
        
        // Add from the current user to the author's followers
        bob.followers = (bob.followers ?? NSSet()).adding(follow)
        
        // Act
        let sut = await SocialGraph(userKey: KeyFixture.alice.publicKeyHex, context: testContext)
        try testContext.save()
        
        // Assert
        let followedKeys = await sut.followedKeys
        XCTAssertEqual(followedKeys, [KeyFixture.alice.publicKeyHex, KeyFixture.bob.publicKeyHex])
    }
}
// swiftlint:enable implicitly_unwrapped_optional
