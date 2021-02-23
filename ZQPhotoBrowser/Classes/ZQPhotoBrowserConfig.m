//
//  ZQPhotoBrowserConfig.m
//  ZQPhotoBrowser
//
//  Created by 项正强 on 2021/2/23.
//

#import "ZQPhotoBrowserConfig.h"

@implementation ZQPhotoBrowserConfig

//MARK: 初始化
+ (instancetype) shared {
    static ZQPhotoBrowserConfig *until = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /// 因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法,不能再使用alloc方法
        until = [[super allocWithZone:NULL] init];
    });
    return until;
}

/// 防止外部调用alloc 或者 new
+ (instancetype) allocWithZone:(struct _NSZone *) zone {
    return [ZQPhotoBrowserConfig shared];
}

/// 防止外部调用copy
- (id) copyWithZone:(nullable NSZone *) zone {
    return [ZQPhotoBrowserConfig shared];
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.ZQPhotoBrowserSaveImageSuccessText = @"^_^ 保存成功";
        self.ZQPhotoBrowserSaveImageFailText = @">_< 保存失败";
        
        self.ZQPhotoBrowserImageViewMargin = 10.f;
        self.ZQPhotoBrowserShowImageAnimationDuration = 0.4f;
        self.ZQPhotoBrowserHideImageAnimationDuration = 0.4f;
        self.ZQWaitingViewItemMargin = 10.f;
        self.ZQWaitingViewProgressMode = ZQWaitingViewModeLoopDiagram;
        
        self.ZQPhotoBrowserBackgrounColor = [UIColor blackColor];
        self.ZQWaitingViewBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        self.isHideSaveBtn = false;
        self.isHideIndexLabel = false;
    }
    return self;
}
@end
