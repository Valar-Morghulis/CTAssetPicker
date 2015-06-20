
#import "CTAssetDetailViewController.h"
#define IOS7LATER  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#import "CTAssetPickerController.h"

@implementation CTAssetDetailViewController
@synthesize _assets;
@synthesize _delegate;

-(void)dealloc
{
    self._assets = 0;
    if(_selections)
    {
        free(_selections);
        _selections = 0;
    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _selections = malloc(sizeof(BOOL) * [self._assets count]);
    memset(_selections, TRUE, [self._assets count]);
   
    //
    //设置导航栏的rightButton
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 22, 22);
    [_rightButton addTarget:self action:@selector(rightButtonClicked:)forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_rightButton] autorelease];
    
     //设置导航栏的leftButton
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(0, 0, 11, 20);
    [leftbtn setImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CTAssetPicker.Bundle/Images/AssetsPickerBack@2x.png"]] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(back)forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftbtn] autorelease];
    
    if(IOS7LATER)
    {
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    }
    else
    {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    //
    self.view.backgroundColor = [UIColor blackColor];
    if (IOS7LATER)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
        _doneButton = [[UIButton alloc]initWithFrame:CGRectMake(244,  _scrollView.frame.size.height + 9, 61, 32)];
    }
    else
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 100)];
        _doneButton = [[UIButton alloc]initWithFrame:CGRectMake(244,  _scrollView.frame.size.height + 11, 61, 32)];
    }
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = TRUE;
    
    for (int i = 0;i < [self._assets count]; i++) {
        ALAsset *asset = self._assets[i];
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imgview.contentMode = UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds = TRUE;
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [imgview setImage:tempImg];
        [_scrollView addSubview:imgview];
        [imgview release];
    }
    
    _scrollView.contentSize = CGSizeMake((self._assets.count) * (self.view.frame.size.width),0);
    [self.view addSubview:_scrollView];
    [_scrollView release];
    //
    [_doneButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CTAssetPicker.Bundle/Images/AssetsPickerComplete@2x.png"]] forState:UIControlStateNormal];
    
    _doneButton .titleLabel.font = [UIFont systemFontOfSize:10];
    [_doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doneButton];
    [_doneButton release];
    
    //
    _selectedCount = [self._assets count];
    [self update:TRUE];//

}

-(void)done:(UIButton *)sender
{
    if(self._delegate)
    {
        [self._delegate assetDetailDone:self];
    }
}

-(void)rightButtonClicked:(UIButton *)sender
{
    float width = _scrollView.frame.size.width;
    float offsetX = _scrollView.contentOffset.x;
    int index = offsetX / width + 0.5;
    index = index > 0 ? index : 0;
    index = index < [self._assets count] - 1 ? index : [self._assets count] - 1;
    
    _selections[index] = !_selections[index];
    BOOL selected = _selections[index];
    _selectedCount = selected ? _selectedCount + 1 : _selectedCount - 1;
    [self update:selected];
    if(self._delegate)
    {
        if(selected)
        {
            [self._delegate assetDetailSelect:self asset:[self._assets objectAtIndex:index]];
        }
        else
        {
            [self._delegate assetDetailDeselect:self asset:[self._assets objectAtIndex:index]];
        }
    }
}
-(void)update:(BOOL)selected
{
    UIImage * image1 = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CTAssetPicker.Bundle/Images/AssetsPickerChecked@2x.png"]];
    UIImage * image2 = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"CTAssetPicker.Bundle/Images/AssetsPickerUnChecked@2x.png"]];
    UIImage * img = selected ? image1 : image2;
    [_rightButton setImage:img forState:UIControlStateNormal];
    [_doneButton setTitle:[NSString stringWithFormat:@"完成(%ld)",_selectedCount] forState:UIControlStateNormal];
    
}

-(void)back
{
    if(self._delegate)
    {
        [self._delegate assetDetailBack:self];
    }
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float width = _scrollView.frame.size.width;
    float offsetX = _scrollView.contentOffset.x;
    int index = offsetX / width + 0.5;
    index = index > 0 ? index : 0;
    index = index < [self._assets count] - 1 ? index : [self._assets count] - 1;
    [self update:_selections[index]];
    
}


@end
