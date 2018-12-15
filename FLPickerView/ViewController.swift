//
//  ViewController.swift
//  FLPickerView
//
//  Created by fuzamei on 2018/12/15.
//  Copyright © 2018年 CC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       view.addSubview(rightBtn)
        view.addSubview(titleLab)
        
        titleLab.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        rightBtn.frame = CGRect(x: 100, y: 150, width: 100, height: 40)
        
    }


    
    private lazy var rightBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("选择男女", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor =  UIColor.lightGray
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(doneAction), for: .touchUpInside) //
        return btn
    }()
    
    private lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.black
        lab.textAlignment = .center
        lab.backgroundColor = UIColor.lightGray
        return lab
    }()
    
    
    @objc func doneAction() {
        let model = FLPickerModel.init(title: nil, data: [FLPickerSecionModel(ary: ["男", "女"])], done: { [weak self] (items) in
            let item = items[0]
            self?.titleLab.text = item.str
        }, cancel: nil)
        FLPickerManager.manager().pickerModel(model: model).showToWindow()
    }
}

