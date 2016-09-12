//
//  IconPickerViewController.m
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "IconPickerViewController.h"

@interface IconPickerViewController ()

@property (nonatomic, strong) NSArray *icons;

@end

@implementation IconPickerViewController

- (NSArray *)icons {
    if (!_icons) {
        _icons =  @[@"No Icon",
                    @"Appointments",
                    @"Birthdays",
                    @"Chores",
                    @"Drinks",
                    @"Folder",
                    @"Groceries",
                    @"Inbox",
                    @"Photos",
                    @"Trips"];
    }
    return _icons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.icons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.icons[indexPath.row]];
    cell.textLabel.text = self.icons[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(iconPickerViewController:didPickIcon:)]) {
        [self.delegate iconPickerViewController:self didPickIcon:self.icons[indexPath.row]];
    }
}

@end
