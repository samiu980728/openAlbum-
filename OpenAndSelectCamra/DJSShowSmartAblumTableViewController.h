//
//  DJSShowSmartAblumTableViewController.h
//  OpenAndSelectCamra
//
//  Created by 萨缪 on 2019/3/16.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJSShowSmartAblumTableViewController : UITableViewController

@property (nonatomic, assign) NSInteger albumCount;
@property (nonatomic, strong) NSMutableArray *albumNameArr;
@property (nonatomic, strong) NSMutableArray *albumAssetsArr;
- (instancetype)initWithAlbumCount:(NSInteger)albumCount;

@end
