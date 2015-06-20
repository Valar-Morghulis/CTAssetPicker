//
//  CTAssetPickerController.m
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import "CTAssetPickerController.h"
#import "CTAssetGroupViewController.h"

@implementation CTAssetPickerController
@synthesize _assetsFilter;
@synthesize _delegate;
@synthesize _indexPathsForSelectedItems;
@synthesize _maximumNumberOfSelection;
@synthesize _minimumNumberOfSelection;
@synthesize _selectionFilter;
@synthesize _showCancelButton;
@synthesize _showEmptyGroups;

-(void)dealloc
{
    self._assetsFilter = 0;
    self._indexPathsForSelectedItems = 0;
    self._selectionFilter = 0;
    [super dealloc];
}

- (id)init
{
    CTAssetGroupViewController *groupViewController = [[CTAssetGroupViewController alloc] init];
    if (self = [super initWithRootViewController:groupViewController])
    {
        self._maximumNumberOfSelection      = 10;
       self. _minimumNumberOfSelection      = 0;
        self._assetsFilter                  = [ALAssetsFilter allAssets];
        self._showCancelButton              = TRUE;
        self._showEmptyGroups               = FALSE;
        self._selectionFilter               = [NSPredicate predicateWithValue:YES];
       
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        self.preferredContentSize = kPopoverContentSize;
#else
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
#endif
    }
    [groupViewController release];
    return self;
}


@end
