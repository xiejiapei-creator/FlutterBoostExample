//
//  ViewController.swift
//  BoostTestIOS
//
//  Created by 谢佳培 on 2023/1/31.
//

import UIKit
import flutter_boost

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BoostDelegate.shared.navigationController = self.navigationController
    }

    /// 跳转到 Flutter 页面
    @IBAction func gotoFlutterPage(_ sender: UIButton) {
        let options = FlutterBoostRouteOptions()
        options.pageName = "mainPage"
        options.arguments = ["data": "嗟乎！时运不齐，命途多舛。冯唐易老，李广难封。屈贾谊于长沙，非无圣主；窜梁鸿于海曲，岂乏明时？所赖君子见机，达人知命。老当益壮，宁移白首之心？穷且益坚，不坠青云之志。酌贪泉而觉爽，处涸辙以犹欢。北海虽赊，扶摇可接；东隅已逝，桑榆非晚。孟尝高洁，空余报国之情；阮籍猖狂，岂效穷途之哭！"]
        options.opaque = true
        
        options.completion = { completion in
            print("打开 Flutter 页面的操作完成")
        }

        options.onPageFinished = { dict in
            print("Flutter 页面关闭返回到原生页面时，参数值：\(String(describing: dict))")
        }
        
        FlutterBoost.instance().open(options)
    }
}


