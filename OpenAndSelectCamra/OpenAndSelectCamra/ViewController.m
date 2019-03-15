//
//  ViewController.m
//  OpenAndSelectCamra
//
//  Created by 萨缪 on 2019/3/11.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "ViewController.h"
#import "DJSAlbumController.h"
#import <Photos/Photos.h>

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) UIButton * selectButton;

@property (nonatomic, strong) UIButton * allPhotosButton;

@property (nonatomic, strong) UINavigationController * navController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(100, 100, 150, 150);
    self.selectButton.backgroundColor = [UIColor redColor];
    [self.selectButton addTarget:self action:@selector(pressSelectAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.selectButton];
    
    self.allPhotosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allPhotosButton.backgroundColor = [UIColor blueColor];
    self.allPhotosButton.frame = CGRectMake(100, 300, 150, 150);
    [self.allPhotosButton setTitle:@"相册全部照片" forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(pressAllPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.allPhotosButton];
    [self.allPhotosButton addTarget:self action:@selector(pressAllPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getAllPhotoAlbumName
{
    NSMutableArray * nameArr = [NSMutableArray array];
    NSMutableArray * assetArr = [NSMutableArray array];
    //获取系统配置的相册信息
    PHFetchResult * smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSLog(@"系统相册是数目 = %ld",smartAlbums.count);
    //遍历UICollectionView
    for (PHAssetCollection * collection in smartAlbums) {
        PHFetchResult * results = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        NSLog(@"相册名:%@，有%ld张图片",collection.localizedTitle,results.count);
        [nameArr addObject:collection.localizedTitle];
        [assetArr addObject:results];
    }
}

- (UINavigationController *)navController
{
    if (!_navController) {
        _navController = [[UINavigationController alloc] init];
        _navController.title = @"123456";
    }
    return _navController;
}

//- (UINavigationController *)setNavController:(UINavigationController *)navController
//{
//    navController = [[UINavigationController alloc] init];
//    navController.title = @"123";
//    return navController;
//}

- (void)pressAllPhotoButton:(UIButton *)button
{
    DJSAlbumController * albumController = [[DJSAlbumController alloc] init];
//    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:albumController];
//    [self.navigationController pushViewController:navController animated:YES];
    [self presentViewController:albumController animated:YES completion:nil];
}

- (void)pressSelectAlbum:(UIButton *)selectButton
{
    //判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    //创建图片选择控制器
    UIImagePickerController * ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    //设置打开照片相册类型（显示所有相薄）
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置代理
    [self presentViewController:ipc animated:YES completion:nil];
    
}

//获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //设置图片
    self.selectButton.imageView.image = info[UIImagePickerControllerOriginalImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
