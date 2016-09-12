//
//  ChecklistViewController.h
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Checklist;
@interface ChecklistViewController : UITableViewController

@property (nonatomic, strong) Checklist *checklist;

@end
