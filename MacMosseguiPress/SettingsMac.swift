//
//  SettingsMac.swift
//  MacMosseguiPress
//
//  Created by MAC on 03/08/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

final class SettingsMac {
    
    var defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        
        self.defaults = defaults
        
        let categories = [WordpressCategory(wordpressId: "28", name: "Apple", Postdefault: false),
                          WordpressCategory(wordpressId: "24", name: "Podcast", Postdefault: true),
                          WordpressCategory(wordpressId: "3", name: "Mac", Postdefault: false),
                          WordpressCategory(wordpressId: "34", name: "iPhone", Postdefault: true),
                          WordpressCategory(wordpressId: "12", name: "Opinió", Postdefault: false)]
        
        let encoder = JSONEncoder()
        let c = try? encoder.encode(categories)
        
        defaults.register(defaults: [
            "app.mac.wordpress.post.server" : "localhost/wp-json/wp/v2/posts",
            "app.mac.wordpress.media.server" : "localhost/wp-json/wp/v2/media",
            "app.mac.storagemossegui.audio.url" : "https://storagemossegui.com/mlpaudio/4",
            "app.mac.wordpress.author.id" : "1",
            "app.mac.user" : "macma",
            "app.mac.password" : "1234",
            "app.mac.wordpress.categories" : c,
            "app.view.defaultIndexRadioButton" : 0,
            
        ])
    }
    
    var postServer: String {
        get {
            defaults.string(forKey: "app.mac.wordpress.post.server")!
        }
        set {
            defaults.set(newValue, forKey: "app.mac.wordpress.post.server")
        }
    }
    
    var mediaServer: String {
        get {
            defaults.string(forKey: "app.mac.storagemossegui.audio.url")!
        }
        set {
            defaults.set(newValue, forKey: "app.mac.storagemossegui.audio.url")
        }
    }
    
    var audioUrl: String {
        get {
            defaults.string(forKey: "app.mac.wordpress.media.server")!
        }
        set {
            defaults.set(newValue, forKey: "app.mac.wordpress.media.server")
        }
    }
    
    var authorId: String {
        get {
            defaults.string(forKey: "app.mac.wordpress.author.id")!
        }
        set {
            defaults.set(newValue, forKey: "app.mac.wordpress.author.id")
        }
    }
    
    var user: String {
        get {
            defaults.string(forKey: "app.mac.user")!
        }
        set {
            defaults.set(newValue, forKey: "app.mac.user")
        }
    }
    
    var password: String {
        get {
            defaults.string(forKey: "app.mac.password")!
        }
        set {
            defaults.set(newValue, forKey: "app.mac.password")
        }
    }
    
    var defaultIndexRadioButton: Int {
        get {
            defaults.integer(forKey: "app.view.defaultIndexRadioButton")
        }
        set {
            defaults.set(newValue, forKey: "app.view.defaultIndexRadioButton")
        }
    }
    
    var categories: [WordpressCategory] {
        
        get {
            var cats: [WordpressCategory] = [WordpressCategory(wordpressId: "aaa", name: "aaa", Postdefault: true)]
            if let savedCategories = defaults.object(forKey: "app.mac.wordpress.categories") as? Data {
                let decoder = JSONDecoder()
                if let loadedCategories = try? decoder.decode([WordpressCategory].self, from: savedCategories) {
                    cats = loadedCategories
                }
            }
            return cats
        }
        
        set {
            let encoder = JSONEncoder()
            let a = newValue
            if let encoded = try? encoder.encode(a) {
                defaults.set(encoded, forKey: "app.mac.wordpress.categories")
            }
        }
        
    }
    
    
}
