//
//  ViewController.swift
//  taskapp
//
//  Created by 富樫　哲也 on 2023/06/11.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //↑デリゲートとデータソース追加２
    //↓追加１
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //↓追加１　　　//dimension=寸法
        tableView.fillerRowHeight = UITableView.automaticDimension
        //--------------------------------ここから追加２
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //データの数を返すメソッド（セルの数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //再生可能なセルを得る
        //dequeue=待ち行列からデータを取りだすこと
        //enqueue=待ち行列にデータを追加すること
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
        
    }
    //各セルを選択した時に行われるメソッド
    //「did select row at」はセルをタップしたって意味.「row」は「行」とかセル
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //↓追加３cellSegue実装後
        performSegue(withIdentifier: "cellSegue",sender: nil)
        
        
    }
    //セルが削除可能なことを伝えるメソッド
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
         return .delete
     }
    //deleteボタンが押されたときの呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    //--------------------------------ここまで追加２
    
    
    
}
