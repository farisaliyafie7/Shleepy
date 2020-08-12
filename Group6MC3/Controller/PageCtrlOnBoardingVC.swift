//
//  PageCtrlOnboardingVC.swift
//  Group6MC3
//
//  Created by Glendito Jeremiah Palendeng on 03/08/20.
//  Copyright © 2020 Faris Ali Yafie. All rights reserved.
//
import UIKit

class PageCtrlOnBoardingVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var orderedVC : [UIViewController] = {
        return [
            self.newVc(viewController: "onboard1"),
            self.newVc(viewController: "onboard2"),
            self.newVc(viewController: "onboard3"),
            self.newVc(viewController: "onboard4")]
    }()
    
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstVc = orderedVC.first {
            setViewControllers([firstVc],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
    }
    
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 200, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedVC.count
        pageControl.currentPage = 0
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
    }
    
    func newVc(viewController: String) -> UIViewController{
        return UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(identifier: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedVC.firstIndex(of: viewController) else{
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else{
//            return orderedVC.last
            return nil
        }
        guard orderedVC.count > previousIndex else{
            return nil
        }
        return orderedVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedVC.index(of: viewController) else{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard orderedVC.count != nextIndex else{
//            return orderedVC.first
            return nil
        }
        guard orderedVC.count > nextIndex else{
            return nil
        }
        return orderedVC[nextIndex]
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentVc = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedVC.index(of: pageContentVc)!
    }
    
}
