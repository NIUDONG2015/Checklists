//
//  ChecklistItem.h
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChecklistItem : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) BOOL checked;

@property (nonatomic, strong) NSDate *dueDate;

@property (nonatomic, assign) BOOL shouldRemind;

- (void)toggleChecked;

- (void)scheduleNotification;

@end
