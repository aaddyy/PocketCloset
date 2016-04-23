import UIKit

class CheckTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var Image: UIImage!
    var Title: [String]!
    var Descript: [String]!

    //ソースコードでインスタンスを生成時に初期化
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //プロトコル指定
        self.delegate = self
        self.dataSource = self
        
        self.registerNib(UINib(nibName: "SiteTopTableViewCell", bundle: nil), forCellReuseIdentifier: "SiteTopTableViewCell")
        self.registerNib(UINib(nibName: "InfoTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoTableViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //セクション
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    //セル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    
    //セルの内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("SiteTopTableViewCell", forIndexPath: indexPath) as! SiteTopTableViewCell
        cell.willRegister.image = Image
    return cell
    } else {
        let cell = tableView.dequeueReusableCellWithIdentifier("InfoTableViewCell", forIndexPath: indexPath) as! InfoTableViewCell
        cell.title.text = Title[indexPath.row]
        cell.descript.text = Descript[indexPath.row]
    return cell
    }
    }
    
    //セルの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        } else {
            return 45
        }
    }
}

