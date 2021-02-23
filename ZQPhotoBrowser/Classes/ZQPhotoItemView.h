//
//  ZQPhotoBrowserConfig.h
//  ZQPhotoBrowser
//
//  Created by 项正强 on 2021/2/23.
//


#import <SDWebImage/SDWebImage.h>
#import "ZQPhotoBrowserConfig.h"
NS_ASSUME_NONNULL_BEGIN

/// 如需要自定义配置则设置ZQPhotoBrowserConfig属性即可

@interface ZQPhotoItemView : SDAnimatedImageView
/// images：图片数组（类型为字符串url或者UIImage） currentIndex：当前索引
- (void) setImages:(NSArray *) images currentIndex:(NSInteger) currentIndex;

@end

NS_ASSUME_NONNULL_END
