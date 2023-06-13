//
//  Task.swift
//  taskapp
//
//  Created by 富樫　哲也 on 2023/06/11.
//

//-------------ここから追加５
import RealmSwift
class Task: Object {
    
    //管理用のID。プライマリーキー
    @Persisted(primaryKey: true) var id: ObjectId
    
    
    //タイトル
    @Persisted var title = ""
    
    //内容
    @Persisted var contents = ""
    
    //日時
    @Persisted var date = Date()
    
    //カテゴリー（課題１）
    @Persisted var category = ""
}
//----------------ここまで追加５
