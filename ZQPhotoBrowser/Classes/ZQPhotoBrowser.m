//
//  ZQPhotoBrowserConfig.h
//  ZQPhotoBrowser
//
//  Created by 项正强 on 2021/2/23.
//


#import "ZQPhotoBrowser.h"
#import <Photos/Photos.h>
#import "UIImageView+WebCache.h"
#import "ZQBrowserImageView.h"
#import "ZQPhotoItemView.h"

@interface ZQPhotoBrowser ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,assign) BOOL hasShowedFistView;
@property (nonatomic,assign) BOOL willDisappear;
/// 当前索引
@property (nonatomic, assign) NSInteger currentImageIndex;
/// 图片数组
@property (nonatomic,copy) NSArray *images;
/// 滑动图片数组
@property (nonatomic,strong) NSMutableArray<ZQBrowserImageView *> *imageViewItems;

@end

@implementation ZQPhotoBrowser

- (void)setConfig:(int *)config {
    
}

/// 获取图片数据及当前索引
- (void)setImages:(NSArray *)images currentImageIndex:(NSInteger)currentImageIndex {
    _images = images;
    _currentImageIndex = currentImageIndex;
    [self show];
}

- (NSMutableArray<ZQBrowserImageView *> *)imageViewItems {
    if (!_imageViewItems) {
        _imageViewItems = @[].mutableCopy;
        for (int i = 0; i < self.images.count; i++) {
            ZQBrowserImageView *imageView = [[ZQBrowserImageView alloc] init];
            imageView.tag = i;
            [_scrollView addSubview:imageView];
            // 单击图片
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
            // 双击放大图片
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
            doubleTap.numberOfTapsRequired = 2;
            [singleTap requireGestureRecognizerToFail:doubleTap];
            [imageView addGestureRecognizer:singleTap];
            [imageView addGestureRecognizer:doubleTap];
            [_imageViewItems addObject:imageView];
        }
    }
    return _imageViewItems;
}

// 1. 序标
- (UILabel *)indexLabel {
    if (!_indexLabel) {
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.bounds = CGRectMake(0, 0, 80, 30);
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.font = [UIFont boldSystemFontOfSize:20];
        indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
        indexLabel.clipsToBounds = YES;
        indexLabel.hidden = [ZQPhotoBrowserConfig shared].isHideIndexLabel;
        if (self.images.count > 1) {
            indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.images.count];
        }
        _indexLabel = indexLabel;
    }
    return _indexLabel;
}

// 2.保存按钮
- (UIButton *)saveButton {
    if (!_saveButton) {
        UIButton *saveButton = [[UIButton alloc] init];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
        saveButton.layer.cornerRadius = 5;
        saveButton.clipsToBounds = YES;
        [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
        saveButton.hidden = [ZQPhotoBrowserConfig shared].isHideSaveBtn;
        _saveButton = saveButton;
    }
    return _saveButton;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ZQPhotoBrowserConfig shared].ZQPhotoBrowserBackgrounColor;
    }
    return self;
}

