//
//  ZQPhotoBrowserConfig.h
//  ZQPhotoBrowser
//
//  Created by 项正强 on 2021/2/23.
//


#import <SDWebImage/SDWebImage.h>
#import "ZQWaitingView.h"


@interface ZQBrowserImageView : SDAnimatedImageView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;

- (void)eliminateScale; // 清除缩放

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)doubleTapToZommWithScale:(CGFloat)scale;

- (void)clear;

@end
