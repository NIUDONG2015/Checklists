//
//  Checklist.h
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checklist : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, strong) NSMutableArray *items;

- (instancetype)initWithName:(NSString *)name iconName:(NSString *)iconName;

- (instancetype)initWithName:(NSString *)name;

- (NSInteger)countUncheckedItems;

@end
