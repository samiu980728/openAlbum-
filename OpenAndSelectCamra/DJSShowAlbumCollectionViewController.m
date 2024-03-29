//
//  DJSShowAlbumCollectionViewController.m
//  OpenAndSelectCamra
//
//  Created by 萨缪 on 2019/3/16.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "DJSShowAlbumCollectionViewController.h"

@interface DJSShowAlbumCollectionViewController ()

@end

@implementation DJSShowAlbumCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    for (UIView * view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [cell addSubview:imageView];
    
    PHImageRequestOptions * imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = NO;//YES 一定是同步    NO不一定是异步
    imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    /*
     PHImageRequestOptionsResizeModeNone // 不调整大小
     PHImageRequestOptionsResizeModeFast // 由系统去安排，情况不定：有时你设置的size比较低，会根据你设的size，有时又会比
     PHImageRequestOptionsResizeModeExact// 保证精确到自定义size ：此处精确的前提得用PHImageContentModeAspectFill
     */
    
    //simageOptions.version = PHImageRequestOptionsVersionCurrent;//版本 iOS8.0之后出的图片编辑extension，可以根据次枚举获取原图或者是经编辑过的图片，
    /*PHImageRequestOptionsVersion：
     PHImageRequestOptionsVersionCurrent = 0, //当前的(编辑过?经过编辑的图：原图)
     PHImageRequestOptionsVersionUnadjusted, //经过编辑的图
     PHImageRequestOptionsVersionOriginal    //原始图片
     */
    
    //    imageOptions.networkAccessAllowed = YES;//用于开启iClould中下载图片
    //    imageOptions.progressHandler   //iClould下载进度的回调
    
    //最高画质
    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    //返回一个 PHImageRequestID
    //在异步请求时可以根据这个ID去取消请求 同步就捏办法了。。。
    [[PHImageManager defaultManager] requestImageForAsset:self.assets[indexPath.row] targetSize:CGSizeMake(120,120) contentMode:PHImageContentModeAspectFit options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        /*
         最终产生图片的size是有   imageOptions.resizeMode（即PHImageRequestOptions） 以及 PHImageContentMode  决定的,当然也有我们设定的size
         优先级而言
         PHImageRequestOptions > PHImageContentMode
         */
        
        //这个handler 并非在主线程上执行，所以如果有UI的更新操作就得手动添加到主线程中
        //       dispatch_async(dispatch_get_main_queue(), ^{ //update UI  });
        imageView.image = result;
    }];
    return cell;
    /*注意这个info字典   有时这个info甚至为null   慎用
     里面的key是比较奇怪的
     尽量不要用里面的key
     因为这个key 会变动： 当我们最终获取到的图片的size的高／宽  没有一个达到能原有的图片size的高／宽时
     部分key 会消失  如 PHImageFileSandboxExtensionTokenKey , PHImageFileURLKey
     */
    
    
    /*
     在PHImageContentModeAspectFill 下  图片size 有一个分水岭  {125,125}   {126,126}
     当imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
     时: 设置size 小于{125,125}时，你得到的图片size 将会是设置的1/2
     
     而在PHImageContentModeAspectFit 分水岭  {120,120}   {121,121}
     */
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
