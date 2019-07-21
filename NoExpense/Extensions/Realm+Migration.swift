//
//  Realm+Migration.swift
//  NoExpense
//
//  Created by Aashish Tamsya on 21/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import RealmSwift

func realmMigration() {
  let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
  Realm.Configuration.defaultConfiguration = configuration
  do { _ = try Realm() } catch {}
}
