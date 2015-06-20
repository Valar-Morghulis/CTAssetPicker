//
//  CTAssetDefines.h
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#ifndef CTAssetPickerController_CTAssetDefines_h
#define CTAssetPickerController_CTAssetDefines_h

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define IS_IOS7             ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define kThumbnailLength    78.0f
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#define kPopoverContentSize CGSizeMake(320, 480)

#endif
