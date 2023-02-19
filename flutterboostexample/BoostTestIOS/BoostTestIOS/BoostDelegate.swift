//
//  BoostDelegate.swift
//  BoostTestIOS
//
//  Created by 谢佳培 on 2023/2/1.
//

import UIKit
import flutter_boost

class BoostDelegate: NSObject, FlutterBoostDelegate {
    /// 单例
    public static let shared = BoostDelegate()
    
    /// 用来 push 的导航栏
    var navigationController:UINavigationController?
    
    /// 用来存放 Flutter 页面返回原生页面时所执行的回调闭包
    var resultTable:Dictionary<String,([AnyHashable:Any]?)->Void> = [:]
    
    /// 从 Flutter 页面跳转到 iOS 原生页面
    func pushNativeRoute(_ pageName: String!, arguments: [AnyHashable : Any]!) {
        let isPresent = arguments["isPresent"] as? Bool ?? false
        let isAnimated = arguments["isAnimated"] as? Bool ?? true
        
        let targetViewController = openNativePage(pageName, arguments: arguments)
         
        // 可以用参数来控制跳转方式
        if (isPresent) {
            self.navigationController?.present(targetViewController, animated: isAnimated, completion: nil)
        } else {
            self.navigationController?.pushViewController(targetViewController, animated: isAnimated)
        }
    }
    
    /// 打开原生页面
    /// 根据 pageName 来判断生成哪个 vc
    private func openNativePage(_ pageName: String, arguments: [AnyHashable : Any]) -> UIViewController {
        // 前往我的足迹页面
        if (pageName == "footprint") {
//            let blogId = arguments["blogId"] as? Int ?? 0
//            let footprintVC = FootprintViewController(withBlogId: blogId)
//            return footprintVC
        }
        
        return UIViewController()
    }
    
    /// 从 iOS 原生页面跳转到 Flutter 页面
    func pushFlutterRoute(_ options: FlutterBoostRouteOptions!) {
        let vc = CustomFlutterController()
        vc.configFlutter(name: options.pageName, uniqueId: options.uniqueId, params: options.arguments, opaque: options.opaque)

        let isPresent = (options.arguments?["isPresent"] as? Bool)  ?? false
        let isAnimated = (options.arguments?["isAnimated"] as? Bool) ?? true

        // 对这个页面设置结果
        resultTable[options.pageName] = options.onPageFinished;

        if(isPresent || !options.opaque){
            self.navigationController?.present(vc, animated: isAnimated, completion: nil)
        } else {
            self.navigationController?.pushViewController(vc, animated: isAnimated)
        }
    }
    
    /// 退出页面
    func popRoute(_ options: FlutterBoostRouteOptions!) {
        if let vc = self.navigationController?.presentedViewController as? CustomFlutterController, vc.flutterVC.uniqueIDString() == options.uniqueId {// dismiss
            if vc.modalPresentationStyle == .overFullScreen {// 手动调用
                self.navigationController?.topViewController?.beginAppearanceTransition(true, animated: false)
                vc.dismiss(animated: true) {
                    self.navigationController?.topViewController?.endAppearanceTransition()
                }
            } else {// 正常场景
                vc.dismiss(animated: true, completion: nil)
            }
        } else {// pop
            guard let viewControllers = self.navigationController?.viewControllers else { return }
                
            var containerToRemove: CustomFlutterController?
            for item in viewControllers.reversed() {
                if let container = item as? CustomFlutterController, container.flutterVC.uniqueIDString() == options.uniqueId {
                    containerToRemove = container
                    break
                }
            }
            
            if (containerToRemove == nil) {
                fatalError("uniqueId is wrong!!!")
            }
            
            if self.navigationController?.topViewController == containerToRemove {
                self.navigationController?.popViewController(animated: true)
            } else {
                containerToRemove?.removeFromParent()
            }
        }
        
         if let onPageFinshed = resultTable[options.pageName] {
             onPageFinshed(options.arguments)
             resultTable.removeValue(forKey: options.pageName)
         }
     }
}
