//
//  CTAssetGroupViewCell.h
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetDefines.h"

@interface CTAssetGroupViewCell : UITableViewCell
{
    ALAssetsGroup * _assetsGroup;
}
@property (nonatomic, retain) ALAssetsGroup * _assetsGroup;
- (void)bind:(ALAssetsGroup *)assetsGroup;
@end
