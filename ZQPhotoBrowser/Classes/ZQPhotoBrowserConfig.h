//
//  ZQPhotoBrowserConfig.h
//  ZQPhotoBrowser
//
//  Created by 项正强 on 2021/2/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef enum {
    ZQWaitingViewModeLoopDiagram, // 环形
    ZQWaitingViewModePieDiagram // 饼型
} ZQWaitingViewMode;

@interface ZQPhotoBrowserConfig : NSObject
+ (instancetype) shared;
/// 图片保存成功提示文字
@property (nonatomic,copy) NSString *ZQPhotoBrowserSaveImageSuccessText;
/// 图片保存失败提示文字
@property (nonatomic,copy) NSString *ZQPhotoBrowserSaveImageFailText;
/// browser背景颜色
@property (nonatomic,strong) UIColor *ZQPhotoBrowserBackgrounColor;
/// browser中图片间的margin
@property (nonatomic,assign) CGFloat ZQPhotoBrowserImageViewMargin;
/// browser中显示图片动画时长
@property (nonatomic,assign) CGFloat ZQPhotoBrowserShowImageAnimationDuration;
/// browser中隐藏图片动画时长
@property (nonatomic,assign) CGFloat ZQPhotoBrowserHideImageAnimationDuration;
/// 图片下载进度指示进度显示样式（ZQWaitingViewModeLoopDiagram 环形，ZQWaitingViewModePieDiagram 饼型）
@property (nonatomic,assign) ZQWaitingViewMode ZQWaitingViewProgressMode;
/// 图片下载进度指示器背景色
@property (nonatomic,strong) UIColor *ZQWaitingViewBackgroundColor;
/// 图片下载进度指示器内部控件间的间距
@property (nonatomic,assign) CGFloat ZQWaitingViewItemMargin;
/// 是否隐藏保存按钮
@property (nonatomic,assign) BOOL isHideSaveBtn;
/// 是否隐藏序标
@property (nonatomic,assign) BOOL isHideIndexLabel;
@end

NS_ASSUME_NONNULL_END
