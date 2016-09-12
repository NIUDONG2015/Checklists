//
//  ItemDetailViewController.h
//  CheckLists
//
//  Created by HNF's wife on 16/9/12.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController, ChecklistItem;
@protocol ItemDetailViewControllerDelegate <NSObject>

- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller;

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item;

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item;

@end

@interface ItemDetailViewController : UITableViewController

@property (nonatomic, strong) id <ItemDetailViewControllerDelegate>delegate;

@property (nonatomic, strong) ChecklistItem *itemToEdit;

@end
