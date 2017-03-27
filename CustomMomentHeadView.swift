

import UIKit

@objc(MomentListHeadViewDelegate)
protocol MomentListHeadViewDelegate {
    func fitInsetTop(height : CGFloat)
    func pickTapped(newHeight : CGFloat,isUp : Bool)
    func chosenViewTapAt(index : Int)
}

public class MomentListHeadView: UIView,chosenViewTapDelegate {

    override init(frame: CGRect){
        super.init(frame: frame)
        initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var topicListCellModel : TopicListDetaiModel{
        get{
            return self.topicListCellModel
        }
        set(cellmodel){
            self.changeListUI(cellModel: cellmodel)
        }
    }
    var topicImage : UIImageView!
    var topicLabel : UILabel!
    var topicContentLabel : UILabel!
    var pickUpBgView : UIView!
    var pickUpImage : UIImageView!
    var seLine : CALayer!
    var newLineCount : Int!
    var chosenView : MomentListChosenView!
    var delegate : MomentListHeadViewDelegate! = nil
    var topicContent :  String!
    var pickUpTapState : Int!
    var cuttedStr : String!
    var fittedHeight : CGFloat!
    var fittedY : CGFloat!
    
    func initUI() {
        self.backgroundColor = ColorMethodho(hexValue: 0xffffff)
        newLineCount = 0
        pickUpTapState = 0
        
        topicImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth * 175 / 375))
        topicImage.clipsToBounds = true
        topicImage.contentMode = UIViewContentMode.scaleAspectFill
        topicImage.backgroundColor = ColorMethodho(hexValue: 0xe6e6e6)
        topicImage.isUserInteractionEnabled = false;
        self.addSubview(topicImage)
        
        topicLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: ScreenWidth - 30, height: 20))
        topicLabel.numberOfLines = 0
        topicLabel.shadowColor = UIColor.init(colorLiteralRed: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.35)

        self.addSubview(topicLabel)
        
        topicContentLabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: ScreenWidth - 30, height: 70))
        topicContentLabel.numberOfLines = 0
        self.addSubview(topicContentLabel)
        
        pickUpBgView = UIView.init(frame: CGRect.init(x: 0, y: ScreenWidth * 175 / 375, width: ScreenWidth, height: 45))
        pickUpBgView.backgroundColor = ColorMethodho(hexValue: 0xffffff).withAlphaComponent(1.0)
        let pickUp = UITapGestureRecognizer.init(target: self, action: #selector(pickUpTagMethod(sender:)))
        pickUpBgView.addGestureRecognizer(pickUp)
        self.addSubview(pickUpBgView)
        
        pickUpImage = UIImageView.init(frame: CGRect.init(x: (ScreenWidth - 15)/2, y: 20, width: 15, height: 8))
        pickUpImage.image = #imageLiteral(resourceName: "3016expand.png")
        pickUpImage.isHidden = true
        pickUpBgView.addSubview(pickUpImage)
        
        seLine = CALayer.init()
        seLine.frame = CGRect.init(x: 0, y: 44.5, width: ScreenWidth, height: 0.5)
        seLine.backgroundColor = ColorMethodho(hexValue: 0xe6e6e6).cgColor
        pickUpBgView.layer.addSublayer(seLine)
        
        chosenView = MomentListChosenView.init(frame: CGRect.init(x: 0, y: ScreenWidth * 175 / 375 + 45, width: ScreenWidth, height: 45.5))
        chosenView.delegate = self
//        chosenView.isHidden = true
        self.addSubview(chosenView)
    }
    
    func changeListUI(cellModel : TopicListDetaiModel) {
        
        topicContent = cellModel.TopicTitle
        
        if cellModel.ImageUrl != "emptyUrl" {
            
//            cellModel.TopicTitle = "测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度测试长度"
            
            topicImage.isHidden = false
            topicLabel.isHidden = false
            topicContentLabel.isHidden = false
            pickUpBgView.isHidden = false
            
            topicImage.sd_setImage(with: URL.init(string: cellModel.ImageUrl), placeholderImage: nil, options: SDWebImageOptions.cacheMemoryOnly) { (image : UIImage?, error : Error?, cacheType : SDImageCacheType, url : URL?) in
//                let height : CGFloat = (image?.size.height)!
//                let width : CGFloat = (image?.size.width)!
//                let newHeight : CGFloat = ScreenWidth * height / width
            }
                self.topicImage.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth * 175 / 375)
                
                let imageY = self.topicImage.frame.maxY
                
                self.topicLabel.attributedText = self.createTopicAttr(topic: cellModel.topic, count: cellModel.praiseCount)
                self.topicLabel.sizeToFit()
                self.topicLabel.center = self.topicImage.center
                
                let feedLine : Int = Int(self.makeMaxNumIn(title: cellModel.TopicTitle, labelWidth: ScreenWidth - 30))
                self.cuttedStr = cutString(title: cellModel.TopicTitle, atIndex: 0, beforeIndex: feedLine)
                
                self.topicContentLabel.attributedText = self.createContentLabelAtrr(content: self.cuttedStr)
                self.topicContentLabel.sizeToFit()
                self.fittedHeight = self.topicContentLabel.frame.height
                self.topicContentLabel.frame = CGRect.init(x: 15, y: imageY + 13.5, width: ScreenWidth - 30, height: self.fittedHeight)
                self.fittedY = self.topicContentLabel.frame.maxY
                
                if self.newLineCount == 5{
                    self.pickUpImage.isHidden = false;
                    self.pickUpBgView.frame = CGRect.init(x: 0, y: self.topicContentLabel.frame.maxY - 2, width: ScreenWidth, height: 38.5)
                    
                }else{
                    self.pickUpImage.isHidden = true;
                    self.pickUpBgView.frame = CGRect.init(x: 0, y: self.topicContentLabel.frame.maxY - 2, width: ScreenWidth, height: 20.5)
                }
                self.seLine.frame = CGRect.init(x: 0, y: self.pickUpBgView.frame.height - 0.5, width: ScreenWidth, height: 0.5)
                self.chosenView.frame = CGRect.init(x: 0, y: self.pickUpBgView.frame.maxY, width: ScreenWidth, height: 45.5)
                self.chosenView.isHidden = false;
                self.delegate.fitInsetTop(height: self.chosenView.frame.maxY)
            

        }else{
            topicImage.isHidden = false
            topicLabel.isHidden = true
            topicContentLabel.isHidden = true
            pickUpBgView.isHidden = true
            chosenView.isHidden = false
            chosenView.frame = CGRect.init(x: 0, y: 64, width: ScreenWidth, height: 45.5)
            delegate.fitInsetTop(height: 64 + 45.5)
        }
}
    
    public func changeChosenViewTag(chosenTag : String){
        chosenView.changeType(type: chosenTag)
    }
    
    func createTopicAttr(topic : String,count : String) -> NSMutableAttributedString {
        let title : String = topic + "\n" + "已有" + count + "人参与"
        let attr = NSMutableAttributedString.init(string: title)
        
        let para = NSMutableParagraphStyle .default.mutableCopy() as! NSMutableParagraphStyle
        para.alignment = NSTextAlignment.center
        para.paragraphSpacing = 7.0
        let para_dic = [NSParagraphStyleAttributeName : para];
        
        attr.addAttributes(font_18_bold_global, range: NSRange.init(location: 0, length: topic.characters.count))
        attr.addAttributes(font_10_bold_global, range: NSRange.init(location: topic.characters.count + 1, length: 5 + count.characters.count))
        attr.addAttributes(color_ff_global, range: NSRange.init(location: 0, length: title.characters.count))
        attr.addAttributes(para_dic, range: NSRange.init(location: 0, length: title.characters.count))
        
        return attr
    }
    func createContentLabelAtrr(content : String) -> NSMutableAttributedString {
        let title : String = content
        let attr = NSMutableAttributedString.init(string: title)
        
        let para = NSMutableParagraphStyle .default.mutableCopy() as! NSMutableParagraphStyle
        para.alignment = NSTextAlignment.left
        para.lineSpacing = 5.0
        para.paragraphSpacing = 3.0
        let para_dic = [NSParagraphStyleAttributeName : para];
        
        attr.addAttributes(font_13_global, range: NSRange.init(location: 0, length: title.characters.count))
        attr.addAttributes(color_80_global, range: NSRange.init(location: 0, length: title.characters.count))
        attr.addAttributes(para_dic, range: NSRange.init(location: 0, length: title.characters.count))
        
        return attr
    }

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
            
            if height < 30 {
                newLineCount = 1
            }else if height > 80 {
                newLineCount = 5
                maxNum = NSNumber.init(value: index)
                break
            }
        }
        
        if newLineCount < 5 {
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
    
    func pickUpTagMethod(sender : UITapGestureRecognizer) {
        let locationX : CGFloat = sender.location(in: pickUpBgView).x
        
        if pickUpImage.isHidden == true {
            print("noAni");
        }else if pickUpImage.isHidden == false{
            if locationX > (ScreenWidth - 50)/2 && locationX < (ScreenWidth + 50)/2 {
                if pickUpTapState == 0 {
                    pickUpTapState = 1
                    let teStr : String = topicContent
                    
                    topicContentLabel.attributedText = createContentLabelAtrr(content: teStr)
                    topicContentLabel.sizeToFit()
                    let totalHeight : CGFloat = topicContentLabel.frame.maxY + 46 + 8 + 30
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.pickUpBgView.frame = CGRect.init(x: 0, y: self.topicContentLabel.frame.maxY, width: ScreenWidth, height: 38.5)
                        self.chosenView.frame = CGRect.init(x: 0, y: self.pickUpBgView.frame.maxY, width: ScreenWidth, height: 45.5)
                    }, completion: { (true) in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.pickUpImage.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI))
                        })
                    })
                    delegate.pickTapped(newHeight: totalHeight, isUp: false)
                    
                }else if pickUpTapState == 1{
                    pickUpTapState = 0
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.pickUpBgView.frame = CGRect.init(x: 0, y: self.fittedY, width: ScreenWidth, height: 38.5)
                        self.chosenView.frame = CGRect.init(x: 0, y: self.pickUpBgView.frame.maxY, width: ScreenWidth, height: 45.5)
                        
                    }, completion: { (true) in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.pickUpImage.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI * 2))
                        })
                        
                        let teStr : String = self.cuttedStr
                        
                        self.topicContentLabel.attributedText = self.createContentLabelAtrr(content: teStr)
                        self.topicContentLabel.sizeToFit()
                    })
                    
                    delegate.pickTapped(newHeight: fittedY + 46 + 8 + 30 , isUp: true)
                }
            }
        }
    }
    
    func DataType(type: Int) {
        delegate.chosenViewTapAt(index: type)
    }
}
