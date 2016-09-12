//
//  Checklist.m
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "Checklist.h"
#import "ChecklistItem.h"

@interface Checklist () <NSCoding>

@end

@implementation Checklist

- (instancetype)init {
    return [self initWithName:@""];
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name iconName:@"No Icon"];
}

- (instancetype)initWithName:(NSString *)name iconName:(NSString *)iconName {
    if (self = [super init]) {
        _name = name.copy;
        _iconName = iconName.copy;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"Name"];
        _iconName = [aDecoder decodeObjectForKey:@"IconName"];
        _items = [aDecoder decodeObjectForKey:@"Items"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"Name"];
    [aCoder encodeObject:_iconName forKey:@"IconName"];
    [aCoder encodeObject:_items forKey:@"Items"];
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSInteger)countUncheckedItems {
    NSInteger count = 0;
    for (ChecklistItem *item in _items) {
        if (!item.checked) {
            count += 1;
        }
    }
    return count;
}


@end
