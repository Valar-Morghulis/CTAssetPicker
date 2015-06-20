//
//  CTAssetViewCell.h
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetDefines.h"
#import "CTAssetView.h"

@class CTAssetViewCell;
@protocol CTAssetViewCellDelegate

- (BOOL)shouldSelectAsset:(CTAssetViewCell *)cell asset:(ALAsset*)asset;
- (void)didSelectAsset:(CTAssetViewCell *)cell asset:(ALAsset*)asset;
- (void)didDeselectAsset:(CTAssetViewCell *)cell asset:(ALAsset*)asset;

-(BOOL)isAssetSelected:(CTAssetViewCell *)cell asset:(ALAsset*)asset;

@end

@interface CTAssetViewCell : UITableViewCell<CTAssetViewDelegate>
{
    id<CTAssetViewCellDelegate> _delegate;
}
@property(nonatomic,assign) id<CTAssetViewCellDelegate> _delegate;

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX;
@end
