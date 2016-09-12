//
//  ItemDetailViewController.m
//  CheckLists
//
//  Created by HNF's wife on 16/9/12.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ChecklistItem.h"

@interface ItemDetailViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISwitch *shouldRemindSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, assign) BOOL datePickerVisible;
@property (nonatomic, strong) NSDate *dueDate;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dueDate = [NSDate new];
    _datePickerVisible = false;
    
    if (self.itemToEdit) {
        self.title = @"Edit Item";
        self.textField.text = _itemToEdit.text;
        self.shouldRemindSwitch.on = _itemToEdit.shouldRemind;
        self.doneBarButton.enabled = YES;
        self.dueDate = _itemToEdit.dueDate;
    }
    [self updateDueDateLabel];
}

- (void)updateDueDateLabel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = kCFDateFormatterMediumStyle;
    formatter.timeStyle = kCFDateFormatterShortStyle;
    self.dueDateLabel.text = [formatter stringFromDate:self.dueDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    if (self.itemToEdit) {
        _itemToEdit.text = self.textField.text;
        _itemToEdit.shouldRemind = self.shouldRemindSwitch.on;
        _itemToEdit.dueDate = self.dueDate;
        [_itemToEdit scheduleNotification];
        
        if ([self.delegate respondsToSelector:@selector(itemDetailViewController:didFinishEditingItem:)]) {
            [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
        }
    }else {
        ChecklistItem *item = [[ChecklistItem alloc] init];
        item.text = self.textField.text;
        item.shouldRemind = self.shouldRemindSwitch.on;
        item.dueDate = self.dueDate;
        [item scheduleNotification];
        
        if ([self.delegate respondsToSelector:@selector(itemDetailViewController:didFinishAddingItem:)]) {
            [self.delegate itemDetailViewController:self didFinishAddingItem:item];
        }
    }
    
}

- (IBAction)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(itemDetailViewControllerDidCancel:)]) {
        [self.delegate itemDetailViewControllerDidCancel:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1 && _datePickerVisible) {
        return 3;
    }else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        return self.datePickerCell;
    }else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 217;
    }else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        return indexPath;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.textField resignFirstResponder];
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (!self.datePickerVisible) {
            [self showDatePicker];
        }else {
            [self hideDatePicker];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 2) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    }
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (void)showDatePicker {
    self.datePickerVisible = YES;
    
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:(UITableViewRowAnimationFade)];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:(UITableViewRowAnimationNone)];
    [self.tableView endUpdates];
    
    [self.datePicker setDate:self.dueDate animated:NO];
}

- (void)hideDatePicker {
    if (self.datePickerVisible) {
        self.datePickerVisible = NO;
        
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [[UIColor alloc] initWithWhite:0 alpha:0.5];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:(UITableViewRowAnimationNone)];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:(UITableViewRowAnimationFade)];
        [self.tableView endUpdates];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *oldString = textField.text;
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = newString.length > 0;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self hideDatePicker];
}

- (IBAction)dateChanged:(UIDatePicker *)sender {
    self.dueDate = sender.date;
    [self updateDueDateLabel];
}

- (IBAction)shouldRemindToggled:(UISwitch *)sender {
    [self.textField resignFirstResponder];
    
    if (sender.on) {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}


@end
