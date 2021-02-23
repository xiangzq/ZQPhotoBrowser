//
//  ZQPhotoBrowserConfig.h
//  ZQPhotoBrowser
//
//  Created by 项正强 on 2021/2/23.
//


#import "ZQPhotoItemView.h"
#import "ZQPhotoBrowser.h"
@interface ZQPhotoItemView ()
@property (nonatomic,copy) NSArray *images;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) ZQPhotoBrowser *browser;
@end

@implementation ZQPhotoItemView

- (void)setImages:(NSArray *)images currentIndex:(NSInteger)currentIndex {
    _images = images.copy;
    _currentIndex = currentIndex;
    id image = [images objectAtIndex:currentIndex];
    if ([image isKindOfClass:[UIImage class]]) {
        self.image = image;
    } else if ([image isKindOfClass:[NSString class]]) {
        NSURL *url = [NSURL URLWithString:image];
        if (url) {
            [self sd_setImageWithURL:url];
        }
    } else {
        NSAssert(false, @"传入图片数组的数据类型错误");
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = true;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = true;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) imageClick {
    ZQPhotoBrowser *browser = [[ZQPhotoBrowser alloc] init];
    browser.sourceImageView = self;
    [browser setImages:_images currentImageIndex:_currentIndex];
    _browser = browser;
}

@end
