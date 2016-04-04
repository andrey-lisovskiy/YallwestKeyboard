//
//  TCKGIFCell.m
//  TCKeyboard
//
//  Created by Andrey Lisovskiy on 04.01.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "GIFCell.h"
#import "IMGActivityIndicator.h"
#import "DFImageManager.h"
#import "DFImageTask.h"
#import "YWUtils.h"

@interface GIFCell ()

@property (nonatomic, strong) IMGActivityIndicator *activityIndicator;
@property (nonatomic, strong) DFImageTask *imageTask;

@end


@implementation GIFCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GIFCell" owner:self options:nil];
        self = array[0];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (_imageTask) {
        [self cancelImageFetching];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureActivityIndicator];
}

#pragma mark - Private methods

- (void)configureActivityIndicator
{
    _activityIndicator = [[IMGActivityIndicator alloc] initWithFrame:self.frame];
    _activityIndicator.backgroundColor = [YWUtils colorFromHexa:@"#f5f5f5"];
    _activityIndicator.strokeColor = [YWUtils colorFromHexa:@"#fb9a27"];
    _activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin   |
                                           UIViewAutoresizingFlexibleRightMargin  |
                                           UIViewAutoresizingFlexibleTopMargin    |
                                           UIViewAutoresizingFlexibleBottomMargin);
    _activityIndicator.alpha = 0.f;
    
    [self addSubview:_activityIndicator];
}

#pragma mark - Private methods

- (void)setImageFromURL:(NSURL*)imageURL
{
    _activityIndicator.alpha = 1.f;
    
    __weak typeof(self) weakSelf = self;
    _imageTask = [DFImageManager imageTaskForResource:imageURL
                                           completion:^(UIImage *image, NSError *error, DFImageResponse *response, DFImageTask *task){
                                               weakSelf.activityIndicator.alpha = 0.f;
                                               [weakSelf.gifImageView didCompleteImageTask:task withImage:image];
                                               weakSelf.contentView.backgroundColor = [UIColor clearColor];
                                           }];
    [_imageTask resume];
}

- (void)cancelImageFetching
{
    _imageTask.completionHandler = nil;
    _imageTask.progressiveImageHandler = nil;
    [_imageTask cancel];
    _imageTask = nil;
}

@end
