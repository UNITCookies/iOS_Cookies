//
//  WriteView.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

final class WriteView: UIView {
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var messageTextField: UITextView!
    @IBOutlet private weak var seeDetailCookieImageView: UIImageView!
    
    public var message: String {
        self.messageTextField.text
    }
    
    static func loadView() -> WriteView {
        return Bundle.main.loadNibNamed(WriteView.className,
                                        owner: self,
                                        options: nil)?.first as! WriteView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageTextField.backgroundColor = .white
        seeDetailCookieImageView.isHidden = true
    }
    
    public func isRead(name: String, content: String, enableCount: Int) {
        self.seeDetailCookieImageView.isHidden = false
        self.messageTextField.isEditable = false
        self.nameLabel.text = "\(name)님이 남긴 쿠키"
        self.messageTextField.text = content
        
        switch enableCount {
        case 4:
            self.descriptionLabel.text = "축하해요! 첫번째 줍줍입니다!"
        case 3:
            self.descriptionLabel.text = "이미 누가 한입 먹고 간 쿠키네요!"
        case 2:
            self.descriptionLabel.text = "반쪼가리 쿠키라도 사랑해주실거죠..?"
        case 1:
            self.descriptionLabel.text = "마지막 쿠키 조각이에요! 찾아줘서 고마워요:)"
        default:
            self.descriptionLabel.text = "이미 누가 한입 먹고 간 쿠키네요!"
        }
    }
}
