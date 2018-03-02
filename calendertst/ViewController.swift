import UIKit


extension UIView {
    
    enum BorderPosition {
        case Top
        case Right
        case Bottom
        case Left
    }
    
    func border(borderWidth: CGFloat, borderColor: UIColor?, borderRadius: CGFloat?) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
        if let _ = borderRadius {
            self.layer.cornerRadius = borderRadius!
        }
        self.layer.masksToBounds = true
    }
    
    func border(positions: [BorderPosition], borderWidth: CGFloat, borderColor: UIColor?) {
        
        let topLine = CALayer()
        let leftLine = CALayer()
        let bottomLine = CALayer()
        let rightLine = CALayer()
        
        self.layer.sublayers = nil
        self.layer.masksToBounds = true
        
        if let _ = borderColor {
            topLine.backgroundColor = borderColor!.cgColor
            leftLine.backgroundColor = borderColor!.cgColor
            bottomLine.backgroundColor = borderColor!.cgColor
            rightLine.backgroundColor = borderColor!.cgColor
        } else {
            topLine.backgroundColor = UIColor.white.cgColor
            leftLine.backgroundColor = UIColor.white.cgColor
            bottomLine.backgroundColor = UIColor.white.cgColor
            rightLine.backgroundColor = UIColor.white.cgColor
        }
        
        if positions.contains(.Top) {
            topLine.frame = CGRect(x:0.0, y:0.0, width:self.frame.width, height:borderWidth)
            self.layer.addSublayer(topLine)
        }
        if positions.contains(.Left) {
            leftLine.frame = CGRect(x:0.0,y: 10.0, width:borderWidth,height: 100)
            self.layer.addSublayer(leftLine)
        }
        if positions.contains(.Bottom) {
            bottomLine.frame = CGRect(x:0.0,y: self.frame.height - borderWidth, width:self.frame.width, height:borderWidth)
            self.layer.addSublayer(bottomLine)
        }
        if positions.contains(.Right) {
            rightLine.frame = CGRect(x:self.frame.width - borderWidth, y:0.0,width: borderWidth, height:self.frame.height)
            self.layer.addSublayer(rightLine)
        }
        
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let _ = self.layer.borderColor {
                return UIColor(cgColor: self.layer.borderColor!)
            }
            return nil
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}

class ViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{ let dateManager = DateManager()
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let numOfDays = 7       //1週間の日数
    let cellMargin : CGFloat = 0.0  //セルのマージン。セルのアイテムのマージンも別にあって紛らわしい。アイテムのマージンはゼロに設定し直してる
    
    //OUTLET
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        headerTitle.text = dateManager.CalendarHeader()  //追加

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //コレクションビューのセクション数　今回は2つに分ける
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    //データの個数（DataSourceを設定した場合に必要な項目）
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 0){   //section:0は曜日を表示
            return numOfDays
        }else{
//            return dateManager.daysAcquisition()       //section:1は日付を表示 　※セルの数は始点から終点までの日数
        return 300
        }
    }
    
    //データを返すメソッド（DataSourceを設定した場合に必要な項目）
    //動作確認の為セルの背景を変える。曜日については表示する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //コレクションビューから識別子「CalendarCell」のセルを取得する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        if(indexPath.section == 0){             //曜日表示
            cell.backgroundColor = UIColor.green
            cell.textLabel.text = weekArray[indexPath.row]
            
        }else{                                  //日付表示
            cell.backgroundColor = UIColor.white
            cell.textLabel.text = dateManager.conversionDateFormat(index: indexPath.row) //Index番号から表示する日を求める
        }
        //追加⇨
        //土曜日は赤　日曜日は青　にテキストカラーを変更する
        if(indexPath.row % 7 == 0){
            cell.textLabel.textColor = UIColor.red
        }else if(indexPath.row % 7 == 6){
            cell.textLabel.textColor = UIColor.blue
        }else{
            cell.textLabel.textColor = UIColor.gray
        }
        
        //セルの日付を取得
        let day = Int(dateManager.conversionDateFormat(index:indexPath.row))!
        if(day == 1){
            cell.textLabel.border(positions:[.Top,.Left],borderWidth:1,borderColor:UIColor.black)
        }else if(day <= 7){
            cell.textLabel.border(positions:[.Top],borderWidth:1,borderColor:UIColor.black)
        }else{
            cell.textLabel.border(positions:[.Top],borderWidth:0,borderColor:UIColor.white)
        }
        cell.tag = Int(dateManager.CalendarHeader2())
        print(dateManager.CalendarHeader2())
        //⇦ここまで
        return cell
    }
    
    //セルをクリックしたら呼ばれる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Num：\(indexPath.row) Section:\(indexPath.section)")
    }
    
    /*
     
     セルのレイアウト設定
     
     */
    //セルサイズの指定（UICollectionViewDelegateFlowLayoutで必須）　横幅いっぱいにセルが広がるようにしたい
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin:CGFloat = 8.0
        let widths:CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin)/CGFloat(numOfDays)
        let heights:CGFloat = collectionView.frame.size.height/8//セルの縦
        
        return CGSize(width:widths,height:heights)
    }
    
    //セルのアイテムのマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0 , 0.0 , 0.0 , 0.0 )  //マージン(top , left , bottom , right)
    }
    
    //セルの水平方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    //セルの垂直方向のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    //前月ボタン
    @IBAction func prevMonthBtn(_ sender: UIButton) {
        dateManager.preMonthCalendar()
        calenderCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
    }
    //翌月ボタン
    @IBAction func nextMonthBtn(_ sender: UIButton) {
        dateManager.nextMonthCalendar()
        calenderCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
    }
    //前日ボタン
    @IBAction func prevDayBtn(_ sender: UIButton) {
        dateManager.preDayCalendar()
        calenderCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
    }
    //前日ボタン
    @IBAction func nextDayBtn(_ sender: UIButton) {
        dateManager.nextDayCalendar()
        calenderCollectionView.reloadData()
        headerTitle.text = dateManager.CalendarHeader()
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCell = calenderCollectionView.visibleCells.filter{
            return calenderCollectionView.bounds.contains($0.frame)
        }
        
        var visibleCellTag = Array<Int>()
        if(visibleCell != []){
            visibleCellTag = visibleCell.map{$0.tag}
            //月は奇数か偶数か　割り切れるものだけを取り出す
            let even = visibleCellTag.filter{
                return $0 % 2 == 0
            }
            let odd = visibleCellTag.filter{
                return $0 % 2 != 0
            }
            
            let month:Int = Int(dateManager.CalendarHeader2())
            let digit = numberOfDigit(month: month)
            //oddかevenの多い方を返す
//            let month = even.count >= odd.count ? even[0] : odd[0]
            
            //桁数によって分岐
//            let digit = numberOfDigit(month: month)
            if(digit == 5){
                monthLabel.text = String(month / 10) + "年" + String(month % 10) + "月"
            }else if(digit == 6){
                monthLabel.text = String(month / 100) + "年" + String(month % 100) + "月"
            }
        }
    }
    
    func numberOfDigit(month:Int) -> Int{
        var num = month
        var cnt = 1
        while(num / 10 != 0){
            cnt = cnt + 1
            num = num / 10
        }
        return cnt
        
    }
}
