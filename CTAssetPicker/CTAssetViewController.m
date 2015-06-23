//
//  CTAssetViewController.m
//  CTAssetPickerController
//
//  Created by MaYing on 15/6/18.
//  Copyright (c) 2015年 xmg. All rights reserved.
//

#import "CTAssetViewController.h"
#import "CTAssetViewCell.h"
#import "CTAssetPickerController.h"
#define RGBA(r,g,b,a)							[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define kAssetViewCellIdentifier           @"CTAssetViewCellIdentifier"

@interface CTAssetViewController ()<CTAssetViewCellDelegate>
{
    int _columns;
    float _minimumInteritemSpacing;
    float _minimumLineSpacing;
    BOOL _unFirst;
    //
    NSMutableArray *_assets;
    NSInteger _numberOfPhotos;
    NSInteger _numberOfVideos;
}
@property (nonatomic, retain) NSMutableArray * _assets;
@property (nonatomic, readwrite) NSInteger _numberOfPhotos;
@property (nonatomic, readwrite) NSInteger _numberOfVideos;

@end



@implementation CTAssetViewController
@synthesize _indexPathsForSelectedItems;
@synthesize _assetsGroup;
@synthesize _number;
//
@synthesize _assets;
@synthesize _numberOfPhotos;
@synthesize _numberOfVideos;

@synthesize tableView;
-(void)dealloc
{
    self._assets = 0;
    self._assetsGroup = 0;
    self._indexPathsForSelectedItems = 0;
    self.tableView = 0;
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    
    CGRect frame = self.view.frame;
    
    float buttonContainerOriginX = 0;
    float buttonContainerWidth = frame.size.width;
    float buttonContainerHeight = 50;
    float buttonContainerOriginY = frame.size.height - buttonContainerHeight - 44;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        buttonContainerOriginY -= 20;
    }
    //
    UIView * buttonContainer = [[[UIView alloc] initWithFrame:CGRectMake(buttonContainerOriginX, buttonContainerOriginY, buttonContainerWidth, buttonContainerHeight)] autorelease];
    [self.view addSubview:buttonContainer];
    buttonContainer.layer.borderWidth = 1;
    buttonContainer.layer.borderColor = RGBA(216, 216, 216, 1).CGColor;
    buttonContainer.backgroundColor = [UIColor whiteColor];
    {
        float buttonOriginX = 20;
        float buttonWidth = 50;
        float buttonOriginY = 9;
        float buttonHeight = buttonContainerHeight - buttonOriginY * 2;
        UIButton * nextStepButton = [[[UIButton alloc] initWithFrame:CGRectMake(buttonOriginX, buttonOriginY, buttonWidth, buttonHeight)] autorelease];
        [buttonContainer addSubview:nextStepButton];
        [nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        [nextStepButton setTitle:@"预览" forState:UIControlStateNormal];
        nextStepButton .titleLabel.font = [UIFont systemFontOfSize:14];
        [nextStepButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        nextStepButton.layer.borderColor = RGBA(216, 216, 216, 1).CGColor;
        nextStepButton.layer.borderWidth = 1;
        nextStepButton.layer.cornerRadius = 5;
        //
        buttonWidth = 61;
        buttonOriginX = buttonContainerWidth - buttonWidth - buttonOriginX;
        _doneButton = [[[UIButton alloc] initWithFrame:CGRectMake(buttonOriginX, buttonOriginY, buttonWidth, buttonHeight)] autorelease];
        [buttonContainer addSubview:_doneButton];
        [_doneButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CTAssetPicker.Bundle/Images/AssetsPickerComplete@2x.png"]] forState:UIControlStateNormal];
        
        _doneButton .titleLabel.font = [UIFont systemFontOfSize:13];
        [_doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];

    }
    //
    float tableOriginX = 0;
    float tableWidth = frame.size.width;
    float tableOriginY = 0;
    float tableHeight = buttonContainerOriginY;
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(tableOriginX, tableOriginY, tableWidth, tableHeight)] autorelease];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    self._indexPathsForSelectedItems = [NSMutableArray array];
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        self.tableView.contentInset = UIEdgeInsetsMake(9.0, 2.0, 0, 2.0);
        _minimumInteritemSpacing = 3;
        _minimumLineSpacing = 3;
    }
    else
    {
        self.tableView.contentInset = UIEdgeInsetsMake(9.0, 0, 0, 0);
        _minimumInteritemSpacing = 2;
        _minimumLineSpacing = 2;
    }
    //
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
        [self setContentSizeForViewInPopover:kPopoverContentSize];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //
    NSString * title = [self._assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.title = title;
    //
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupButtons];//
    
    if (!_unFirst)
    {
        CTAssetPickerController *vc = (CTAssetPickerController *)self.navigationController;
        vc._indexPathsForSelectedItems = self._indexPathsForSelectedItems;//标记
        //
        _columns = floor(self.view.frame.size.width / (kThumbnailSize.width + _minimumInteritemSpacing));//计算
        [self setupAssets];
        _unFirst = TRUE;
    }
    [self.tableView reloadData];//重新加载
}

