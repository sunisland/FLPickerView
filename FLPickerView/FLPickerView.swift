//
//  FLPickerView.swift
//  FindLove
//
//  Created by 陈春林 on 2018/12/13.
//  Copyright © 2018年 CC. All rights reserved.
//

import UIKit
import SnapKit




class FLPickerBarView: UIView {
   
    var done : (() -> ())?
    var cancel : (() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadView(model : FLPickerModel) ->(){
        
        leftBtn.setTitle(model.leftTitle, for: .normal)
        if let t = model.title{
            titleLab.text = t
        }
        rightBtn.setTitle(model.rightTitle, for: .normal)
        leftBtn.setTitleColor(model.leftTextColor, for: .normal)
        titleLab.textColor = model.titleColor
        rightBtn.setTitleColor(model.rightTextColor, for: .normal)
        
        if let l = model.leftDisableColor {
            leftBtn.setTitleColor(l, for: .disabled)
        }
        if let r = model.rightDisableColor{
            rightBtn.setTitleColor(r, for: .disabled)
        }
        
        backgroundColor = model.barBgColor
        
    }
    
   private func setupUI() -> () {
        addSubview(leftBtn)
        addSubview(titleLab)
        addSubview(rightBtn)
        
        leftBtn.snp.makeConstraints { (m) in
            m.left.equalTo(self.snp.left).offset(15)
            m.height.equalTo(self.snp.height)
            m.width.equalTo(self.snp.width).multipliedBy(0.25)
            m.top.equalTo(self.snp.top)
        }
        
        titleLab.snp.makeConstraints { (m) in
            m.centerX.equalTo(self.snp.centerX)
            m.height.equalTo(self.snp.height)
            m.width.equalTo(self.snp.width).multipliedBy(0.25)
            m.top.equalTo(self.snp.top)
        }
        
        rightBtn.snp.makeConstraints { (m) in
            m.right.equalTo(self.snp.right).offset(-15)
            m.height.equalTo(self.snp.height)
            m.width.equalTo(self.snp.width).multipliedBy(0.25)
            m.top.equalTo(self.snp.top)
        }
        
    }
    
    
    @objc private func doneAction() {
        guard let done = self.done else {
            return
        }
        done()
        
    }
    
    @objc private func cancelAction() {
        guard let cancel = self.cancel else {
            return
        }
        cancel()
    }
    
    private lazy var leftBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
         btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var rightBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor =  UIColor.white
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(doneAction), for: .touchUpInside) //
        return btn
    }()
    
    
    private lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textColor = UIColor.black
        lab.textAlignment = .right
        return lab
    }()
}



class FLPickerView: UIView {
    
    private var pickerModel : FLPickerModel?
    var done : (([FLPickerItem]) -> ())?
    var cancel : (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    func relaodView(model: FLPickerModel) ->(){
        pickerModel = model
        barView.reloadView(model: model)
        barView.done = {
            
        }
        //取消按钮回调
        barView.cancel = { [weak self] in
            guard let cancel = self?.cancel  else {
               return
            }
            cancel()
        }
        // 确定按钮回调
        barView.done = { [weak self] in
            guard let model = self?.pickerModel else {
                return
            }
            guard let done = self?.done else {
                return
            }
            var  ary = Array<FLPickerItem>()
            for i in 0 ..< model.dataArray.count{
                let row = self?.pickerView.selectedRow(inComponent: i) ?? 0
                let section = model.dataArray[i];
                let str = section.cellModels[row]
                let itme = FLPickerItem(section: i, row: row, str: str)
                ary.append(itme)
            }
            done(ary)
        }
        
        pickerView.backgroundColor = model.pickBgColor
       
        
        barView.snp.makeConstraints { (m) in
            m.height.equalTo(model.pickerBarH)
        }
        
        pickerView.snp.makeConstraints { (m) in
            m.height.equalTo(model.pickerH)
        }
    }
    
    
    private func setupUI() ->(){
        addSubview(barView)
        addSubview(pickerView)
        
        
        
        barView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
        }
        
        pickerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
        }
    }
    
    
    private lazy var barView : FLPickerBarView = FLPickerBarView(frame: CGRect.zero)
    private lazy var pickerView : UIPickerView = {
        let view = UIPickerView()
        view.delegate = self;
        view.dataSource = self;
        return view;
    }()
}

extension FLPickerView : UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let model = pickerModel else {
            return 1
        }
        return model.dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let model = pickerModel else {
            return 1
        }
        let section = model.dataArray[component]
        return section.cellModels.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let model = pickerModel else {
            return ""
        }
        let section = model.dataArray[component]
        return section.cellModels[row]
    }
    
    
    
}
