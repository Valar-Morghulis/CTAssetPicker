
#import <UIKit/UIKit.h>
#import "CTAssetDefines.h"

@class CTAssetDetailViewController;
@protocol CTAssetDetailViewControllerDelegate
-(void)assetDetailDone:(CTAssetDetailViewController *)controller;//完成
-(void)assetDetailBack:(CTAssetDetailViewController *)controller;//返回
-(void)assetDetailSelect:(CTAssetDetailViewController *)controller asset:(ALAsset *)asset;//选中
-(void)assetDetailDeselect:(CTAssetDetailViewController *)controller asset:(ALAsset *)asset;//取消选中
@end

@interface CTAssetDetailViewController : UIViewController<UIScrollViewDelegate>
{
    UIButton        *_rightButton;
    UIScrollView    *_scrollView;
    UIButton        *_doneButton;
    
    NSArray *_assets;
    id<CTAssetDetailViewControllerDelegate> _delegate;
    BOOL * _selections;//存储是否选中
    long _selectedCount;
}
@property(nonatomic,retain) NSArray *_assets;     //选中的图片数组
@property(nonatomic,assign) id<CTAssetDetailViewControllerDelegate> _delegate;
@end
