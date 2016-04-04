//
//  EmojiViewController.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 01.04.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "EmojiViewController.h"
#import "EmojiCell.h"
#import "Constants.h"

#import "UIImageView+WebCache.h"

@import MobileCoreServices;

@interface EmojiViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *emojiCollectionView;
@property (nonatomic, strong) NSArray *emojiArray;

@end

@implementation EmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareActivityCollectionView];
    [self loadEmojis];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *flowLayout = (id)self.emojiCollectionView.collectionViewLayout;
    flowLayout.itemSize = [self collectionViewCellSize];
    [flowLayout invalidateLayout];
}

#pragma mark - Public methods -

- (void)reset {
    [_emojiCollectionView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - Actions -

- (IBAction)yallwestButtonAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationYallwestButtonAction
                                                        object:nil];
}

- (IBAction)shareButtonAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShareButtonAction
                                                        object:nil];
}

#pragma mark - Methods -

- (void)loadEmojis
{
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Emojis"];
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath error:NULL];
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *fileName in contents) {
        [array addObject:[NSString stringWithFormat:@"%@/%@", sourcePath, fileName]];
    }
    
    self.emojiArray = array;
    
    [self.emojiCollectionView reloadData];
}

- (CGSize)collectionViewCellSize
{
    CGFloat sizeValue = roundf(CGRectGetHeight(self.view.frame)/3.8);
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
            sizeValue = roundf(CGRectGetHeight(self.view.frame)/2.8);
        }
    }
    
    return CGSizeMake(sizeValue, sizeValue);
}

- (void)prepareActivityCollectionView
{
    [self.emojiCollectionView registerClass:[EmojiCell class] forCellWithReuseIdentifier:@"EmojiCell"];
    [self configureFlowLayout];
}

- (void)configureFlowLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:[self collectionViewCellSize]];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(22.f, 8.f, 2.f, 8.f)];
    [flowLayout setMinimumInteritemSpacing:5.f];
    [flowLayout setMinimumLineSpacing:5.f];
    [self.emojiCollectionView setCollectionViewLayout:flowLayout];
}

- (id)gifImageForIndexPath:(NSIndexPath*)indexPath
{
    EmojiCell *cell = (EmojiCell*)[self.emojiCollectionView cellForItemAtIndexPath:indexPath];
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:cell.gifName ofType:@"gif"];
    NSData *fileData = [NSData dataWithContentsOfFile:fileName];
    
    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:fileData];
    if (!animatedImage) {
        animatedImage = (id)[UIImage imageNamed:fileName];
    }
    
    return animatedImage;
}

- (void)copyToPastboardGIFFromCellAtIndexPath:(NSIndexPath*)indexPath
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[_emojiArray objectAtIndex:indexPath.row]]];
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setData:data forPasteboardType:(__bridge NSString *)kUTTypeGIF];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _emojiArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmojiCell" forIndexPath:indexPath];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    NSURL *url = [NSURL fileURLWithPath:[_emojiArray objectAtIndex:indexPath.row]];
    [cell.gifImageView setImageWithResource:url];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmojiCell *cell = (EmojiCell*)[self.emojiCollectionView cellForItemAtIndexPath:indexPath];
    
    if (![cell hasInfoView]) {
        [cell showInfoViewWithType:InfoViewTypeCopied cornerRadius:0.f];
        [self copyToPastboardGIFFromCellAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(EmojiCell *)cell prepareForReuse];
}

@end
