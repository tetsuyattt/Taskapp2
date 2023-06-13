//
//  InputViewController.swift
//  taskapp
//
//  Created by 富樫　哲也 on 2023/06/11.
//

import UIKit
import RealmSwift //追加１３
import UserNotifications  //追加１６　ローカル通知設定

class InputViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
//↑追加（課題２）PickerViewからのイベントを受け取って、TextFieldに値をセットするために、UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegateの3つを追加
    
    //↓↓↓追加４
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    //-------追加(課題１）
    @IBOutlet weak var categoryTextField: UITextField!
   
    //-------追加(課題２）カテゴリーのpickerView実装
    var categories: [String] = []
    weak var pickerView: UIPickerView?
    //-------課題→次はviewDidLoadのところ
    
    var task: Task!  //←追加１０　cellSegueの時
    let realm = try! Realm()   //追加１３
    
    //---------------------------ここから追加１３
    //-------------シュミレーターで使った時に、データを入力してもローカル通知が機能せず、入力したデータも保存されていないっていうことがおきた。↓ここのクラス継承のコードが「viewWillAppear」になっていたからだった「画面が消える前に保存してね」っていうものだからだったのか。そりゃ表示されないわ
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            
            //----------追加（課題１）
            //こことviewDidloadに入力したら、カテゴリー欄に保存されるようになった
            self.task.category = self.categoryTextField.text!
            
            self.realm.add(self.task, update: .modified)
        }
        
        setNotification(task: task)   //追加１６
        
        super.viewWillDisappear(animated)
    }
    //----------------------------ここまで追加１３
    
    //-------------------------------ここから追加１６　ローカル通知
    // notification = 通知
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        //タイトルと内容を設定　（中身がない場合、メッセージなしで音だけの通知になるので、「（xxなし）」を表示する）
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        
        //ローカル通知が発動するtrigar(日付マッチ)を作成
        let calendar = Calendar.current   //←現在(今日)の日付？
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let triggar = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //identifier, content, trigarからローカル通知を作成(identifierが同じだと、ローカル通知を上書き保存)
        let request = UNNotificationRequest(identifier: String( task.id.stringValue), content: content, trigger: triggar)
        
        //ローカル通知を登録する
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")
        }
        //↑errorが　nil なら「ローカル通知の登録に成功した」と表示する。errorがあれば「error」と表示する
        
        //↓未通知のローカル通知一覧をログ出力
        // pending = 保留中
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
    //----------------------------------------ここまで追加１６
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //----------------------------------ここから追加１２
        //背景をタップしたらdismissKeyboardメソッドを呼ぶようにする
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
        //-----------追加（課題１）
        //こことviewWillDisappearに入力したら、カテゴリー欄に保存されるようになった
        categoryTextField.text = task.category
        
        //---------------------------ここから追加（課題２）
        categories.append("")
        categories.append("仕事")
        categories.append("勉強")
        categories.append("遊び")
        categories.append("その他")
        
        let pv = UIPickerView()
        pv.delegate = self
        pv.delegate = self
        
        categoryTextField.delegate = self
        categoryTextField.inputAssistantItem.leadingBarButtonGroups = []
        categoryTextField.inputView = pv
        self.pickerView = pv
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        categoryTextField.text = categories[row]
    }
    //-----------------------------ここまで追加（課題２）
    
    
    
        @objc func dismissKeyboard(){
            //キーボード閉じる
            view.endEditing(true)
        }
    //----------------------------------ここまで追加１２
        
   
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
