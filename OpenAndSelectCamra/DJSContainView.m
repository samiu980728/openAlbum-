//
//  DJSContainView.m
//  OpenAndSelectCamra
//
//  Created by 萨缪 on 2019/3/14.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "DJSContainView.h"
#import "DJSAlbumCell.h"

@interface DJSContainView()

@property (nonatomic, weak) id<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> delegate;
@end

@implementation DJSContainView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self setupViews];
    }
    return self;
}

//懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;// 设置同一列中间隔的cell最小间距。
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = _delegate;
        _collectionView.dataSource = _delegate;
        [_collectionView registerClass:[DJSAlbumCell class] forCellWithReuseIdentifier:ALBUMCELLID];
//        [_collectionView registerNib:[UINib nibWithNibName:@"AlbumCell" bundle:nil] forCellWithReuseIdentifier:ALBUMCELLID];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


- (void)setupViews
{
    [self addSubview:self.collectionView];
}

@end
