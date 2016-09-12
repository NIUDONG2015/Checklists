//
//  AllListsViewController.m
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "AllListsViewController.h"
#import "DataModel.h"
#import "Checklist.h"
#import "ListDetailViewController.h"
#import "ChecklistViewController.h"

@interface AllListsViewController () <UINavigationControllerDelegate, ListDetailViewControllerDelegate>

@end

static NSString *cellIdentifier = @"cell";
@implementation AllListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    NSInteger index = self.dataModel.indexOfSelectedChecklist;
    if (index >= 0 && index < _dataModel.lists.count) {
        Checklist *checklist = _dataModel.lists[index];
        [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellForTableView:tableView];
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    cell.textLabel.text = checklist.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    NSInteger count = [checklist countUncheckedItems];
    if (checklist.items.count == 0) {
        cell.detailTextLabel.text = @"(No Items)";
    }else if (count == 0) {
        cell.detailTextLabel.text = @"All Done!";
    }else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld Remaining", count];
    }
    
    cell.imageView.image = [UIImage imageNamed:checklist.iconName];
    
    return cell;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.dataModel.indexOfSelectedChecklist = indexPath.row;
    
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    [self performSegueWithIdentifier:@"ShowChecklist" sender:checklist];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailNavigationController"];
    ListDetailViewController *listDetailVC = (ListDetailViewController *)nav.topViewController;
    listDetailVC.delegate = self;
    listDetailVC.checklistToEdit = self.dataModel.lists[indexPath.row];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowChecklist"]) {
        
        ChecklistViewController *checklistVC = segue.destinationViewController;
        checklistVC.checklist = sender;
        
    } else if ([segue.identifier isEqualToString:@"AddChecklist"]) {
        UINavigationController *nav = segue.destinationViewController;
        ListDetailViewController *listDetailVC = (ListDetailViewController *)nav.topViewController;
        listDetailVC.delegate = self;
        listDetailVC.checklistToEdit = nil;
    }
}

- (void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist {
    [self.dataModel.lists addObject:checklist];
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist {
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[self class]]) {
        self.dataModel.indexOfSelectedChecklist = -1;
    }
}

@end
