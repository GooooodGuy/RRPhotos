//
//  RNPickPhotoHelper.m
//  RRSpring
//
//  Created by yi chen on 12-3-31.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "RNPickPhotoHelper.h"
#import "AppDelegate.h"
@implementation RNPickPhotoHelper

@synthesize imagePickerController = _imagePickerController;
@synthesize editPhotoController = _editPhotoController;
@synthesize sourceType = _sourceType;
@synthesize imageToReturn = _imageToReturn;
@synthesize photoInfoDic =_photoInfoDic;
@synthesize delegate = _delegate;
- (void)dealloc{
	self.imagePickerController = nil;
	self.editPhotoController = nil;
	self.imageToReturn = nil;
	self.photoInfoDic = nil;
	self.delegate = nil;
	
	[super dealloc];
}

- (id)init{
	if (self = [super init]) {
		self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//默认从照片库里面取
		_imagePickerController = [[UIImagePickerController alloc]init];
		_editPhotoController = [[RNEditPhotoViewController alloc]init];
	}
	return  self;
}

/**
 * 获取照片，数据通过回调传回
 */
- (void)pickPhotoWithSoureType:(UIImagePickerControllerSourceType) sourceType{
	self.sourceType = sourceType;
	
	self.imagePickerController.sourceType = self.sourceType;
	self.imagePickerController.delegate = self;
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication 
												   sharedApplication].delegate;

	[appDelegate.window.rootViewController  presentModalViewController:self.imagePickerController  animated:YES];
}
#pragma -mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	self.photoInfoDic = info;
	
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if ([mediaType isEqualToString:@"public.image"])
	{
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		if(image){
			NSLog(@"found an image");
		    [_editPhotoController loadImageToEdit:image];//初始化编辑界面
			_editPhotoController.delegate = self; //设置代理
			[picker pushViewController:self.editPhotoController animated:YES];

		}
		
	}
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissModalViewControllerAnimated:YES];

}	

#pragma -mark RNEditPhotoFinishDelegate
/**
 * 照片编辑完成回调
 */
- (void)editPhotoFinished:(UIImage *) imageEdited photoInfoDic: (NSDictionary * )photoInfoDic{
	self.imageToReturn = imageEdited;
	//
	[self.photoInfoDic setValuesForKeysWithDictionary:photoInfoDic];
	//回调传回数据
	[self.delegate pickPhotoFinished:self.imageToReturn photoInfoDic:self.photoInfoDic];
	
	[self.imagePickerController dismissModalViewControllerAnimated:YES];

}


@end
