//
//  KeyboardViewController.m
//  Yellwest Keyboard
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "KeyboardViewController.h"
#import "HMSegmentedControl.h"
#import "UIImageView+WebCache.h"
#import "GIFViewController.h"
#import "YoutubeViewController.h"
#import "EmojiViewController.h"
#import "Constants.h"
#import "YWUtils.h"
#import "Masonry.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

typedef enum {
    CategoryTypeEmoji,
    CategoryTypeGIF,
    CategoryTypeVideo
} CategoryType;

@interface KeyboardViewController ()
{
    NSTimer *_backspaceKeyTimer;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backspaceButtonWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *categoriesContainerView;
@property (nonatomic, strong) HMSegmentedControl *categoriesSegmentedControl;

@property (strong, nonatomic) YoutubeViewController *youtubeViewController;
@property (strong, nonatomic) EmojiViewController *emojiViewController;
@property (strong, nonatomic) GIFViewController *gifViewController;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeGIFView];
    [self initializeEmojiView];
    [self initializeYoutubeView];
    [self configureSegmentedControl];
    [self adjustButtonsWidths];
    
    [self registerForNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
}

#pragma mark - Methods -

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareButtonAction) name:kNotificationShareButtonAction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yallwestButtonAction) name:kNotificationYallwestButtonAction object:nil];
}

- (void)initializeGIFView
{
    if (!_gifViewController) {
        _gifViewController = [GIFViewController new];
    }
}

- (void)initializeEmojiView {
    if (!_emojiViewController) {
        _emojiViewController = [EmojiViewController new];
    }
}

- (void)initializeYoutubeView {
    if (!_youtubeViewController) {
        _youtubeViewController = [YoutubeViewController new];
    }
}

- (void)mainContainerViewAddSubview:(UIView*)view {
    [self.mainContainerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainContainerView.mas_top);
        make.bottom.equalTo(self.mainContainerView.mas_bottom);
        make.left.equalTo(self.mainContainerView.mas_left);
        make.right.equalTo(self.mainContainerView.mas_right);
    }];
}

- (void)removeChildViewController:(UIViewController*)controller {
    if ([controller.view superview]) {
        [controller.view removeFromSuperview];
        [(id)controller reset];
    }
}

- (void)manageVisibility:(BOOL)isVisible ofViewController:(UIViewController*)viewController {
    if (isVisible) {
        [self mainContainerViewAddSubview:viewController.view];
    } else {
        [self removeChildViewController:viewController];
    }
}

- (void)configureSegmentedControl {
    NSArray *categoryImages = @[[UIImage imageNamed:@"nav_emoji"],
                                [UIImage imageNamed:@"nav_gif"],
                                [UIImage imageNamed:@"nav_video"]];
    
    _categoriesSegmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:categoryImages sectionSelectedImages:nil];
    _categoriesSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _categoriesSegmentedControl.frame = CGRectMake(0, 0, _categoriesContainerView.frame.size.width, _categoriesContainerView.frame.size.height);
    _categoriesSegmentedControl.selectionIndicatorHeight = 3.0f;
    _categoriesSegmentedControl.backgroundColor = [UIColor clearColor];
    _categoriesSegmentedControl.selectionIndicatorColor = [YWUtils colorFromHexa:@"#d2d2d2"];
    _categoriesSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _categoriesSegmentedControl.shouldAnimateUserSelection = YES;
    [_categoriesSegmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [_categoriesContainerView addSubview:_categoriesSegmentedControl];
    [self segmentedControlChangedValue:_categoriesSegmentedControl];
}

- (void)adjustButtonsWidths {
    if (SCREEN_WIDTH == 320.f) {
        self.nextButtonWidthConstraint.constant = 45.f;
        self.backspaceButtonWidthConstraint.constant = 45.f;
        [self.view layoutIfNeeded];
    }
}

#pragma mark - Actions -

- (void)shareButtonAction {
    [self.textDocumentProxy insertText:@"You're gonna love this new keyboard! http://apple.co/1SC1o3V"];
}

- (void)yallwestButtonAction {
    [self.textDocumentProxy insertText:@"http://www.yallwest.com/"];
}

- (IBAction)globeButtonAction:(id)sender {
    [self advanceToNextInputMode];
}

- (IBAction)deleteBackward {
    [self.textDocumentProxy deleteBackward];
}

- (IBAction)backspaceKeyPressed:(UIButton*)sender {
    _backspaceKeyTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(deleteBackward) userInfo:nil repeats:YES];
}

- (IBAction)backspaceKeyReleased:(UIButton *)sender {
    if (_backspaceKeyTimer != nil) {
        [_backspaceKeyTimer invalidate];
        _backspaceKeyTimer = nil;
    }
}

- (IBAction)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSInteger selectedIndex = segmentedControl.selectedSegmentIndex;
    [self manageVisibility:(selectedIndex == CategoryTypeEmoji) ofViewController:_emojiViewController];
    [self manageVisibility:(selectedIndex == CategoryTypeGIF) ofViewController:_gifViewController];
    [self manageVisibility:(selectedIndex == CategoryTypeVideo) ofViewController:_youtubeViewController];
}

@end
