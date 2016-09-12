//
//  DataModel.m
//  CheckLists
//
//  Created by HNF's wife on 16/9/11.
//  Copyright © 2016年 huangningfa@163.com. All rights reserved.
//

#import "DataModel.h"
#import "Checklist.h"

@interface DataModel ()

@end

@implementation DataModel

- (instancetype)init {
    if (self = [super init]) {
        [self loadChecklists];
        [self registerDefaults];
        [self handleFirstTime];
    }
    return self;
}

- (void)loadChecklists {
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _lists = [unarchiver decodeObjectForKey:@"Checklists"];
        [unarchiver finishDecoding];
        [self sortChecklists];
    }
}

- (void)saveChecklists {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_lists forKey:@"Checklists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (NSString *)documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)dataFilePath {
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
}

- (void)sortChecklists {
    [_lists sortUsingComparator:^NSComparisonResult(Checklist *obj1, Checklist *obj2) {
        return [obj1.name localizedStandardCompare:obj2.name] != NSOrderedAscending;
    }];
}

- (void)handleFirstTime {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"FirstTime"]) {
        Checklist *checklist = [[Checklist alloc] initWithName:@"List"];
        [self.lists addObject:checklist];
        self.indexOfSelectedChecklist = 0;
        [userDefault setBool:NO forKey:@"FirstTime"];
        [userDefault synchronize];
    }
}

- (NSMutableArray *)lists {
    if (!_lists) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}

- (void)registerDefaults {

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:-1 forKey:@"ChecklistIndex"];
    [userDefault setBool:YES forKey:@"FirstTime"];
    [userDefault setInteger:0 forKey:@"ChecklistItemID"];
    [userDefault synchronize];
}

-(void)setIndexOfSelectedChecklist:(NSInteger)indexOfSelectedChecklist {
    [[NSUserDefaults standardUserDefaults] setInteger:indexOfSelectedChecklist forKey:@"ChecklistIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)indexOfSelectedChecklist {
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"ChecklistIndex"];
    return index;
}

+ (NSInteger)nextChecklistItemID {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger itemID = [userDefault integerForKey:@"ChecklistItemID"];
    [userDefault setInteger:itemID + 1 forKey:@"ChecklistItemID"];
    [userDefault synchronize];
    return itemID;
}

@end
