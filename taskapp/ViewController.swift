//
//  ViewController.swift
//  taskapp
//
//  Created by 富樫　哲也 on 2023/06/11.
//

import UIKit
import RealmSwift  //←追加６
import UserNotifications  //追加１７　タスク削除時に通知をキャンセル

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    //↑デリゲートとデータソース追加２
//    ↑---------追加（課題３）UISearchBarDelegate→次はviewDidLoadのとこ
//    ↑---------追加（課題3）UISearchResultsUpdating
    
    //↓追加１
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //-----------ここから追加（課題３）絞り込み
    
//    var searchBar: UISearchBar!　→Outlet接続するからいらない
    var searchController: UISearchController!
    var filteredArray: [Task] = []
    //-----------ここまで追加（課題３）絞り込み　→次はviewDidLoadのとこ

    
    
    //----------------------ここから追加６（２）
    //Realmインスタンスを取得
    let realm = try! Realm()
    
    //DB内のタスクが格納されるリスト
    //日付の近い順でソート：昇順
    //以降内容をアップデートするとリスト内は自動的に更新される
    //ascending=上昇
    //array=配列
    //（メンタリング時）Taskからデータを引っ張ってきて日付順に表示する
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending:true)
    //----------------------ここまで追加６（２）
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //↓追加１　　　//dimension=寸法
        tableView.fillerRowHeight = UITableView.automaticDimension
        //--------------------------------ここから追加２
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //-----------------ここから追加（課題３(2)）絞り込み
//        searchBar = UISearchBar()　→Outlet接続するからいらない
        //(メンタリング時コメント)デリゲートめっちゃ大事
//        searchBar.delegate = self
        searchBar.placeholder = "カテゴリーを検索"
        
        //　↓Outlet接続するからいらないよ
//        tableView.tableHeaderView = searchBar
        
//        navigationItem.titleView = searchBar
//
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        navigationItem.searchController = searchController
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
    }
    func filterContentForSearchText(_ searchText: String) {
        print(searchText)
        if searchText.isEmpty {
            
            //（武智さんよりアドバイス）Taskから引っ張ってきたデータをそのまま表示するってこと
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending:true)
        } else {
            
            //（武智さんよりアドバイス）いい線行ってるけど惜しい。サイトを参考に
            taskArray = realm.objects(Task.self).filter("category CONTAINS[cd] %@", searchText)
            
            //↓アドバイス前のやつ
//            filteredArray = taskArray.filter("category CONTAINS[cd] %@", searchText).toArray()
        }
        tableView.reloadData()
    }
    //---------------------ここまで追加（課題３(2)）絞り込み
    
    //データの数を返すメソッド（セルの数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
        //---------追加７（return 0 から修正）
        //---------　→追加（課題３）（return taskArray.count　から修正）
    }
    
    //各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //再生可能なセルを得る
        //dequeue=待ち行列からデータを取りだすこと
        //enqueue=待ち行列にデータを追加すること
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //セルに値を追加する-------------ここから追加８
        let task = taskArray[indexPath.row]
        //-------------- →追加（課題３）（let task = taskArray[indexPath.row]から変更）
       
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        //---------------------------ここまで追加８
  
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
        
        //---------------------------------ここから追加９、１７（２）
        if editingStyle == .delete {
            //削除するタスクを取得する（追加１７）
            let task = self.taskArray[indexPath.row]
            
            //削除するから、今後のローカル通知をしないようにする(追加１７)
            //stringvalue = 文字列値　？（追加１７）
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id.stringValue)])
            
            //↓データベースから削除するよメソッド（追加９）
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            //未通知のローカル通知一覧をログ出力(追加１７)
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
            }
        } //--------------------------------ここまで追加９、１７（２）
    }
    //------------------------------------ここから追加１０
//segueで画面遷移するときに呼ばれる
//「destination as」は目的地として〜って意味
//画面遷移した時に情報が渡される
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            inputViewController.task = Task()
        }
    }
    //-----------------------------------ここまで追加１０

    //--------------------------------------ここから追加１１
    //入力画面から戻ってきたときにTableViewを更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    //---------------------------------------ここまで追加１１
    
    
    
}
