//
//  ZQPhotoBrowserConfig.h
//  ZQPhotoBrowser
//
//  Created by 项正强 on 2021/2/23.
//


#import <UIKit/UIKit.h>
@interface ZQPhotoBrowser : UIView <UIScrollViewDelegate>

/**
 若当前browser的父视图为UICollectionView，sourceImageView就传递UICollectionView对象
 若当前browser的父视图为普通的view，sourceImageView就传递当前点击的view
 */
@property (nonatomic,strong) UIView *sourceImageView;
- (void) setImages:(NSArray *) images currentImageIndex:(NSInteger) currentImageIndex;

@end
