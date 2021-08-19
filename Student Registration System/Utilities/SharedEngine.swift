//
//  SharedEngine.swift
//  Student Registration System
//
//  Created by Shohan Rahman on 8/19/21.
//

import Foundation

class SharedEngine {
    
    public static let shared: SharedEngine = SharedEngine()
    
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    func saveAccessToken(token: String) {
        userDefaults.setValue(token, forKey: SharedKey.TOKEN_KEY)
    }
    
    func getAccessToken() -> String {
        return userDefaults.string(forKey: SharedKey.TOKEN_KEY) ?? ""
    }
    
    func saveUserData(user: User?) {
        userDefaults.set(user?.role, forKey: SharedKey.ROLE_KEY)
        userDefaults.set(user?.id, forKey: SharedKey.ID_KEY)
        userDefaults.set(user?.email, forKey: SharedKey.EMAIL_KEY)
        userDefaults.set(user?.name, forKey: SharedKey.NAME_KEY)
        userDefaults.set(user?.photo, forKey: SharedKey.PHOTO_KEY)
        userDefaults.set(user?.dob, forKey: SharedKey.DOB_KEY)
        userDefaults.set(user?.university, forKey: SharedKey.UNIVERSITY_KEY)
    }
    
    func getUserData() -> User? {
        let role = userDefaults.string(forKey: SharedKey.ROLE_KEY)
        let id = userDefaults.integer(forKey: SharedKey.ID_KEY)
        let email = userDefaults.string(forKey: SharedKey.EMAIL_KEY)
        let name = userDefaults.string(forKey: SharedKey.NAME_KEY)
        let photo = userDefaults.string(forKey: SharedKey.PHOTO_KEY)
        let dob = userDefaults.string(forKey: SharedKey.DOB_KEY)
        let university = userDefaults.string(forKey: SharedKey.UNIVERSITY_KEY)
        
        return User(id: id, name: name, role: role, email: email, photo: photo, dob: dob, university: university)
    }
    
    func resetSharedEngine() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
    
    func savesSharedValue(value: Bool, forKey: String) {
        userDefaults.setValue(value, forKey: forKey)
    }
}

class SharedKey {
    
    public static let TOKEN_KEY = "token"
    public static let ROLE_KEY = "role"
    public static let NAME_KEY = "name"
    public static let EMAIL_KEY = "email"
    public static let ID_KEY = "id"
    public static let PHOTO_KEY = "photo"
    public static let DOB_KEY = "dob"
    public static let UNIVERSITY_KEY = "university"
}
