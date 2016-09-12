//
//  ListDetailViewController.h
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListDetailViewController, Checklist;
@protocol ListDetailViewControllerDelegate <NSObject>

- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist;

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist;

@end

@interface ListDetailViewController : UITableViewController

@property (nonatomic, weak) id <ListDetailViewControllerDelegate>delegate;

@property (nonatomic, strong) Checklist *checklistToEdit;

@end
