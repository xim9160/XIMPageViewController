//
//  LayoutDefine.swift
//  HXPageViewController
//
//  Created by xiaofengmin on 2019/10/22.
//  Copyright © 2019 WHX. All rights reserved.
//

import Foundation
import UIKit

//cell layout
public struct HomePageCellConfig {
    //MARK: - MASONARY
    static let base_offset_left = 16.0
    static let base_offset_right = -16.0
    static let label_top = 12.0
    static let label_right_img = -20.0
    static let img_top = 10.0
    static let img_bottom = -10.0
    static let img_height = 72.0
    static let img_width = 112.0
    
    static let headLine_top = 5
    static let headLine_bottom = -10
    
    
    static let sub_text_sep = 11.0
    static let sub_text_bottom = -15
    
    //MARK: - FONT
    static let title_font:CGFloat = 18.0
    static let sub_text_font:CGFloat = 11.0
    
    //MARK: - TABBAR
    static let tabbar_title_font:CGFloat = 15.0
    
    //MARK: - HEIGHT
    static let cell_height:CGFloat = 92.0
    static let cell_height_one_line:CGFloat = 71.5
    static let headLine_height:CGFloat = 152.0
    static let titleLabel_max_height = 45
    
    //MARK: - COLOR
    static let title_color = UIColor.init("333333")
    static let title_default_color = UIColor.init("666666")
    static let sub_color = UIColor.init("bbbbbb")
    static let red_color = UIColor.red
    
    //MARK: - OTHER
    static let title_number_of_line = 2
    static let sub_number_of_line = 1
    
    
    //MARK: - CONFIG LABELS
    static func configTitle(_ titleLabel:UILabel) -> Void {
        titleLabel.font = UIFont.systemFont(ofSize: HomePageCellConfig.title_font)
        titleLabel.numberOfLines = HomePageCellConfig.title_number_of_line
        titleLabel.textColor = HomePageCellConfig.title_color
    }
    
    static func configSubLabels(_ sublabels:UILabel...) {
        for label in sublabels {
            label.font = UIFont.systemFont(ofSize: HomePageCellConfig.sub_text_font)
            label.textColor = HomePageCellConfig.sub_color
            label.numberOfLines = HomePageCellConfig.sub_number_of_line
        }
    }
    
    static func configImage(_ imageView:UIImageView) {
        imageView.layer.cornerRadius = 2
    }
    
    static func height(_ string:String, _ fontsize:CGFloat = title_font, _ width:CGFloat = (UIScreen.main.bounds.width - CGFloat(2 * base_offset_left))) -> CGFloat {
        let rect:CGRect = string.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                              options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue),
                                              attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontsize)],
                                              context: nil)
        
//
//        options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue),
//        context: nil
        
        return rect.height
    }
    
}

public extension UIColor {
    
    /// 十六进制颜色转 UIColor
    convenience init?(_ hex: String) {
        guard let rgbColor = hex.rgbColor else {
            return nil
        }
        self.init(red: rgbColor.red, green: rgbColor.green, blue: rgbColor.blue, alpha: rgbColor.alpha)
    }
    
    /// 0~255 区间的 RGB 值转 UIColor
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
    }
    
    /// UIColor 的十六进制色值
    var hexValue: String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        if a == 1.0 {
            return String(format: "%0.2X%0.2X%0.2X", UInt(r * 255),UInt(g * 255), UInt(b * 255))
        } else {
            return String(format: "%0.2X%0.2X%0.2X%0.2X", UInt(r * 255), UInt(g * 255), UInt(b * 255), UInt(a * 255))
        }
    }
    
    /// UIColor 的 0~255 区间的 RGB 色值
    var rgbValue: String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        
        return "Red:\(UInt(r * 255)), Green:\(UInt(g * 255)), Blue:\(UInt(b * 255)), Alpha:\(UInt(a * 255))"
    }
}

private extension String {
    private var pureHexColor: String {
        return trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
    }
    
    struct RGBColor {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat
    }
    
    var rgbColor: RGBColor? {
        if pureHexColor.count == 6 {
            return pureHexColor.rgbColorFrom6Hex()
        } else if pureHexColor.count == 8 {
            return pureHexColor.rgbColorFrom8Hex()
        } else {
            return nil
        }
    }
    
    private func rgbColorFrom6Hex() -> RGBColor? {
        guard let rgb = hexToInt32() else { return nil }
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        return RGBColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    private func rgbColorFrom8Hex() -> RGBColor? {
        guard let rgb = hexToInt32() else { return nil }
        let red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(rgb & 0x000000FF) / 255.0
        return RGBColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private func hexToInt32() -> UInt32? {
        var rgb: UInt32 = 0
        guard Scanner(string: self).scanHexInt32(&rgb) else { return nil }
        return rgb
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
}
