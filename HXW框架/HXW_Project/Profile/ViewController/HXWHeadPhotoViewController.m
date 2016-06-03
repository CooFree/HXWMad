//
//  HXWHeadPhotoViewController.m
//  HXW框架
//
//  Created by hxw on 16/4/1.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWHeadPhotoViewController.h"

@interface HXWHeadPhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *headerPhoto;
}
@end

@implementation HXWHeadPhotoViewController

-(void)receiveNotification:(NSNotification *)noti
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    headerPhoto = [[UIImageView alloc]init];
    headerPhoto.image = Image(self.imgName);
    headerPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:headerPhoto];
    __weak typeof(self)HXW = self;
    [headerPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(HXW.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];

    [self setRightBtn];
}

-(void)setImgName:(NSString *)imgName
{
    _imgName = imgName;
}

-(void)setRightBtn
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(showPicker) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:Image(@"navigationbar_more") forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:Image(@"navigationbar_more_highlighted") forState:UIControlStateHighlighted];
    rightBtn.size = rightBtn.currentBackgroundImage.size;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

-(void)showPicker
{
    UIAlertController *alertCrl = [UIAlertController alertControllerWithTitle:nil message:@"请选择方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"拍照获取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loaclPhoto];
    }];
    UIAlertAction *actionThree = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCrl addAction:actionOne];
    [alertCrl addAction:actionTwo];
    [alertCrl addAction:actionThree];
    [self presentViewController:alertCrl animated:YES completion:nil];
}

//拍照
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        picker.mediaTypes =  [NSArray arrayWithObject:@"public.image"];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:picker animated:YES completion:nil];
        return;
        
    } else {
    }
}

//相册
-(void)loaclPhoto
{
    //此处需要加要OperationQueue中，不然有IOS8下面UIImagePickerController显示不出来
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [picker setAllowsEditing:NO];
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        //处理完后的图片保存到临时文件夹
        //            UIImage* image = scaleAndRotateImage([infos objectForKey:@"UIImagePickerControllerOriginalImage"]);
        UIImage* image = ThumbnailWithImage([info objectForKey:@"UIImagePickerControllerOriginalImage"], CGSizeMake(500, 500));
        
        NSString* fileName = StringFromDate([NSDate date], @"yyyyMMddHHmmss");
        fileName = [NSString stringWithFormat:@"%@.jpg", fileName];
        [HXWUserDefaults instance].headPic = fileName;
        [UIImageJPEGRepresentation(image, 0.1) writeToFile:[CachePath(@"picCache") stringByAppendingPathComponent:fileName] atomically:NO];
    }
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [HXWNotificationCenter postNotificationName:@"HXWProfileViewController" object:nil];
        headerPhoto.image = Image([CachePath(@"picCache") stringByAppendingPathComponent:[HXWUserDefaults instance].headPic]);
    }];
}


@end
