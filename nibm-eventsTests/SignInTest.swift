//
//  LoginTest.swift
//
//
//  Created by Aravinda Rathnayake on 3/1/20.
//

import XCTest

@testable import nibm-events

class LoginTest: XCTestCase {
    
    var loginView: SignInViewController!
    var authDataManager  : AuthManager!
    
    //dummy user credentials
    var email:String = "aravinda@student.nibm.lk"
    var password:String = "Ara@1234"
    
    override func setUp() {
        self.loginView = SignInViewController()
        self.authDataManager = AuthManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoginDataIsCorrect() {
        
        //validated to email and password should be atleast 8 chars long
        XCTAssertEqual(self.loginView.validateLoginCredentials(email: self.email, password: self.password),true)
        
        
    }
    
    func testIsLoginSuccess() {
        
        self.loginView.email = self.email
        self.loginView.password = self.password
        //since this is an async task we need to add axpectation to Test
        let expectation = self.expectation(description: "Success")
        
        var authed :Bool!
        
        self.authDataManager.signIn(emailField: email, passwordField: password) { success, loading in
            
            expectation.fulfill(success)
            
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(authed, true)
        
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
}
