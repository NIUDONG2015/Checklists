//
//  IconPickerViewController.h
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconPickerViewController;
@protocol IconPickerViewControllerDelegate <NSObject>

- (void)iconPickerViewController:(IconPickerViewController *)controller didPickIcon:(NSString *)iconName;

@end

@interface IconPickerViewController : UITableViewController

@property (nonatomic, weak) id <IconPickerViewControllerDelegate>delegate;

@end
