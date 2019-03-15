//
//  DJSAlbumController.m
//  OpenAndSelectCamra
//
//  Created by 萨缪 on 2019/3/14.
//  Copyright © 2019年 萨缪. All rights reserved.
//

#import "DJSAlbumController.h"
#import "DJSContainView.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface DJSAlbumController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) DJSContainView * containView;

@property (nonatomic, strong) PHImageRequestOptions * options;

//从一个Photos的获取方法中返回的有序的资源或者集合的列表。
@property (nonatomic, strong) PHFetchResult<PHAsset *> *assets;

@end

@implementation DJSAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self getAllPhotosFromAlbum];
#pragma mark - 获取video   这段代码这个VC没有使用
    PHFetchResult<PHAsset *> *assetsResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    PHVideoRequestOptions *options2 = [[PHVideoRequestOptions alloc] init];
    options2.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [options2 setNetworkAccessAllowed:true];
    for (PHAsset *a in assetsResult) {
        [[PHImageManager defaultManager] requestAVAssetForVideo:a options:options2 resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            NSLog(@"%@",info);
            NSLog(@"%@",audioMix);
            NSLog(@"%@",((AVURLAsset*)asset).URL);//asset为AVURLAsset类型  可直接获取相应视频的相对地址
            //            NSString *path = ((AVURLAsset*)asset).URL.path;//
        }];
    }
}

- (void)setupViews
{
    self.view.backgroundColor  = [UIColor whiteColor];
    self.containView = [[DJSContainView alloc] initWithFrame:self.view.bounds delegate:self];
    [self.view addSubview:self.containView];
}

//从系统中捕获所有相片
- (void)getAllPhotosFromAlbum
{
    self.options = [[PHImageRequestOptions alloc] init];//请求选项设置 能够影响通过图片管理器获得的资源的静态图像的一组选项。
    self.options.resizeMode = PHImageRequestOptionsResizeModeExact;//自定义图片大小的加载模式
    //请求的图像质量和交付优先级。 使用这个属性将告诉Photos要快速提供图像（可能牺牲图像质量）、提供高质量图像（可能牺牲速度）、或者自动选择。
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.options.synchronous = YES;//是否同步加载
    
    //容器类：FHAsset也可以通过设置数组得到所有照片内容 从一个Photos的获取方法中返回的有序的资源或者集合的列表。
    self.assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];//得到所有照片
    /*
     PHAssetMediaType：
     PHAssetMediaTypeUnknown = 0,//在这个配置下，请求不会返回任何东西
     PHAssetMediaTypeImage   = 1,//图片
     PHAssetMediaTypeVideo   = 2,//视频
     PHAssetMediaTypeAudio   = 3,//音频
     */
    [self.containView.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //返回照片数组中所有照片的数量
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DJSAlbumCell * cell = [[DJSAlbumCell alloc] init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:ALBUMCELLID forIndexPath:indexPath];
    
    //9.0可用 pixelWidth:相机宽度
    CGSizeMake(self.assets[indexPath.row].pixelWidth, self.assets[indexPath.row].pixelHeight);
    
    [self adjustGIFWithAsset2:self.assets[indexPath.row]];
    [[PHImageManager defaultManager] requestImageForAsset:self.assets[indexPath.row] targetSize: CGSizeMake(110, 110) contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        if ([cell.photoImageView isKindOfClass:[UIImageView class]] && cell.photoImageView) {
//        NSLog(@"cell.photoImageView = %@",cell.photoImageView);
        cell.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.photoImageView.image = result;
//        }
        ////        NSLog(@"%@",result);
        //        NSLog(@"%ld",self.num);
        //        NSLog(@"%@",info.allKeys);
    }];
    return cell;
    
}

- (BOOL)adjustGIFWithAsset:(PHAsset *)asset
{
    if ([asset isKindOfClass:[PHAsset class]]) {
        //每个asset 都有一个或者多个PHAssetResource(如：被编辑保存过的aseet会有若干个resource, 且被修改后的GIF类型的asset得uniformTypeIdentifier 会发生改变变成了public.jpeg 类型，所以修改多地GIF的就不再是GIF了，所以要对比最后一个resource的类型)
        NSArray<PHAssetResource *>* tmpArr = [PHAssetResource assetResourcesForAsset:asset];
        if (tmpArr.count) {
            PHAssetResource *resource = tmpArr.lastObject;
            if (resource.uniformTypeIdentifier.length) {
                return UTTypeConformsTo( (__bridge CFStringRef)resource.uniformTypeIdentifier, kUTTypeGIF);
            }
        }
    }
    return false;
}

//方法2
- (BOOL)adjustGIFWithAsset2:(PHAsset *)asset
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [options setSynchronous:true];//同步
    __block NSString *dataUTIStr = nil;
    if ([asset isKindOfClass:[PHAsset class]]) {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            dataUTIStr = dataUTI;
        }];
    }
    if (dataUTIStr.length) {
        return UTTypeConformsTo( (__bridge CFStringRef)dataUTIStr, kUTTypeGIF);
    }
    return false;
}

#pragma mark Request 这个先试试
/**mov转mp4格式 最好设一个block 转完码之后的回调*/
-(void)convertMovWithSourceURL:(NSURL *)sourceUrl fileName:(NSString *)fileName saveExportFilePath:(NSString *)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    NSArray *compatiblePresets=[AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];//输出模式标识符的集合
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        AVAssetExportSession *exportSession=[[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        NSString *resultPath = [path stringByAppendingFormat:@"/%@.mp4",fileName];
        exportSession.outputURL=[NSURL fileURLWithPath:resultPath];//输出路径
        exportSession.outputFileType = AVFileTypeMPEG4;//输出类型
        exportSession.shouldOptimizeForNetworkUse = YES;//为网络使用时做出最佳调整
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void){//异步输出转码视频
            switch (exportSession.status) {
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"转码状态：取消转码");
                    break;
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"转码状态：未知");
                    break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"转码状态：等待转码");
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"转码状态：正在转码");
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"转码状态：完成转码");
                    NSArray *files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
                    for (NSString *fn in files) {
                        if ([resultPath isEqualToString:fn]) {
                            NSLog(@"转码状态：完成转码 文件存在");
                        }
                    }
                    break;
                }
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"转码状态：转码失败");
                    NSLog(@"%@",exportSession.error.description);
                    break;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
