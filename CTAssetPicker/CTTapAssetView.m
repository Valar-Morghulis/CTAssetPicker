//
//  CTTapAssetView.m
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import "CTTapAssetView.h"

@implementation CTTapAssetView
@synthesize _selectView;
@synthesize _delegate;
@synthesize _disabled;
@synthesize _selected;

-(void)dealloc
{
    self._selectView = 0;
    [super dealloc];
}

static UIImage * _checkedNoIcon = 0;
static UIImage * _checkedIcon = 0;
static UIColor * _selectedColor = 0;
static UIColor *_disabledColor = 0;

+(void)initlize
{
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        _checkedIcon     = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CTAssetPicker.Bundle/Images/AssetsPickerChecked@2x.png"]];
        _checkedNoIcon     = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CTAssetPicker.Bundle/Images/AssetsPickerUnChecked@2x.png"]];
        
        _selectedColor   = [[UIColor colorWithWhite:1 alpha:0.3] retain];
        _disabledColor   = [[UIColor colorWithWhite:1 alpha:0.9] retain];
    });
}

-(id)initWithFrame:(CGRect)frame
{
    [[self class] initlize];
    if (self = [super initWithFrame:frame])
    {
        self._selectView = [[[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - _checkedIcon.size.width - 2, 2, _checkedIcon.size.width, _checkedIcon.size.height)] autorelease];
        [self addSubview:self._selectView];
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self._disabled)
    {
        return;
    }
    
    if (self._delegate && ![self._delegate shouldTap:self])
    {
        return;
    }
    
    if ((_selected = !_selected))
    {
        self.backgroundColor = _selectedColor;
        [self._selectView setImage:_checkedIcon];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        [self._selectView setImage:_checkedNoIcon];
    }
    if (self._delegate)
    {
        [self._delegate touchSelect:self select:_selected];
    }
}

-(void)set_disabled:(BOOL)disabled
{
    _disabled = disabled;
    if (_disabled)
    {
        self.backgroundColor = _disabledColor;
    }
    else
    {
        self.backgroundColor=[UIColor clearColor];
    }
}

-(void)set_selected:(BOOL)selected
{
    if (_disabled)
    {
        self.backgroundColor = _disabledColor;
        [self._selectView setImage:nil];
        return;
    }
    _selected = selected;
    if (_selected)
    {
        self.backgroundColor = _selectedColor;
        [self._selectView setImage:_checkedIcon];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        [self._selectView setImage:_checkedNoIcon];
    }
}

@end