- (void)dismiss:(id)sender
{
    CTAssetPickerController *picker = (CTAssetPickerController *)self.navigationController;
    
    if (picker._delegate)
        [picker._delegate assetPickerControllerDidCancel:picker];
    
    //[picker.presentingViewController dismissViewControllerAnimated:TRUE completion:NULL];
}
-(void)done:(UIButton *)button
{
    CTAssetPickerController *picker = (CTAssetPickerController *)self.navigationController;
    
    if (self._indexPathsForSelectedItems.count <= picker._minimumNumberOfSelection)
    {
        if (picker._delegate)
        {
            [picker._delegate assetPickerControllerDidMinimum:picker];
        }
    }
    //
    if(picker._delegate)
    {
        [picker._delegate assetPickerController:picker didFinishPickingAssets:self._indexPathsForSelectedItems];
    }
}
#pragma mark - Rotation
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        self.tableView.contentInset = UIEdgeInsetsMake(9.0, 0, 0, 0);
        
        _minimumInteritemSpacing = 3;
        _minimumLineSpacing = 3;
    }
    else
    {
        self.tableView.contentInset = UIEdgeInsetsMake(9.0, 0, 0, 0);
        
        _minimumInteritemSpacing = 2;
        _minimumLineSpacing = 2;
    }
    _columns = floor(self.view.frame.size.width / (kThumbnailSize.width + _minimumInteritemSpacing));
    [self.tableView reloadData];
}


- (void)setupButtons
{
    self.navigationItem.rightBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(dismiss:)] autorelease];
    
    if([[[UIDevice currentDevice]systemVersion]doubleValue] >= 7.0)
    {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    //设置
     [self setDoneButtonTextWidthSelectedIndexPaths:self._indexPathsForSelectedItems];
}

