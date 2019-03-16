//
//  DJSContainView.h
//  OpenAndSelectCamra
//
//  Created by 萨缪 on 2019/3/14.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJSAlbumCell.h"
#define ALBUMCELLID @"AlbumCellIdentifier"

@interface DJSContainView : UIView

@property (nonatomic, strong) UICollectionView * collectionView;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>)delegate;

@end