- (void)didMoveToSuperview{
    [self addSubview:self.indexLabel];
    [self addSubview:self.saveButton];
    [self addSubview:self.scrollView];
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    rect.size.width += [ZQPhotoBrowserConfig shared].ZQPhotoBrowserImageViewMargin * 2;
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - [ZQPhotoBrowserConfig shared].ZQPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    [_scrollView.subviews enumerateObjectsUsingBlock:^(ZQBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = [ZQPhotoBrowserConfig shared].ZQPhotoBrowserImageViewMargin + idx * ([ZQPhotoBrowserConfig shared].ZQPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    CGFloat statusBarHeight = 0.f;
    if (@available(iOS 13.0, *)) {
        statusBarHeight = [self window].windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, statusBarHeight);
    _saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
}

/// 单击图片
- (void)photoClick:(UITapGestureRecognizer *)recognizer{
    _scrollView.hidden = YES;
    _willDisappear = YES;
    ZQBrowserImageView *currentImageView = (ZQBrowserImageView *)recognizer.view;
    NSInteger tag = currentImageView.tag;
    UIView *sourceView = [self currentFatherView:tag];
    CGRect targetTemp = sourceView.frame;
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    // 防止 因imageview的image加载失败 导致 崩溃
    if (!currentImageView.image) h = self.bounds.size.height;
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    [self addSubview:tempView];
    _saveButton.hidden = YES;
    [UIView animateWithDuration:[ZQPhotoBrowserConfig shared].ZQPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        self.indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/// 双击图片
- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer{
    ZQBrowserImageView *imageView = (ZQBrowserImageView *)recognizer.view;
    CGFloat scale = imageView.isScaled ? 1.0 : 2.0;
    ZQBrowserImageView *view = (ZQBrowserImageView *)recognizer.view;
    [view doubleTapToZommWithScale:scale];
}

/// 保存图片
- (void)saveImage {
    if ([self hasPermissionForPhotoGallery]) {
        int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
        UIImageView *currentImageView = _scrollView.subviews[index];
        UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
        indicator.center = self.center;
        _indicatorView = indicator;
        [[self window] addSubview:indicator];
        [indicator startAnimating];
    } else {
        NSLog(@"没有相册权限");
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [_indicatorView removeFromSuperview];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[self window] addSubview:label];
    [[self window] bringSubviewToFront:label];
    if (error) {
        label.text = [ZQPhotoBrowserConfig shared].ZQPhotoBrowserSaveImageFailText;
    }   else {
        label.text = [ZQPhotoBrowserConfig shared].ZQPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index {
    ZQBrowserImageView *imageView = self.imageViewItems[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    if ([[self currentImage] isKindOfClass:[UIImage class]]) {
        imageView.image = [self currentImage];
    } else if ([[self currentImage] isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:[self currentImage]];
        if (url) {
            [imageView sd_setImageWithURL:url];
        }
    } else {
        NSAssert(false, @"传入的图片数组类型不正确（只能为url字符串或者UIImage）");
    }
    imageView.hasLoadedImage = YES;
}

/// 显示UI
- (void) show {
    UIWindow *window = [self window];
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        ZQBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[ZQBrowserImageView class]]) {
            [currentImageView clear];
        }
    }
}

- (void) showFirstImage {
    UIView *sourceView = [self currentFatherView:self.currentImageIndex];
    CGRect rect = sourceView.frame;
    UIImageView *tempView = [[UIImageView alloc] init];
    if ([[self currentImage] isKindOfClass:[UIImage class]]) {
        tempView.image = [self currentImage];
    } else if ([[self currentImage] isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:[self currentImage]];
        if (url) {
            [tempView sd_setImageWithURL:url];
        }
    } else {
        NSAssert(false, @"传入的图片数组类型不正确（只能为url字符串或者UIImage）");
    }
    [self addSubview:tempView];
    CGRect targetTemp = [self.imageViewItems[self.currentImageIndex] bounds];
    tempView.frame = rect;
    tempView.contentMode = [self.imageViewItems[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    [UIView animateWithDuration:[ZQPhotoBrowserConfig shared].ZQPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        self.hasShowedFistView = YES;
        [tempView removeFromSuperview];
        self.scrollView.hidden = NO;
    }];
}

//MARK: scrollview 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        ZQBrowserImageView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    if (!_willDisappear) _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.images.count];
    [self setupImageOfImageViewForIndex:index];
}

- (id) currentImage {
    id image = [_images objectAtIndex:_currentImageIndex];
    return image;
}

/// 当前父视图缩略图
- (UIView *) currentFatherView:(NSInteger) index {
    NSMutableArray *itemViews = @[].mutableCopy;
    UIView *sourceView = self.sourceImageView;
    UIView *superView = sourceView.superview;
    NSArray *views = superView.subviews;
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ZQPhotoItemView class]]) [itemViews addObject:obj];
    }];
    if (itemViews.count > index) {
        return [itemViews objectAtIndex:index];
    } else {
        return _sourceImageView;
    }
}

- (UIWindow *) window {
    return [UIApplication sharedApplication].delegate.window;
}

- (void)dealloc {
    [[self window] removeObserver:self forKeyPath:@"frame"];
}

/// 判断相册权限
- (BOOL) hasPermissionForPhotoGallery {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        return false;
    }
    return true;
}

@end
