//
//  CTAssetGroupViewController.h
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTAssetDefines.h"

@interface CTAssetGroupViewController : UITableViewController
{
    ALAssetsLibrary * _assetsLibrary;
    NSMutableArray * _groups;
}
@property (nonatomic, retain) ALAssetsLibrary * _assetsLibrary;
@property (nonatomic, retain) NSMutableArray * _groups;
@end
