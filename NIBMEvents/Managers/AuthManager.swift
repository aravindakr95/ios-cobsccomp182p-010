//
//  AuthManager.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import LocalAuthentication

import FirebaseAuth

final class AuthManager {
    public static let sharedInstance = AuthManager()
    var user: User!
    var userProfile: UserProfile!

    func createUser(emailField: NETextField, passwordField: NETextField,
                    completion: @escaping (_ success: User?, _ error: String?) -> Void) {
        guard
            let email = emailField.text,
            let password = passwordField.text
            else { return }

        Auth.auth().createUser(withEmail: email, password: password, completion: {(authResult, error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
            } else {
                completion(authResult?.user, nil)
            }
        })
    }
    
    func getUserProfile(uid: String, completion: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        DatabaseManager.sharedInstance.retrieveDocumentWhere(finder: "uid", value: uid, collection: "users") { profile, error in
            
            if error != nil {
                completion(nil, error)
            } else {
                self.userProfile = profile
                completion(true, nil)
            }
        }
    }

    func signIn(emailField: String, passwordField: String,
                completion: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        Auth.auth().signIn(withEmail: emailField, password: passwordField, completion: {(_ authResult, error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
            } else {
                self.user = authResult?.user
                completion(true, nil)
            }
        })
    }

    func signOut(completion: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        let firebaseAuth = Auth.auth()

        do {
            try firebaseAuth.signOut()
            completion(true, nil)
        } catch let signOutError as NSError {
            completion(nil, "Error signing out: %@ \(signOutError)")
        }
    }

    func currentUser(completion: @escaping (_ success: User?, _ error: String?) -> Void) {
        let user = Auth.auth().currentUser

        if user != nil {
            self.user = user
            completion(user!, nil)
        } else {
            completion(nil, "Current user expired or invalid.")
        }
    }

    func sendPasswordReset(emailField: NETextField, completion: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        guard
            let email = emailField.text else { return }

        Auth.auth().sendPasswordReset(withEmail: email, completion: {error in
            if error != nil {
                completion(nil, error?.localizedDescription)
            } else {
                completion(true, nil)
            }
        })
    }

    func isAuthorized(completion: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        self.currentUser {(userData, _ error) in
            let isAuthorized = UserDefaults.standard.bool(forKey: "isAuthorized")
            if userData != nil && isAuthorized {
                completion(true, nil)
            } else {
                completion(false, "Not an valid user.")
            }
        }
    }

    func authWithBioMetrics(completion: @escaping (_ type: String?, _ success: Bool?, _ error: String?) -> Void) {
        let localAuthContext = LAContext()
        var error: NSError?

        if localAuthContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let biometricType = localAuthContext.biometryType == LABiometryType.faceID ? "Face ID" : "Touch ID"
            let reason = "Please authenticate using your \(biometricType)."

            localAuthContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason,
                                            reply: {(_ success, error) in
                                                if error != nil {
                                                    completion(biometricType, nil, error?.localizedDescription)
                                                } else {
                                                    completion(biometricType, true, nil)
                                                }
            })
        } else {
            completion("Not Supported", nil, "Device is not supported for Biometrics Authentication.")
        }
    }
}
