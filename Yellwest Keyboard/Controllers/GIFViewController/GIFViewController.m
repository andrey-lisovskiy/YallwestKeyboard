//
//  TCKGIFViewController.m
//  TCKeyboard
//
//  Created by Andrey Lisovskiy on 18.12.15.
//  Copyright © 2015 Andrey Lisovskiy. All rights reserved.
//

#import "GIFViewController.h"
#import "SKRaggyCollectionViewLayout.h"
#import "ContentManager.h"
#import "GiphyContent.h"
#import "YWUtils.h"
#import "GIFCell.h"

@import MobileCoreServices;
@import AssetsLibrary;

@interface GIFViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SKRaggyCollectionViewLayoutDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *gifCollectionView;
@property (strong, nonatomic) NSArray *gifArray;
@end

@implementation GIFViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureCollectionView];
    [self configureFlowLayout];
    [self fillGifArray];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.gifCollectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Public methods -

- (void)reset
{
    [_gifCollectionView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - Methods

- (void)fillGifArray
{
    if ([[[ContentManager sharedInstance] giphyContents] count]) {
        _gifArray = [[ContentManager sharedInstance] giphyContents];
    } else {
        _gifCollectionView.alpha = 0.f;
        
        __weak typeof(self) weakSelf = self;
        [[ContentManager sharedInstance] requestGiphyContentsForCompletion:^(ContentManager *manager, NSError *error) {
            weakSelf.gifArray = manager.giphyContents;
            [weakSelf.gifCollectionView reloadData];
            
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 weakSelf.gifCollectionView.alpha = 1.f;
                             }];
        }];
    }
}

- (void)configureFlowLayout
{
    SKRaggyCollectionViewLayout *layout = (id)self.gifCollectionView.collectionViewLayout;
    layout.numberOfRows = 2;
    layout.variableFrontierHeight = NO;
}

- (void)configureCollectionView
{
    [self.gifCollectionView registerClass:[GIFCell class] forCellWithReuseIdentifier:@"GIFCell"];
}

- (void)copyToPastboardImage:(FLAnimatedImage*)image
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setData:image.data forPasteboardType:(__bridge NSString *)kUTTypeGIF];
}

- (UIColor*)colorForRow:(NSInteger)row
{
    return (row % 2 == 0) ? RGB(54, 156, 214) : RGB(255, 213, 3);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _gifArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GIFCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GIFCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [self colorForRow:indexPath.row];
    
    GiphyContent *content = _gifArray[indexPath.row];
    [cell setImageFromURL:[NSURL URLWithString:content.URL]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [(GIFCell *)cell prepareForReuse];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GIFCell *cell = (GIFCell*)[self.gifCollectionView cellForItemAtIndexPath:indexPath];
    
    if (![cell hasInfoView]) {
        [cell showInfoViewWithType:InfoViewTypeCopied cornerRadius:0.f];
        [self copyToPastboardImage:cell.gifImageView.animatedImageView.animatedImage];
    }
}

#pragma mark – SKCollectionLayoutDelegate

- (CGFloat)collectionLayout:(SKRaggyCollectionViewLayout*)layout preferredWidthForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GiphyContent *content = _gifArray[indexPath.row];
    CGFloat maxHeight = roundf(CGRectGetHeight(_gifCollectionView.frame)/2);
    CGFloat contentHeight = [content.thumbnailHeight doubleValue];
    CGFloat contentWidth = [content.thumbnailWidth doubleValue];
    CGFloat width = roundf((maxHeight/contentHeight) * contentWidth);
    
    return width;
}

- (UIEdgeInsets)collectionLayout:(SKRaggyCollectionViewLayout*)layout edgeInsetsForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
}

@end
