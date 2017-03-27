

import UIKit
@objc(topicDetailCellDelegate)
protocol topicDetailCellDelegate {
    @objc optional func changCellHeight(height : CGFloat,index : NSIndexPath) //修改Cell高度的方法1 #废弃#
    
    @objc optional func changCellHeight(height : CGFloat,momentId : String) //修改Cell高度的方法2
    @objc optional func changeMineMoment(mine : Bool,mid : String)            //右上角操作按钮点击事件
    @objc optional func praiseTo(Usr : String,moment : String)                //点赞事件
    @objc optional func commentMoment(momentid : String,index : String)       //评论icon点击事件
    @objc optional func jumoToCenter(Usr : String)                            //头像点击事件
    @objc optional func tapTopicTitle(tid : String)                       //话题点击事件
    
}

public class TopicDetailCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: -----Var-----
    public var topicDetailCellModel : TopicDetailModel{ //数据源
        get{
            return self.topicDetailCellModel
        }
        set(cellmodel){
            self.changeUI(model: cellmodel)
        }
    }
    
    public var cellSection : Int{  //index
        get{
            return self.cellSection
        }
        set(cellmodel){
            self.makeCellSection(section: cellmodel)
        }
    }
    
    public var hideContentState : Int{ //“展开全部”标签隐藏标识符 1-隐藏，0-不隐藏
        get{
            return self.hideContentState
        }
        set(cellmodel){
            self.makeHideState(state: cellmodel)
        }
    }
    
    public var cellUseOneSection : Bool{
        get{
            return self.cellUseOneSection
        }
        set(cellmodel){
            self.addGray(exit: cellmodel)
        }
    }
    
    var HeadImageView : UIImageView!    //头像
    var UsrInfoLabel : UILabel!         //姓名+学校+时间
    var ActionView : UIImageView!       //删除、举报操作
    var ContentImage : UIImageView!     //动态图片
    var topicLabel : UILabel!           //话题名称
    var contentLabel : TopicDetailContentLabel!         //动态内容
    var checkTotalLabel : UILabel!      //"展开全部"标签
    var praiseImage : UIImageView!      //点赞图片
    var commitImage : UIImageView!      //评论图片
    var CountLabel : UILabel!           //点赞人数+评论人数统计
    var dashView : UIView!              //虚线

    var totalPraise : Int!                         //点赞人数
    var totalCommit : Int!                         //评论人数
    weak var heightFitTableView : UITableView?     //废弃
    var delegate : topicDetailCellDelegate? = nil  //代理
    var nowCellSection : Int!                      //当前Index
    var newLineNum : Int!                          //动态内容有几行
    var contentHide : Int!                         //“展开全部”标签隐藏标识符 1-隐藏，0-不隐藏
    var usrUid : String!
    var clearView : UIView!
    var id_moment : String!
    var id_topic :String!
    var exitGray : Int!
    var index_section : NSInteger!
    
    //MARK: -----UI-----
    func initUI() {
        newLineNum = 0
        contentHide = 0
        usrUid = "0"
        id_moment = "0"
        exitGray = 0
        //跳转个人中心点击区域
        clearView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 60))
        clearView.backgroundColor = UIColor.clear
        let jumpToCenter = UITapGestureRecognizer.init(target: self, action: #selector(headTapMethod(sender:)))
        clearView.addGestureRecognizer(jumpToCenter)
        self.contentView.addSubview(clearView)
        
        HeadImageView = UIImageView.init(frame: CGRect.init(x: 15, y: 15, width: 30, height: 30))
        HeadImageView.isUserInteractionEnabled = false
        HeadImageView.layer.masksToBounds = true
        HeadImageView.layer.cornerRadius = 15
        clearView.addSubview(HeadImageView)
        
        UsrInfoLabel = UILabel.init(frame: CGRect.init(x: 55, y: 0, width: ScreenWidth - 55 - 45, height: 60))
        UsrInfoLabel.isUserInteractionEnabled = false
        UsrInfoLabel.numberOfLines = 0
        clearView.addSubview(UsrInfoLabel)
        
        ActionView = UIImageView.init(frame: CGRect.init(x: ScreenWidth - 15 - 17, y: 0, width: 17, height: 60))
        ActionView.isUserInteractionEnabled = false
        ActionView.clipsToBounds = true
        ActionView.contentMode = UIViewContentMode.scaleAspectFit;
        ActionView.image = #imageLiteral(resourceName: "3408Action.png")
        clearView.addSubview(ActionView)
        
        ContentImage = UIImageView.init(frame: CGRect.init(x: 0, y: 60, width: ScreenWidth, height: ScreenWidth * 200 / 375))
        ContentImage.clipsToBounds = true
        ContentImage.contentMode = UIViewContentMode.scaleAspectFill
        ContentImage.backgroundColor = ColorMethodho(hexValue: 0xe6e6e6)
        self.contentView.addSubview(ContentImage)
        
        topicLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: ScreenWidth - 30, height: 13))
        topicLabel.textColor = ColorMethodho(hexValue: 0x00c18b)
        topicLabel.isUserInteractionEnabled = true
        topicLabel.font = UIFont.systemFont(ofSize: 13)
        let topicTap = UITapGestureRecognizer.init(target: self, action: #selector(topicLabelTapMethod))
        topicLabel.addGestureRecognizer(topicTap)
        self.contentView.addSubview(topicLabel)
        
//        contentLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: ScreenWidth - 30, height: 10))
//        contentLabel.numberOfLines = 0
//        self.contentView.addSubview(contentLabel)
        
        contentLabel = TopicDetailContentLabel.init(frame: CGRect.init(x: 15, y: 0, width: ScreenWidth - 30, height: 10))
        self.contentView.addSubview(contentLabel)
        
        checkTotalLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: 50, height: 10))
        checkTotalLabel.text = "查看全部"
        checkTotalLabel.textColor = ColorMethodho(hexValue: 0xb2b2b2)
        checkTotalLabel.font = UIFont.systemFont(ofSize: 10)
        let checkTotalTap = UITapGestureRecognizer.init(target: self, action: #selector(checkTotalTapMethod))
        checkTotalLabel.addGestureRecognizer(checkTotalTap)
        self.contentView.addSubview(checkTotalLabel)
        
        dashView = DashViewWidget.init(frame: CGRect.init(x: 15, y: 0, width: ScreenWidth - 15, height: 0.5))
        self.contentView .addSubview(dashView);
        
        praiseImage = UIImageView.init(frame: CGRect.init(x: 15, y: 0, width: 21, height: 20))
        praiseImage.image = #imageLiteral(resourceName: "4240UnPraise.png")
        let praiseTap = UITapGestureRecognizer.init(target: self, action: #selector(praiseTapMethod))
        praiseImage.addGestureRecognizer(praiseTap)
        self.contentView.addSubview(praiseImage)
        
        commitImage = UIImageView.init(frame: CGRect.init(x: 56, y: 0, width: 21, height: 20))
        commitImage.image = #imageLiteral(resourceName: "4240Commit.png")
        let commitTap = UITapGestureRecognizer.init(target: self, action: #selector(commitTapMethod))
        commitImage.addGestureRecognizer(commitTap)
        self.contentView.addSubview(commitImage)
        
        CountLabel = UILabel.init(frame: CGRect.init(x: 80, y: 0, width: ScreenWidth - 80 - 15, height: 50))
        CountLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(CountLabel)
        
    }
    
    func makeCellSection(section : Int) {
        nowCellSection = section
    }
    
    func makeHideState(state : Int) {
        contentHide = state
    }
    
    func addGray(exit : Bool) {
        if exit {
            exitGray = 1
        }else{
            exitGray = 0
        }
    }
    
    func changeUI(model : TopicDetailModel) {
        
        self.backgroundColor = ColorMethodho(hexValue: 0xffffff)
        
        //用于动态改变点赞、评论数
        totalPraise = Int.init(model.praiseCount)
        totalCommit = Int.init(model.commentCount)
        usrUid = model.uid
        id_moment = model.momentID
        id_topic = model.topicId
        
        var sex : String!
        if model.sex == "1" {
            sex = "60Boy"
        }else if model.sex == "0"{
            sex = "60Girl"
        }
        //头像
        HeadImageView.sd_setImage(with: URL.init(string: model.headImageUrl), placeholderImage: UIImage.init(named: sex))
        let newTime = compareTime(givenTime: Double.init(model.time)!)
        //姓名 + 学校 + 时间
        UsrInfoLabel.attributedText = createUsrInfoAttr(name: model.name, school: model.school, time: newTime)
        
        if exitGray == 0 {
            //发布的图片
            
            clearView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 60)
            
            if model.contentImageUrl == "empty" {
                //动态图片不存在
                ContentImage.image = nil
                ContentImage.frame = CGRect.init(x: 0, y: 60, width: ScreenWidth, height: 0)
                let imageY = self.ContentImage.frame.maxY
                self.changeSize(imageY: imageY - 15.5, model: model)
            }else{
                //动态图片存在
                
                ContentImage.sd_setImage(with: URL.init(string: model.contentImageUrl), placeholderImage: nil, options: SDWebImageOptions.cacheMemoryOnly, completed: { (image : UIImage?, error : Error?, cacheType : SDImageCacheType, url : URL?) in
                    
                })
                
                self.ContentImage.frame = CGRect.init(x: 0, y: 60, width: ScreenWidth, height: ScreenWidth * 200 / 375)
                let imageY = self.ContentImage.frame.maxY
                self.changeSize(imageY: imageY, model: model)
                
            }
        }else if exitGray == 1{
            let grayView : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 12))
            grayView.backgroundColor = ColorMethodho(hexValue: 0xe6e6e6)
            self.contentView.addSubview(grayView)
            
            clearView.frame = CGRect.init(x: 0, y: 12, width: ScreenWidth, height: 60)
            
            //发布的图片
            if model.contentImageUrl == "empty" {
                //动态图片不存在
                ContentImage.image = nil
                ContentImage.frame = CGRect.init(x: 0, y: 60 + 12, width: ScreenWidth, height: 0)
                let imageY = self.ContentImage.frame.maxY
                self.changeSize(imageY: imageY - 15.5, model: model)
            }else{
                //动态图片存在
                
                ContentImage.sd_setImage(with: URL.init(string: model.contentImageUrl), placeholderImage: nil, options: SDWebImageOptions.cacheMemoryOnly, completed: { (image : UIImage?, error : Error?, cacheType : SDImageCacheType, url : URL?) in
                    
                })
                
                self.ContentImage.frame = CGRect.init(x: 0, y: 60 + 12, width: ScreenWidth, height: ScreenWidth * 200 / 375)
                let imageY = self.ContentImage.frame.maxY
                self.changeSize(imageY: imageY, model: model)
                
            }
        }
    }
    
    func changeSize(imageY : CGFloat,model : TopicDetailModel) { //修改其它控件位置
        
        topicLabel.text = model.topic
        
        if model.topic == "deleted" {
            topicLabel.frame = CGRect.init(x: 15, y: imageY + 7, width: ScreenWidth - 30, height: 0)
        }else{
            topicLabel.frame = CGRect.init(x: 15, y: imageY + 15.5, width: ScreenWidth - 30, height: 13)
        }
        
        if contentHide == 1 {
            //动态内容自动展开
            contentLabel.attrStr = model.contentTitle
//            contentLabel.attributedText = createContentAttr(title: model.contentTitle)
            contentLabel.sizeToFit()
            let heightFitted : CGFloat = contentLabel.frame.height
            contentLabel.frame = CGRect.init(x: 15, y: topicLabel.frame.maxY + 6.5, width: ScreenWidth - 30, height: heightFitted)
            
            checkTotalLabel.frame = CGRect.init(x: 15, y: contentLabel.frame.maxY - 5.5, width: 50, height: 0)
            if model.contentTitle == " " {
                dashView.frame = CGRect.init(x: 15, y: checkTotalLabel.frame.maxY + 2, width: ScreenWidth - 15, height: 0.5)
            }else if heightFitted < 23{
                dashView.frame = CGRect.init(x: 15, y: checkTotalLabel.frame.maxY + 14, width: ScreenWidth - 15, height: 0.5)
            }else{
                dashView.frame = CGRect.init(x: 15, y: checkTotalLabel.frame.maxY + 18.5, width: ScreenWidth - 15, height: 0.5)
            }
            
        }else{
            //动态内容不自动展开
            let maxIndex : Int = Int(makeMaxNumIn(title: model.contentTitle, labelWidth: ScreenWidth - 30))
            let cuttedStr : String = cutString(title: model.contentTitle, atIndex: 0, beforeIndex: maxIndex)
//            print(cuttedStr)
            contentLabel.attrStr = cuttedStr

//            contentLabel.attributedText = createContentAttr(title: cuttedStr)
            contentLabel.sizeToFit()
            let heightFitted : CGFloat = contentLabel.frame.height
            contentLabel.frame = CGRect.init(x: 15, y: topicLabel.frame.maxY + 6.5, width: ScreenWidth - 30, height: heightFitted)
            
            if newLineNum < 3 {
                
                checkTotalLabel.frame = CGRect.init(x: 15, y: contentLabel.frame.maxY - 5.5, width: 50, height: 0)
                
                if newLineNum == 1 {
                    
                    if cuttedStr == " " {
                        dashView.frame = CGRect.init(x: 15, y: checkTotalLabel.frame.maxY - 2.5, width: ScreenWidth - 15, height: 0.5)
                    }else{
                        dashView.frame = CGRect.init(x: 15, y: checkTotalLabel.frame.maxY + 14, width: ScreenWidth - 15, height: 0.5)
                    }
                }else{
                    dashView.frame = CGRect.init(x: 15, y: checkTotalLabel.frame.maxY + 18.5, width: ScreenWidth - 15, height: 0.5)
                }
                
//                if cuttedStr == " " {
//                    dashView.frame = CGRect.init(x: 15, y: checkTotalLabel.frame.maxY - 2.5, width: ScreenWidth - 15, height: 0.5)
//                }else{
//                    dashView.frame = CGRect.init(x: 15, y: checkTotalLabel.frame.maxY + 9, width: ScreenWidth - 15, height: 0.5)
//                }
            }else{
                checkTotalLabel.frame = CGRect.init(x: 15, y: contentLabel.frame.maxY + 9, width: 50, height: 10)
                dashView.frame = CGRect.init(x: 15, y: checkTotalLabel.frame.maxY + 14.5, width: ScreenWidth - 15, height: 0.5)
            }
        }
        
        praiseImage.frame = CGRect.init(x: 15, y: dashView.frame.maxY + 15, width: 21, height: 20)
        if model.praise == "1" {
            praiseImage.image = #imageLiteral(resourceName: "4240Praise.png")
        }else if model.praise == "0"{
            praiseImage.image = #imageLiteral(resourceName: "4240UnPraise.png")
        }
        
        commitImage.frame = CGRect.init(x: 56, y: praiseImage.frame.minY, width: 21, height: 20)
        CountLabel.frame = CGRect.init(x: 80, y: dashView.frame.maxY, width: ScreenWidth - 80 - 15, height: 50)
        CountLabel.attributedText = createCountAttr(praiseCount: model.praiseCount, commitCount: model.commentCount)

        delegate?.changCellHeight?(height: CountLabel.frame.maxY, momentId: model.momentID)
    }
    
    //MARK:-----PubMethod-----
    public func getCellHeight() -> String{
        let cellHeightStr : String = NSNumber.init(value: Float.init(CountLabel.frame.maxY)).stringValue
        
        return cellHeightStr
    }
    
    //MARK:-----TapMethod-----
    func headTapMethod(sender : UITapGestureRecognizer) {
        let position_x : CGFloat = sender.location(in: clearView).x
        if position_x < 150 {
            print("jumptoCenter")
            
            delegate?.jumoToCenter!(Usr: usrUid)
            
        }else if position_x > ScreenWidth - 47{
            print("deleteAction")
            
            let account = SWCUserAccount.sharedUserInfoManager()!
            let locUid = account.getUid()
            
//            let locUid : String = "2"
            
            if locUid == usrUid {
                delegate?.changeMineMoment?(mine: true,mid: id_moment)
            }else{
                delegate?.changeMineMoment?(mine: false,mid: id_moment)
            }
        }
        
    }
    
    func topicLabelTapMethod() {
        print("topic")
        delegate?.tapTopicTitle?(tid : id_topic)
    }
    
    func praiseTapMethod() {
        print("praise")
        if praiseImage.image == #imageLiteral(resourceName: "4240UnPraise.png") {
            totalPraise = totalPraise + 1
            praiseImage.image = #imageLiteral(resourceName: "4240Praise.png")
            CountLabel.attributedText = createCountAttr(praiseCount: NSNumber.init(value: totalPraise).stringValue, commitCount: NSNumber.init(value: totalCommit).stringValue)
            
            delegate?.praiseTo!(Usr: usrUid,moment: id_moment)
        }
    }
    
    func commitTapMethod() {
        print("commit")
//        delegate?.commentMoment!(momentid: id_moment)
        delegate?.commentMoment!(momentid: id_moment, index: usrUid)
    }
    
    func checkTotalTapMethod() {
        print("showall")
    }
    
    //MARK:-----AttrMethod-----
    func createUsrInfoAttr(name : String,school : String,time : String) -> NSMutableAttributedString {
        let title = name + "\n" + school + time
        let usrAttr = NSMutableAttributedString.init(string: title)
        
        let space = [NSKernAttributeName : NSNumber.init(value: 7.5)];
        
        let para = NSMutableParagraphStyle .default.mutableCopy() as! NSMutableParagraphStyle
        para.alignment = NSTextAlignment.left
        para.paragraphSpacing = 2.5
        let para_dic = [NSParagraphStyleAttributeName : para];
        
        usrAttr.addAttributes(font_13_global, range: NSRange.init(location: 0, length: name.characters.count))
        usrAttr.addAttributes(color_66_global, range: NSRange.init(location: 0, length: name.characters.count))
        usrAttr.addAttributes(font_09_global, range: NSRange.init(location: name.characters.count + 1, length: school.characters.count + time.characters.count))
        usrAttr.addAttributes(color_b2_global, range: NSRange.init(location: name.characters.count + 1, length: school.characters.count + time.characters.count))
        usrAttr.addAttributes(space, range: NSRange.init(location: name.characters.count + school.characters.count, length: 1))
        usrAttr.addAttributes(para_dic, range: NSRange.init(location: 0, length: title.characters.count))
        
        return usrAttr
    }
    
    func createContentAttr(title : String) -> NSMutableAttributedString {
        let contentAttr = NSMutableAttributedString.init(string: title)
        
        let para = NSMutableParagraphStyle .default.mutableCopy() as! NSMutableParagraphStyle
        para.alignment = NSTextAlignment.left
        para.lineSpacing = 4.5
        para.paragraphSpacing = 0
        let para_dic = [NSParagraphStyleAttributeName : para];
        
        contentAttr.addAttributes(font_13_global, range: NSRange.init(location: 0, length: title.characters.count))
        contentAttr.addAttributes(color_33_global, range: NSRange.init(location: 0, length: title.characters.count))
        contentAttr.addAttributes(para_dic, range: NSRange.init(location: 0, length: title.characters.count))
        
        return contentAttr
    }
    
    func createCountAttr(praiseCount : String,commitCount : String) -> NSMutableAttributedString {
        let title = "赞赏 " + praiseCount + " · " + "评论 " + commitCount
        let countAttr = NSMutableAttributedString.init(string: title)
        
        countAttr.addAttributes(font_10_global, range: NSRange.init(location: 0, length: title.characters.count))
        countAttr.addAttributes(color_b2_global, range: NSRange.init(location: 0, length: title.characters.count))
        
        return countAttr
    }
    
    //MARK:-----StringCutMethod-----
    func makeMaxNumIn(title : String,labelWidth : CGFloat) -> NSNumber {
        var maxNum = NSNumber.init(value: 0)
        var teLabel : UILabel!
        
        for index in 0..<title.characters.count {
            let cuttedString = cutString(title: title, atIndex: 0, beforeIndex: index + 1)
            teLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: labelWidth, height: 10))
            teLabel.numberOfLines = 0
            teLabel.attributedText = teLabelAttr(title: cuttedString)
            teLabel.sizeToFit()
            let height = teLabel.frame.height
            
            if height < 23 {
                newLineNum = 1
            }else if height < 40{
                newLineNum = 2
            }else{
                newLineNum = 3
                maxNum = NSNumber.init(value: index)
                break
            }
        }
        
        if newLineNum < 3 {
            return NSNumber.init(value: title.characters.count)
        }
        
        return maxNum
    }
    
    func teLabelAttr(title : String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString.init(string: title)
        
        let para = NSMutableParagraphStyle .default.mutableCopy() as! NSMutableParagraphStyle
        para.alignment = NSTextAlignment.left
        para.lineSpacing = 4.5
        para.paragraphSpacing = 0
        let para_dic = [NSParagraphStyleAttributeName : para];
        
        attr.addAttributes(font_13_global, range: NSRange.init(location: 0, length: title.characters.count))
        attr.addAttributes(para_dic, range: NSRange.init(location: 0, length: title.characters.count))
        
        return attr
    }

}
