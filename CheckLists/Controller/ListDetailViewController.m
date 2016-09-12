//
//  ListDetailViewController.m
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "ListDetailViewController.h"
#import "Checklist.h"
#import "IconPickerViewController.h"

@interface ListDetailViewController () <UITextFieldDelegate, IconPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, copy) NSString *iconName;

@end

@implementation ListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _iconName = @"Folder";
    
    if (_checklistToEdit) {
        self.title = @"Edit Checklist";
        self.doneBarButton.enabled = YES;
        self.textField.text = _checklistToEdit.name;
        self.iconName = _checklistToEdit.iconName;
    }
    self.iconImageView.image = [UIImage imageNamed:_iconName];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(listDetailViewControllerDidCancel:)]) {
        [self.delegate listDetailViewControllerDidCancel:self];
    }
}
- (IBAction)done:(id)sender {
    if (_checklistToEdit) {
        _checklistToEdit.name = self.textField.text;
        _checklistToEdit.iconName = self.iconName;
        if ([self.delegate respondsToSelector:@selector(listDetailViewController:didFinishEditingChecklist:)]) {
            [self.delegate listDetailViewController:self didFinishEditingChecklist:_checklistToEdit];
        }
    }else {
        Checklist *checklist = [[Checklist alloc] initWithName:self.textField.text iconName:self.iconName];
        if ([self.delegate respondsToSelector:@selector(listDetailViewController:didFinishAddingChecklist:)]) {
            [self.delegate listDetailViewController:self didFinishAddingChecklist:checklist];
        }
    }
}

#pragma mark - Table view data source

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return indexPath;
    }else {
        return nil;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *oldText = textField.text;
    NSString *newText = [oldText stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = newText.length > 0;
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

- (void)iconPickerViewController:(IconPickerViewController *)controller didPickIcon:(NSString *)iconName {
    self.iconName = iconName;
    self.iconImageView.image = [UIImage imageNamed:iconName];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