- (void)setupAssets
{
    self._numberOfPhotos = 0;
    self._numberOfVideos = 0;
    self._assets = [NSMutableArray array];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
    {
        if (asset)
        {
            [self._assets addObject:asset];
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            if ([type isEqual:ALAssetTypePhoto])
                self._numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                self._numberOfVideos ++;
        }
        
        else if (self._assets.count > 0)
        {
            [self.tableView reloadData];//
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ceil(self._assets.count * 1.0 / _columns)  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    };
    
    [self._assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

#pragma mark - UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == ceil(self._assets.count * 1.0 / _columns))
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellFooter"];
        if (!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFooter"] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = [UIColor clearColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        NSString *title = 0;
        if (_numberOfVideos == 0)
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片", nil), (long)_numberOfPhotos];
        else if (_numberOfPhotos == 0)
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 部视频", nil), (long)_numberOfVideos];
        else
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片, %ld 部视频", nil), (long)_numberOfPhotos, (long)_numberOfVideos];
        
        cell.textLabel.text = title;
        return cell;
    }
    
    
    NSMutableArray *tempAssets = [NSMutableArray array];
    for (int i=0; i< _columns ;i++)
    {
        if ((indexPath.row * _columns + i) < self._assets.count)
        {
            [tempAssets addObject:[self._assets objectAtIndex:indexPath.row * _columns + i]];
        }
    }
    
    static NSString *CellIdentifier = kAssetViewCellIdentifier;
    CTAssetPickerController *picker = (CTAssetPickerController *)self.navigationController;
    
    CTAssetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[CTAssetViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell._delegate = self;
    
    [cell bind:tempAssets selectionFilter:picker._selectionFilter minimumInteritemSpacing:_minimumInteritemSpacing minimumLineSpacing:_minimumLineSpacing columns:_columns assetViewX:(self.tableView.frame.size.width - kThumbnailSize.width*tempAssets.count-_minimumInteritemSpacing*(tempAssets.count-1)) / 2];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(self._assets.count * 1.0 / _columns) + 1;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==ceil(self._assets.count * 1.0 / _columns))
    {
        return 44;
    }
    return kThumbnailSize.height + _minimumLineSpacing;
}


#pragma mark - CTAssetViewCellDelegate
-(BOOL)isAssetSelected:(CTAssetViewCell *)cell asset:(ALAsset *)asset
{
    return [self._indexPathsForSelectedItems containsObject:asset];
}
- (BOOL)shouldSelectAsset:(CTAssetViewCell *)cell asset:(ALAsset *)asset
{
    CTAssetPickerController *vc = (CTAssetPickerController *)self.navigationController;
    BOOL selectable = [self._indexPathsForSelectedItems containsObject:asset];
    if(!selectable)
    {
        selectable = [vc._selectionFilter evaluateWithObject:asset];
        if (self._indexPathsForSelectedItems.count >= vc._maximumNumberOfSelection)
        {
            if (vc._delegate)
            {
                [vc._delegate assetPickerControllerDidMaximum:vc];
            }
        }
        selectable = selectable && self._indexPathsForSelectedItems.count < vc._maximumNumberOfSelection;
    }
    return selectable;
}

- (void)didSelectAsset:(CTAssetViewCell *)cell asset:(ALAsset *)asset
{
    [self._indexPathsForSelectedItems addObject:asset];
    
    CTAssetPickerController *vc = (CTAssetPickerController *)self.navigationController;
    if (vc._delegate)
        [vc._delegate assetPickerController:vc didSelectAsset:asset];
    
    [self setDoneButtonTextWidthSelectedIndexPaths:self._indexPathsForSelectedItems];
}

- (void)didDeselectAsset:(CTAssetViewCell *)cell asset:(ALAsset *)asset
{
    [self._indexPathsForSelectedItems removeObject:asset];
    
    CTAssetPickerController *vc = (CTAssetPickerController *)self.navigationController;
    
    if (vc._delegate)
        [vc._delegate assetPickerController:vc didDeselectAsset:asset];
    
    [self setDoneButtonTextWidthSelectedIndexPaths:self._indexPathsForSelectedItems];
}


#pragma mark - Title

- (void)setDoneButtonTextWidthSelectedIndexPaths:(NSArray *)indexPaths
{
    _number = indexPaths.count;
    NSLog(@"self.number is %ld",self._number);
    [_doneButton setTitle:[NSString stringWithFormat:@"完成(%ld)",_number] forState:UIControlStateNormal];
}


#pragma mark - Actions

- (void)nextStep:(id)sender
{
    CTAssetDetailViewController * controller = [[CTAssetDetailViewController alloc] init];
    controller._delegate = self;
    controller._assets = [NSMutableArray arrayWithArray:self._indexPathsForSelectedItems];
    [self.navigationController pushViewController:controller animated:TRUE];
    [controller release];
}

#pragma mark CTAssetDetailViewControllerDelegate
-(void)assetDetailDone:(CTAssetDetailViewController *)controller
{
    [self done:0];
}
-(void)assetDetailBack:(CTAssetDetailViewController *)controller
{
    [self.navigationController popViewControllerAnimated:TRUE];
}
-(void)assetDetailSelect:(CTAssetDetailViewController *)controller asset:(ALAsset *)asset//选中
{
    [self._indexPathsForSelectedItems addObject:asset];
}
-(void)assetDetailDeselect:(CTAssetDetailViewController *)controller asset:(ALAsset *)asset//取消选中
{
    [self._indexPathsForSelectedItems removeObject:asset];
}


@end
