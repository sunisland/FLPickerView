//
//  FLPickerManager.swift
//  FindLove
//
//  Created by 陈春林 on 2018/12/13.
//  Copyright © 2018年 CC. All rights reserved.
//

import UIKit
import SnapKit

class FLPickerManager: NSObject {
    
    private lazy var overlayView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        let tap =  UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var pickerView : FLPickerView?
    private var vm : FLPickerModel?
    
    
    static let instance : FLPickerManager = FLPickerManager()
    class func manager() -> (FLPickerManager){
        return instance
    }
    
    override init() {
        super.init()
    }
    
    func pickerModel(model : FLPickerModel) -> (FLPickerManager){
        vm = model
        pickerView = FLPickerView(frame: CGRect.zero)
        pickerView?.relaodView(model: model)
        pickerView?.cancel = { [weak self] in
            
            guard let cancel = self?.vm?.cancel else {
                self?.dismiss()
                return
            }
            cancel()
            self?.dismiss()
            
        }
        
        pickerView?.done = { [weak self] (items) in
           
            guard let done = self?.vm?.done else {
                self?.dismiss()
                return
            }
            done(items)
            self?.dismiss()
        }
        return self
    }
    
    
    func showToWindow() -> (){
        guard let vm = self.vm else {
            return;
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //        let window = appDelegate?.window
        guard let window = appDelegate?.window else {
            return
        }
        overlayView.addSubview(pickerView!)
        window.addSubview(overlayView)
        overlayView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(window )
        }
        pickerView!.snp.makeConstraints({ (make) in
            make.left.equalTo(self.overlayView.snp.left).offset(vm.leftMargin)
            make.right.equalTo(self.overlayView.snp.right).offset(-vm.leftMargin)
            make.height.equalTo(vm.totalH)
// 视频IiPhoneX, 这里要换成你自己的适配宏
            make.bottom.equalTo(self.overlayView.snp.bottom).offset(-34)
        })
    }
    
    
   @objc func dismiss() -> () {
        overlayView.removeFromSuperview()
        pickerView?.removeFromSuperview()
        vm = nil;
    }
    
}
