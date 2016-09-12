//
//  ChecklistItem.m
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "ChecklistItem.h"
#import "DataModel.h"

@interface ChecklistItem () <NSCoding>

@property (nonatomic, assign) NSInteger itemID;

@end

@implementation ChecklistItem

- (instancetype)init {
    if (self = [super init]) {
        _itemID = [DataModel nextChecklistItemID];
        _text = @"";
        _checked = NO;
        _dueDate = [NSDate new];
        _shouldRemind = NO;
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _text = [aDecoder decodeObjectForKey:@"Text"];
        _checked = [aDecoder decodeBoolForKey:@"Checked"];
        _dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        _shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        _itemID = [aDecoder decodeIntegerForKey:@"ItemID"];
    }
    return self; 
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_text forKey:@"Text"];
    [aCoder encodeBool:_checked forKey:@"Checked"];
    [aCoder encodeObject:_dueDate forKey:@"DueDate"];
    [aCoder encodeBool:_shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:_itemID forKey:@"ItemID"];
}

- (UILocalNotification *)notificationForThisItem {
    NSArray *notifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in notifications) {
        NSInteger itemID = (NSInteger)notification.userInfo[@"ItemID"];
        if (itemID == self.itemID) {
            return notification;
        }
    }
    return nil;
}

- (void)dealloc {
    if ([self notificationForThisItem]) {
        [[UIApplication sharedApplication] cancelLocalNotification:[self notificationForThisItem]];
    }
}

#pragma mark - public method

- (void)toggleChecked {
    self.checked = !_checked;
}

- (void)scheduleNotification {
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification) {
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
    
    if (_shouldRemind && [_dueDate compare:[NSDate new]] != NSOrderedAscending ) {
        UILocalNotification *notification = [UILocalNotification new];
        notification.fireDate = _dueDate;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = _text;
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.userInfo = @{@"ItemID": @(_itemID)};
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


@end
