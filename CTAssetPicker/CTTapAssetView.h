//
//  CTTapAssetView.h
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetDefines.h"

@class CTTapAssetView;
@protocol CTTapAssetViewDelegate
-(void)touchSelect:(CTTapAssetView *)view select:(BOOL)select;
-(BOOL)shouldTap:(CTTapAssetView *)view;
@end


@interface CTTapAssetView : UIView
{
    UIImageView *_selectView;
    BOOL _selected;
    BOOL _disabled;
    id<CTTapAssetViewDelegate> _delegate;
}
@property(nonatomic,retain)UIImageView *_selectView;

@property (nonatomic, readwrite) BOOL _selected;
@property (nonatomic, readwrite) BOOL _disabled;
@property (nonatomic, assign) id<CTTapAssetViewDelegate> _delegate;
@end
