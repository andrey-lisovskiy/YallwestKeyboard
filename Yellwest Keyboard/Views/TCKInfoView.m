//
//  TCKCopiedView.m
//  TCKeyboard
//
//  Created by Andrey Lisovskiy on 17.12.15.
//  Copyright © 2015 Andrey Lisovskiy. All rights reserved.
//

#import "TCKInfoView.h"
#import "YWUtils.h"

@implementation TCKInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (void)baseInit
{
    //mainView
    self.layer.masksToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    //coloredView
    UIView *coloredView = [[UIView alloc] initWithFrame:self.frame];
    coloredView.backgroundColor = [YWUtils colorFromHexa:@"#369cd6"];
    coloredView.alpha = 0.9f;
    coloredView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:coloredView];
}

- (void)addInfoImageWithType:(InfoViewType)type
{
    //imageView
    UIImage *image = nil;
    switch (type) {
        case InfoViewTypeCopied:
            image = [UIImage imageNamed:@"copied_check"];
            break;
            
        case InfoViewTypeSaved:
            image = [UIImage imageNamed:@"status_saved"];
            break;
    }
    
    CGFloat imageWidth = MIN(image.size.width, CGRectGetWidth(self.frame));
    CGFloat imageHeight = MIN(image.size.height, CGRectGetHeight(self.frame));
    CGRect imageViewFrame = CGRectMake(roundf((CGRectGetWidth(self.frame) - imageWidth)/2), roundf((CGRectGetHeight(self.frame) - imageHeight)/2), imageWidth, imageHeight);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin   |
                                  UIViewAutoresizingFlexibleRightMargin  |
                                  UIViewAutoresizingFlexibleTopMargin    |
                                  UIViewAutoresizingFlexibleBottomMargin);
    
    [self addSubview:imageView];
}

+ (void)showInView:(UIView*)view type:(InfoViewType)type cornerRadius:(CGFloat)cornerRadius
{
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[TCKInfoView class]]) {
            return;
        }
    }
    
    
    TCKInfoView *infoView = [[TCKInfoView alloc] initWithFrame:view.bounds];
    [infoView addInfoImageWithType:type];
    
    infoView.layer.cornerRadius = cornerRadius;
    [view addSubview:infoView];
    infoView.alpha = 0.f;
    
    //show/hide animations
    infoView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2f
                     animations:^{
                         infoView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         infoView.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2f
                                               delay:1.5f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              infoView.alpha = 0.f;
                                          } completion:^(BOOL finished) {
                                              [infoView removeFromSuperview];
                                          }];
                     }];
}

@end
