//
//  TCKGIFCollectionViewCell.m
//  TCKeyboard
//
//  Created by Andrey Lisovskiy on 28.12.15.
//  Copyright © 2015 Andrey Lisovskiy. All rights reserved.
//

#import "TCKGIFCollectionViewCell.h"
#import "TCKInfoView.h"

@interface TCKGIFCollectionViewCell ()
{
    BOOL _isProcessingCopyAnimation;
}

@end


@implementation TCKGIFCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.gifImageView prepareForReuse];
    
    //remove TCKCopiedView if showed
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[TCKInfoView class]]) {
            [subview removeFromSuperview];
            break;
        }
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - Private methods

- (void)scaleImageViewForCompletion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.1f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(){
                         _gifImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^(){
                                              _gifImageView.transform = CGAffineTransformIdentity;
                                          }
                                          completion:^(BOOL finished) {
                                              if (completion) {
                                                  completion(finished);
                                              }
                                          }];
                     }];
}

#pragma mark - Public methods

- (void)showInfoViewWithType:(InfoViewType)type cornerRadius:(CGFloat)cornerRadius
{
    if (_isProcessingCopyAnimation) {
        return;
    }
    
    _isProcessingCopyAnimation = YES;
    [self scaleImageViewForCompletion:^(BOOL finished) {
        [TCKInfoView showInView:self type:type cornerRadius:cornerRadius];
        _isProcessingCopyAnimation = NO;
    }];
}

- (BOOL)hasInfoView
{
    for (UIView *subview in [self subviews]) {
        if ([subview isKindOfClass:[TCKInfoView class]]) {
            return YES;
        }
    }
    
    return NO;
}

@end
