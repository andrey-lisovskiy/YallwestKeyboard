//
//  TCKYoutubeViewController.m
//  TCKeyboard
//
//  Created by Andrey Lisovskiy on 12.01.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "YoutubeViewController.h"
#import "ContentManager.h"
#import "YoutubeContent.h"
#import "YoutubeCell.h"
#import "TCKInfoView.h"

@interface YoutubeViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *youtubeCollectionView;
@property (strong, nonatomic) NSArray *youtubeArray;

@end

@implementation YoutubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView];
    [self fillYoutubeArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods -

- (void)reset
{
    [_youtubeCollectionView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - Methods

- (void)reloadCollectionViewWithData:(NSArray*)array
{
    _youtubeCollectionView.alpha = 0.f;
    
    [_youtubeCollectionView setContentOffset:CGPointZero animated:NO];
    
    _youtubeArray = array;
    [_youtubeCollectionView reloadData];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _youtubeCollectionView.alpha = 1.f;
                     }];
}

- (void)fillYoutubeArray
{
    if ([[[ContentManager sharedInstance] youtubeContents] count]) {
        _youtubeArray = [[ContentManager sharedInstance] youtubeContents];
    } else {
        
        __weak typeof(self) weakSelf = self;
        [[ContentManager sharedInstance] requestYoutubeContentsForCompletion:^(ContentManager *manager, NSError *error) {
            [weakSelf reloadCollectionViewWithData:manager.youtubeContents];
        }];
    }
}

- (void)configureCollectionView
{
    [self.youtubeCollectionView registerNib:[UINib nibWithNibName:@"YoutubeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"YoutubeCell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _youtubeArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YoutubeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YoutubeCell" forIndexPath:indexPath];
    cell.content = _youtubeArray[indexPath.row];
    [cell updateViewCount];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [(YoutubeCell *)cell prepareForReuse];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YoutubeCell *cell = (YoutubeCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [TCKInfoView showInView:cell type:InfoViewTypeCopied cornerRadius:0.f];

    YoutubeContent *content = _youtubeArray[indexPath.row];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = content.mediaURL;
}
@end
