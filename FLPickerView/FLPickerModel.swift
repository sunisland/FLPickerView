//
//  FLRPickerModel.swift
//  FindLove
//
//  Created by 陈春林 on 2018/12/13.
//  Copyright © 2018年 CC. All rights reserved.
//

import UIKit

struct FLPickerItem {
    var section = 0
    var row = 0;
    var str = ""
    
    init(section : Int, row : Int, str : String) {
        self.section = section
        self.row =  row
        self.str = str
    }
}

class FLPickerModel: NSObject {
    typealias FLPickSelect = ([FLPickerItem]) -> ()
    typealias FLPickCancel = () -> ()

// 配置
    
    // bar
    var leftTitle : String = "取消"
    var rightTitle : String = "确认"
    var title : String?
    var leftTextColor : UIColor = UIColor.black
    var titleColor : UIColor = UIColor.black
    var rightTextColor : UIColor = UIColor.black
    
    var leftDisableColor : UIColor?
    var rightDisableColor : UIColor?

    var barBgColor = UIColor.white
    var pickBgColor : UIColor = UIColor.white // 背景, 不包括bar
    
    var leftMargin : CGFloat = 0
    var pickerH : CGFloat = 216 // 总高度
    var pickerBarH : CGFloat = 44
    
    var totalH : CGFloat  {
       return self.pickerBarH + self.pickerH
    }
    
    
   
    var selectIndex : Int = 0
// 数据
    var dataArray : Array<FLPickerSecionModel> = Array()
// 回调
    var done : FLPickSelect?
    var cancel : FLPickCancel?
    
    
    class func select(title : String?, data:Array<FLPickerSecionModel>, selIndex : Int = 0, done : FLPickSelect? , cancel : FLPickCancel?) -> (FLPickerModel){
        
        return FLPickerModel(title: title, data: data, done: done, cancel : cancel)
    }
    
    
    init(title : String?, data: Array<FLPickerSecionModel>, selIndex : Int = 0, done : FLPickSelect? , cancel: FLPickCancel?) {
        super.init()
        self.title = title
        self.selectIndex = selIndex;
        self.done = done
        dataArray = data
        self.cancel = cancel
    }
    
}


class FLPickerSecionModel : NSObject{
    var cellModels = Array<String>()

    init(ary : Array<String>){
        super.init()
        cellModels = ary
    }
}


