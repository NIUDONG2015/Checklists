//
//  ChecklistViewController.m
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "ChecklistViewController.h"
#import "Checklist.h"
#import "ChecklistItem.h"
#import "ItemDetailViewController.h"

@interface ChecklistViewController () <ItemDetailViewControllerDelegate>

@end

@implementation ChecklistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.checklist.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.checklist.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChecklistItem" forIndexPath:indexPath];
    
    ChecklistItem *item = self.checklist.items[indexPath.row];
    
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChecklistItem *item = self.checklist.items[indexPath.row];
    [item toggleChecked];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item {
    UILabel *label = [cell viewWithTag:1001];
    if (item.checked) {
        label.text = @"√";
    }else {
        label.text = @"";
    }
    label.textColor = self.view.tintColor;
}

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item {
    UILabel *label = [cell viewWithTag:1000];
    label.text = item.text;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *nav = segue.destinationViewController;
        ItemDetailViewController *itemDetailVC = (ItemDetailViewController *)nav.topViewController;
        itemDetailVC.delegate = self;
        
    }else if ([segue.identifier isEqualToString:@"EditItem"]) {
        UINavigationController *nav = segue.destinationViewController;
        ItemDetailViewController *itemDetailVC = (ItemDetailViewController *)nav.topViewController;
        itemDetailVC.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        itemDetailVC.itemToEdit = self.checklist.items[indexPath.row];
    }
}

- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.checklist.items.count inSection:0];
    [self.checklist.items addObject:item];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item {
    NSInteger index = [self.checklist.items indexOfObject:item];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [self configureTextForCell:cell withChecklistItem:item];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
