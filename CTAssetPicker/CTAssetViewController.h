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
@interface CTAssetViewController : UIViewController<CTAssetDetailViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ALAssetsGroup * _assetsGroup;
    NSMutableArray * _indexPathsForSelectedItems;
    NSInteger _number;//选中的张数
    UITableView * tableView;
    UIButton * _doneButton;
}
@property(nonatomic,retain)  UITableView * tableView;
@property (nonatomic, retain) ALAssetsGroup * _assetsGroup;
@property (nonatomic, retain) NSMutableArray * _indexPathsForSelectedItems;

@property (nonatomic,readonly) NSInteger _number; //选中的张数

@end
