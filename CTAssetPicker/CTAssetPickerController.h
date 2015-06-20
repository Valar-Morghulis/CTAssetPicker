//
//  CTAssetPickerController.h
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetDefines.h"

@class CTAssetPickerController;
@protocol CTAssetPickerControllerDelegate

-(void)assetPickerController:(CTAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets;//完成
-(void)assetPickerControllerDidCancel:(CTAssetPickerController *)picker;//取消
-(void)assetPickerController:(CTAssetPickerController *)picker didSelectAsset:(ALAsset*)asset;//选中某一项
-(void)assetPickerController:(CTAssetPickerController *)picker didDeselectAsset:(ALAsset*)asset;//取消选中
-(void)assetPickerControllerDidMaximum:(CTAssetPickerController *)picker;//到达最大数目
-(void)assetPickerControllerDidMinimum:(CTAssetPickerController *)picker;//到达最小数目

@end

@interface CTAssetPickerController : UINavigationController
{
    id<CTAssetPickerControllerDelegate> _delegate;//delegate
    
    ALAssetsFilter *_assetsFilter;//
    NSPredicate * _selectionFilter;//
    //
    NSArray * _indexPathsForSelectedItems;//选中项目
    NSInteger _maximumNumberOfSelection;//最大数目
    NSInteger _minimumNumberOfSelection;//最小数目
    //
     BOOL _showCancelButton;//是否显示取消
    BOOL _showEmptyGroups;//显示空的组
}
@property(nonatomic,assign) id<CTAssetPickerControllerDelegate> _delegate;

@property (nonatomic, retain) ALAssetsFilter * _assetsFilter;
@property (nonatomic, retain) NSPredicate * _selectionFilter;
@property (nonatomic, retain) NSArray * _indexPathsForSelectedItems;

//
@property (nonatomic, readwrite) NSInteger _maximumNumberOfSelection;
@property (nonatomic, readwrite) NSInteger _minimumNumberOfSelection;

@property (nonatomic, readwrite) BOOL _showCancelButton;
@property (nonatomic, readwrite) BOOL _showEmptyGroups;


@end
