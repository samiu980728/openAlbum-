//
//  DJSAlbumCell.m
//  OpenAndSelectCamra
//
//  Created by 萨缪 on 2019/3/14.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "DJSAlbumCell.h"

@implementation DJSAlbumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photoImageView = [[UIImageView alloc] init];
        [self addSubview:self.photoImageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.photoImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

@end
