//
//  CTAssetGroupViewCell.m
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import "CTAssetGroupViewCell.h"


@implementation CTAssetGroupViewCell

@synthesize _assetsGroup;
-(void)dealloc
{
    self._assetsGroup = 0;
    [super dealloc];
}

- (void)bind:(ALAssetsGroup *)assetsGroup
{
    self._assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / kThumbnailLength;
    
    self.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.textLabel.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld", (long)[assetsGroup numberOfAssets]];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}

//
- (NSString *)accessibilityLabel
{
    NSString *label = [self._assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    return [label stringByAppendingFormat:NSLocalizedString(@"%ld 张照片", nil), (long)[self._assetsGroup numberOfAssets]];
}

@end
