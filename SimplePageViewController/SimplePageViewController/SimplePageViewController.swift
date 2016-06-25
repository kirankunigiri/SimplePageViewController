//
//  SimplePageViewController.swft
//  SimplePageViewController
//
//  Created by Kiran Kunigiri on 6/25/16.
//  Credit to the clean and organized DataSource guards goes to
//  https://spin.atomicobject.com/2015/12/23/swift-uipageviewcontroller-tutorial/
//

import UIKit

/**
 *  Must conform to the function `getViewControllerList()`
 */
@objc protocol SimplePageViewControllerDataSource {
    /** Returns the list of view controllers to be displayed in the UIPageViewController */
    func getViewControllerList() -> [UIViewController]
}

class SimplePageViewController: UIViewController {
    
    // Data source elements
    /** Conform to this dataSource to provide the class the objects it needs */
    var dataSource: SimplePageViewControllerDataSource?
    /** The list of view controllers to be displayed in the UIPageViewController */
    var viewControllerList: [UIViewController]!
    
    // Other elements
    /** The UIPageViewController used to display pages. Edit it's properties to customize your View Controller */
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup page control appearance
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGrayColor()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.blackColor()
        
        // Set the vc list to the dataSource list
        self.viewControllerList = self.dataSource?.getViewControllerList()
        
        // Create a new Page View Controller
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.dataSource = self
        
        // Set the first view to the Page View Controller
        self.pageViewController.setViewControllers([self.viewControllerList[0]], direction: .Forward, animated: true, completion: nil)
        
        // Add and setup the Page View Controller view to the main view
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.view.sendSubviewToBack(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
}

extension SimplePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.viewControllerList!.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard self.viewControllerList.count > previousIndex else {
            return nil
        }
        
        return self.viewControllerList[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.viewControllerList!.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = self.viewControllerList!.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return self.viewControllerList![nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.viewControllerList.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}