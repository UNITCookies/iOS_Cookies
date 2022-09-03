//
//  WriteView.swift
//  Cookies
//
//  Created by gabriel.jeong on 2022/09/03.
//

import UIKit

final class WriteView: UIView {
    @IBOutlet private weak var messageTextField: UITextView!
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
        self.messageTextField.layer.cornerRadius = 10.0
    }
}
