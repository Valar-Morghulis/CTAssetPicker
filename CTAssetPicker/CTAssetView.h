//
//  CTAssetView.h
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetDefines.h"
#import "CTVideoTitleView.h"
#import "CTTapAssetView.h"
@class CTAssetView;
@protocol CTAssetViewDelegate <NSObject>

-(BOOL)shouldSelectAsset:(CTAssetView *)view asset:(ALAsset*)asset;
-(void)tapSelectHandle:(CTAssetView *)view select:(BOOL)select asset:(ALAsset*)asset;

@end

@interface CTAssetView : UIView<CTTapAssetViewDelegate>
{
    ALAsset * _asset;
    id<CTAssetViewDelegate> _delegate;
    UIImageView * _imageView;
    CTVideoTitleView * _videoTitle;
    CTTapAssetView * _tapAssetView;
}
@property (nonatomic, retain) ALAsset *_asset;
@property (nonatomic, assign) id<CTAssetViewDelegate> _delegate;
@property (nonatomic, retain) UIImageView * _imageView;
@property (nonatomic, retain) CTVideoTitleView * _videoTitle;
@property (nonatomic, retain) CTTapAssetView * _tapAssetView;

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end
