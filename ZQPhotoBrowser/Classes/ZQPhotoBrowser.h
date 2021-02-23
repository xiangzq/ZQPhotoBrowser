//
//  ZQPhotoBrowserConfig.h
//  ZQPhotoBrowser
//
//  Created by 项正强 on 2021/2/23.
//


#import <UIKit/UIKit.h>
@interface ZQPhotoBrowser : UIView <UIScrollViewDelegate>

/// 当前缩略图
@property (nonatomic,strong) UIView *sourceImageView;
- (void) setImages:(NSArray *) images currentImageIndex:(NSInteger) currentImageIndex;

@end
