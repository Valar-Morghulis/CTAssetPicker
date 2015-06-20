//
//  CTAssetViewController.h
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CTAssetDefines.h"
#import "CTAssetDetailViewController.h"
@interface CTAssetViewController : UITableViewController<CTAssetDetailViewControllerDelegate>
{
    ALAssetsGroup * _assetsGroup;
    NSMutableArray * _indexPathsForSelectedItems;
    NSInteger _number;//选中的张数
}
@property (nonatomic, retain) ALAssetsGroup * _assetsGroup;
@property (nonatomic, retain) NSMutableArray * _indexPathsForSelectedItems;

@property (nonatomic,readonly) NSInteger _number; //选中的张数

@end
