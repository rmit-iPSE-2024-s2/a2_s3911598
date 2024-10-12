//
//  Profile.swift
//  a2_s3911598
//
//  Created by Lea Wang on 1/10/2024.
//

//
//  Profile.swift
//  iOS SwiftUI Login
//
//  Created by Auth0 on 7/18/22.
//  Companion project for the Auth0 video
//  “Integrating Auth0 within a SwiftUI app”
//
//  Licensed under the Apache 2.0 license
//  (https://www.apache.org/licenses/LICENSE-2.0)

import JWTDecode

/// The `Profile` struct represents a user's profile information.
///
/// This struct contains the user's ID, name, email, email verification status, profile picture, and the last update timestamp.
/// It is part of the Auth0 example project for managing user identity within a SwiftUI application.
///
/// - Note: This code originates from the Auth0 tutorial project “Integrating Auth0 within a SwiftUI app”.
///
/// - Author: Auth0
/// - Version: 1.0
struct Profile {
    
    /// The unique identifier for the user.
    let id: String
    
    /// The user's name.
    let name: String
    
    /// The user's email address.
    let email: String
    
    /// A string representing whether the user's email is verified.
    let emailVerified: String
    
    /// The URL of the user's profile picture.
    let picture: String
    
    /// The timestamp of the last profile update.
    let updatedAt: String
}

extension Profile {
    
    /// A static property that returns an empty `Profile` instance.
    ///
    /// This property is used to generate a default `Profile` instance with no user data.
    ///
    /// - Returns: An empty `Profile` instance with no data.
    static var empty: Self {
        return Profile(
            id: "",
            name: "",
            email: "",
            emailVerified: "",
            picture: "",
            updatedAt: ""
        )
    }
    
    /// Creates and returns a `Profile` instance from the provided ID token.
    ///
    /// This method decodes the ID token and extracts user information such as ID, name, email, email verification status, profile picture, and last update timestamp.
    /// If the decoding fails or any data is missing, it returns an empty `Profile` instance.
    ///
    /// - Parameter idToken: A string representing the ID token that contains the user's information.
    /// - Returns: A `Profile` instance populated with user information, or an empty `Profile` if decoding fails.
    static func from(_ idToken: String) -> Self {
        guard
            let jwt = try? decode(jwt: idToken),
            let id = jwt.subject,
            let name = jwt.claim(name: "name").string,
            let email = jwt.claim(name: "email").string,
            let emailVerified = jwt.claim(name: "email_verified").boolean,
            let picture = jwt.claim(name: "picture").string,
            let updatedAt = jwt.claim(name: "updated_at").string
        else {
            return .empty
        }
        
        return Profile(
            id: id,
            name: name,
            email: email,
            emailVerified: String(describing: emailVerified),
            picture: picture,
            updatedAt: updatedAt
        )
    }
}
