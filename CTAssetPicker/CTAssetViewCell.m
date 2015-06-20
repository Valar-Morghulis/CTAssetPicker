//
//  CTAssetViewCell.m
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import "CTAssetViewCell.h"

@implementation CTAssetViewCell
@synthesize _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)bind:(NSArray *)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX
{
    if (self.contentView.subviews.count < assets.count)
    {
        for (int i=0; i<assets.count; i++)
        {
            if (i > ((NSInteger)self.contentView.subviews.count - 1))
            {
                CTAssetView *assetView = [[CTAssetView alloc] initWithFrame:CGRectMake(assetViewX + (kThumbnailSize.width +minimumInteritemSpacing) * i, minimumLineSpacing - 1, kThumbnailSize.width, kThumbnailSize.height)];
                BOOL isSelected = FALSE;
                if(self._delegate)
                    isSelected = [self._delegate isAssetSelected:self asset:assets[i]];
                
                [assetView bind:assets[i] selectionFilter:selectionFilter isSeleced:isSelected];
                assetView._delegate = self;
                [self.contentView addSubview:assetView];
                [assetView release];
            }
            else
            {
                ((CTAssetView*)self.contentView.subviews[i]).frame = CGRectMake(assetViewX + (kThumbnailSize.width + minimumInteritemSpacing)* (i), minimumLineSpacing - 1, kThumbnailSize.width, kThumbnailSize.height);
                BOOL isSelected = FALSE;
                if(self._delegate)
                    isSelected = [self._delegate isAssetSelected:self asset:assets[i]];
            
                [(CTAssetView*)self.contentView.subviews[i] bind:assets[i] selectionFilter:selectionFilter isSeleced:isSelected];
            }
            
        }
        
    }
    else
    {
        for (long i = self.contentView.subviews.count; i > 0; i--)
        {
            if ( i > assets.count)
            {
                [((CTAssetView*)self.contentView.subviews[i-1]) removeFromSuperview];
            }
            else
            {
                ((CTAssetView*)self.contentView.subviews[i-1]).frame = CGRectMake(assetViewX + (kThumbnailSize.width+minimumInteritemSpacing)*(i-1), minimumLineSpacing - 1, kThumbnailSize.width, kThumbnailSize.height);
                
                BOOL isSelected = FALSE;
                if(self._delegate)
                    isSelected = [self._delegate isAssetSelected:self asset:assets[i-1]];
                
                [(CTAssetView*)self.contentView.subviews[i-1] bind:assets[i-1] selectionFilter:selectionFilter isSeleced:isSelected];
            }
        }
    }
}

#pragma mark - CTAssetViewDelegate

-(BOOL)shouldSelectAsset:(CTAssetView *)view asset:(ALAsset *)asset
{
    if (self._delegate)
    {
        return [self._delegate shouldSelectAsset:self asset:asset];
    }
    return YES;
}

-(void)tapSelectHandle:(CTAssetView *)view select:(BOOL)select asset:(ALAsset *)asset
{
    if (select)
    {
        if (self._delegate)
        {
            [self._delegate didSelectAsset:self asset:asset];
        }
    }
    else
    {
        if (self._delegate)
        {
            [self._delegate didDeselectAsset:self asset:asset];
        }
    }
}

@end
