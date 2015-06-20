//
//  CTAssetView.m
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import "CTAssetView.h"
#import "NSDate+TimeInterval.h"

@implementation CTAssetView
@synthesize _delegate;
@synthesize _asset;
@synthesize _imageView;
@synthesize _tapAssetView;
@synthesize _videoTitle;
-(void)dealloc
{
    self._asset = 0;
    self._imageView = 0;
    self._tapAssetView = 0;
    self._videoTitle = 0;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque = TRUE;
        self.isAccessibilityElement     = TRUE;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        //
        
        UIFont * titleFont = [UIFont systemFontOfSize:12];
        CGFloat titleHeight = 20.f;
        UIColor * titleColor = [UIColor whiteColor];
  
        self._imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbnailSize.width, kThumbnailSize.height)] autorelease];
        [self addSubview:self._imageView];
        //
        self._videoTitle = [[[CTVideoTitleView alloc] initWithFrame:CGRectMake(0, kThumbnailSize.height - 20, kThumbnailSize.width, titleHeight)] autorelease];
        self._videoTitle.hidden = TRUE;
        self._videoTitle.font = titleFont;
        self._videoTitle.textColor = titleColor;
        self._videoTitle.textAlignment = NSTextAlignmentRight;
        self._videoTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:self._videoTitle];
        //
        self._tapAssetView = [[[CTTapAssetView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        self._tapAssetView._delegate = self;
        [self addSubview:self._tapAssetView];
    }
    
    return self;
}

- (void)bind:(ALAsset *)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced
{
    self._asset = asset;
    [self._imageView setImage:[UIImage imageWithCGImage:asset.thumbnail]];
    
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        self._videoTitle.hidden = FALSE;
        self._videoTitle.text = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    }
    else
    {
        self._videoTitle.hidden = TRUE;
    }
    self._tapAssetView._disabled = ! [selectionFilter evaluateWithObject:asset];
    self._tapAssetView._selected = isSeleced;
}

#pragma mark - CTTapAssetViewDelegate

-(BOOL)shouldTap:(CTTapAssetView *)view
{
    if (self._delegate)
    {
        return [_delegate shouldSelectAsset:self asset:self._asset];
    }
    return YES;
}

-(void)touchSelect:(CTTapAssetView *)view select:(BOOL)select
{
    if (self._delegate)
    {
        [_delegate tapSelectHandle:self select:select asset:self._asset];
    }
}


@end
