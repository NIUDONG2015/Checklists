//
//  DataModel.h
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *lists;

@property (nonatomic, assign) NSInteger indexOfSelectedChecklist;


+ (NSInteger)nextChecklistItemID;

- (void)saveChecklists;

- (void)sortChecklists;

@end
