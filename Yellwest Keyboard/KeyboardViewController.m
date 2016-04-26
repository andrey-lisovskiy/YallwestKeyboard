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

#import <AudioToolbox/AudioToolbox.h>

#define SCREEN_WIDTH        ([[UIScreen mainScreen] bounds].size.width)
#define RETURN_KEY_TEXT     @"\n"

typedef enum {
    CategoryTypeEmoji,
    CategoryTypeGIF,
    CategoryTypeVideo,
    CategoryTypeKeyboard
} CategoryType;

typedef enum {
    ShiftStatusOff,
    ShiftStatusOn,
    ShiftStatusCapsLock
} ShiftStatus;

@interface KeyboardViewController ()
{
    NSTimer *_backspaceKeyTimer;
    ShiftStatus _shiftStatus;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backspaceButtonWidthConstraint;

@property (weak, nonatomic) IBOutlet UIView *mainContainerView;
@property (weak, nonatomic) IBOutlet UIView *categoriesContainerView;
@property (nonatomic, strong) HMSegmentedControl *categoriesSegmentedControl;

@property (strong, nonatomic) YoutubeViewController *youtubeViewController;
@property (strong, nonatomic) EmojiViewController *emojiViewController;
@property (strong, nonatomic) GIFViewController *gifViewController;

@property (weak, nonatomic) IBOutlet UIView *keyboardLettersView;

//keyboard rows
@property (nonatomic, weak) IBOutlet UIView *numbersRow1View;
@property (nonatomic, weak) IBOutlet UIView *numbersRow2View;
@property (nonatomic, weak) IBOutlet UIView *symbolsRow1View;
@property (nonatomic, weak) IBOutlet UIView *symbolsRow2View;
@property (nonatomic, weak) IBOutlet UIView *numbersSymbolsRow3View;
@property (weak, nonatomic) IBOutlet UIView *lettersRow1View;
@property (weak, nonatomic) IBOutlet UIView *lettersRow2View;
@property (weak, nonatomic) IBOutlet UIView *lettersRow3View;
@property (weak, nonatomic) IBOutlet UIView *bottomKeyboardButtonsView;

//keys
@property (nonatomic, strong) NSArray *allKeyButtonsArray;
@property (nonatomic, strong) NSArray *letterButtonsArray;

@property (nonatomic, weak) IBOutlet UIButton *switchModeRow3Button;
@property (nonatomic, weak) IBOutlet UIButton *switchModeRow4Button;
@property (nonatomic, weak) IBOutlet UIButton *shiftButton;
@property (nonatomic, weak) IBOutlet UIButton *spaceButton;
@property (nonatomic, weak) IBOutlet UIButton *returnButton;
@property (nonatomic, weak) IBOutlet UIButton *backspaceButton;
@property (weak, nonatomic) IBOutlet UIButton *lettersBackspaceButton;
@property (weak, nonatomic) IBOutlet UIButton *nextResponderButton;
@property (weak, nonatomic) IBOutlet UIButton *switchToEmojiButton;

@property (strong, nonatomic) NSString *currentString;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeKeyboard];
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
                                [UIImage imageNamed:@"nav_video"],
                                [UIImage imageNamed:@"nav_keyboard"]];
    
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
    
    if (selectedIndex == CategoryTypeKeyboard) {
        [self manageAlphanumericKeyboardVisibility:YES];
        return;
    }
    
    [self manageVisibility:(selectedIndex == CategoryTypeEmoji) ofViewController:_emojiViewController];
    [self manageVisibility:(selectedIndex == CategoryTypeGIF) ofViewController:_gifViewController];
    [self manageVisibility:(selectedIndex == CategoryTypeVideo) ofViewController:_youtubeViewController];
}

#pragma mark - Alphanumeric Keyboard -

#pragma mark - Keyboard Methods

- (void)initializeKeyboard {
    [self fillLetterButtonsArray];
    [self fillAllKeyButtonsArray];

    _shiftStatus = ShiftStatusOn;
    
    //initialize space key double tap
    UITapGestureRecognizer *spaceDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spaceKeyDoubleTapped:)];
    
    spaceDoubleTap.numberOfTapsRequired = 2;
    [spaceDoubleTap setDelaysTouchesEnded:NO];
    
    [self.spaceButton addGestureRecognizer:spaceDoubleTap];
    
    //initialize shift key double and triple tap
    UITapGestureRecognizer *shiftDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shiftKeyDoubleTapped:)];
    UITapGestureRecognizer *shiftTripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shiftKeyPressed:)];
    
    shiftDoubleTap.numberOfTapsRequired = 2;
    shiftTripleTap.numberOfTapsRequired = 3;
    
    [shiftDoubleTap setDelaysTouchesEnded:NO];
    [shiftTripleTap setDelaysTouchesEnded:NO];
    
    [self.shiftButton addGestureRecognizer:shiftDoubleTap];
    [self.shiftButton addGestureRecognizer:shiftTripleTap];
}

- (void)insertText:(NSString*)string
{
    [self.textDocumentProxy insertText:string];
    [self manageShiftStatusAndModeAfterInputtedString:string];
}

- (void)manageShiftStatusAndModeAfterInputtedString:(NSString*)string
{
    NSString *inputText = self.currentString;
    if ([string isEqualToString:@" "] && inputText.length > 1)
    {
        NSString *lastTwoCharacters = [inputText substringFromIndex:[inputText length] - 2];
        NSRange punctuationCharacterRange = [lastTwoCharacters rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]];
        
        if ([lastTwoCharacters hasSuffix:@"."] || [lastTwoCharacters hasSuffix:@"!"] || [lastTwoCharacters hasSuffix:@"?"]) {
            [self manageSpaceAfterDotTap];
        } else if (punctuationCharacterRange.location != NSNotFound) {
            [self switchToLetterMode];
        }
    }
}

- (void)deleteBackwardText
{
    [self.textDocumentProxy deleteBackward];
    [self manageShiftModeAfterDelete];
}

- (void)manageShiftModeAfterDelete
{
    NSString *inputText = self.currentString;
    if (inputText.length > 1) {
        NSString *lastTwoCharacters = [inputText substringFromIndex:[inputText length] - 2];
        if ([lastTwoCharacters rangeOfString:@". "].location != NSNotFound) {
            [self enableShiftOnMode];
        }
    } else {
        [self enableShiftOnMode];
    }
}

- (void)manageSpaceKeyDoubleTap
{
    [self.textDocumentProxy deleteBackward];
    [self.textDocumentProxy insertText:@". "];
    
    if (_shiftStatus == ShiftStatusOff) {
        [self shiftKeyPressed:self.shiftButton];
    }
}

- (void)manageSpaceAfterDotTap
{
    if (_shiftStatus == ShiftStatusOff) {
        [self shiftKeyPressed:self.shiftButton];
    }
    
    [self switchToLetterMode];
}

- (void)switchToLetterMode
{
    self.switchModeRow3Button.tag = 0;
    [self switchKeyboardMode:self.switchModeRow3Button];
}

- (void)enableShiftOnMode
{
    if ((_shiftStatus != ShiftStatusOn) && (_shiftStatus != ShiftStatusCapsLock)) {
        _shiftStatus = ShiftStatusOn;
        [self shiftKeys];
    }
}

- (void)shiftKeys {
    
    //if shift is off, set letters to lowercase, otherwise set them to uppercase
    if (_shiftStatus == ShiftStatusOff) {
        for (UIButton* letterButton in self.letterButtonsArray) {
            [letterButton setTitle:letterButton.titleLabel.text.lowercaseString forState:UIControlStateNormal];
        }
    } else {
        for (UIButton* letterButton in self.letterButtonsArray) {
            [letterButton setTitle:letterButton.titleLabel.text.uppercaseString forState:UIControlStateNormal];
        }
    }
    
    //adjust the shift button images to match shift mode
    [self.shiftButton setImage:[UIImage imageNamed:[self shiftKeyImageForState:_shiftStatus]]
                      forState:UIControlStateNormal];
    [self.shiftButton setImage:[UIImage imageNamed:[self shiftKeyImageForState:_shiftStatus]]
                      forState:UIControlStateHighlighted];
}

- (NSString*)shiftKeyImageForState:(int)shiftState
{
    NSString *imageName = nil;
    
    switch (_shiftStatus) {
        case ShiftStatusOff:
            imageName = @"ic_shift_off";
            break;
            
        case ShiftStatusOn:
            imageName = @"ic_shift_on";
            break;
            
        case ShiftStatusCapsLock:
            imageName = @"ic_shift_caps2";
            break;
    }
    
    return imageName;
}

- (void)playKeyboardSound
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        AudioServicesPlaySystemSound(1104);
    });
}

- (void)configureReturnButton
{
    _returnButton.layer.cornerRadius = 4.f;
    _returnButton.layer.masksToBounds = YES;
}

- (NSString *)currentString
{
    return [self.textDocumentProxy documentContextBeforeInput];
}

- (void)fillLetterButtonsArray {
    NSMutableArray *lettersArray = [NSMutableArray new];
    NSArray *viewsArray = @[_lettersRow1View, _lettersRow2View, _lettersRow3View];
    for (UIView *view in viewsArray) {
        for (UIButton *button in view.subviews) {
            if (![button isEqual:_shiftButton] && ![button isEqual:_backspaceButton]) {
                [lettersArray addObject:button];
            }
        }
    }
    
    _letterButtonsArray = lettersArray;
}

- (void)fillAllKeyButtonsArray {
    NSMutableArray *keyArray = [NSMutableArray new];
    NSArray *viewsArray = @[_lettersRow1View, _lettersRow2View, _lettersRow3View, _numbersRow1View, _numbersRow2View, _numbersSymbolsRow3View, _bottomKeyboardButtonsView, _symbolsRow1View, _symbolsRow2View];
    for (UIView *view in viewsArray) {
        for (UIButton *button in view.subviews) {
            if ([button isEqual:_returnButton]) {
                [button addTarget:self action:@selector(returnKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
            } else if ([button isEqual:_shiftButton]){
                [button addTarget:self action:@selector(shiftKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
            } else if ([button isEqual:_switchModeRow4Button] ||
                       [button isEqual:_switchModeRow3Button]){
                [button addTarget:self action:@selector(switchKeyboardMode:) forControlEvents:UIControlEventTouchUpInside];
            } else if ([button isEqual:_nextResponderButton]){
                [button addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            } else if ([button isEqual:_spaceButton]){
                [button addTarget:self action:@selector(spaceKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
            } else if ([button isEqual:_returnButton]){
                [button addTarget:self action:@selector(returnKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
            } else if (![button isEqual:_backspaceButton] &&
                       ![button isEqual:_lettersBackspaceButton] &&
                       ![button isEqual:_switchToEmojiButton]){
                [button addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [keyArray addObject:button];
        }
    }
    
    _allKeyButtonsArray = keyArray;
}

- (void)manageAlphanumericKeyboardVisibility:(BOOL)isVisible {
    [UIView animateWithDuration:.1f animations:^{
        self.keyboardLettersView.alpha = isVisible;
    }];
}

#pragma mark - Keyboard Actions

- (IBAction)nextButtonPressed
{
    [self advanceToNextInputMode];
}

- (IBAction)keyPressed:(UIButton*)sender {
    [self playKeyboardSound];
    
    //inserts the pressed character into the text document
    NSString *text = sender.titleLabel.text;
    [self insertText:text];
    
    if (_shiftStatus == ShiftStatusOn) {
        [self shiftKeyPressed:self.shiftButton];
    }
}

- (IBAction)spaceKeyPressed:(UIButton*)sender {
    [self playKeyboardSound];
    [self.textDocumentProxy insertText:@" "];
    [self manageShiftStatusAndModeAfterInputtedString:@" "];
}

- (IBAction)spaceKeyDoubleTapped:(UIButton*)sender {
    [self manageSpaceKeyDoubleTap];
}

- (IBAction)returnKeyPressed:(UIButton*)sender {
    [self playKeyboardSound];
    [self insertText:RETURN_KEY_TEXT];
}

- (IBAction)shiftKeyPressed:(UIButton*)sender {
    [self playKeyboardSound];
    
    _shiftStatus = _shiftStatus > ShiftStatusOff ? ShiftStatusOff : ShiftStatusOn;
    
    [self shiftKeys];
}

- (void)shiftKeyDoubleTapped:(UIButton*)sender {
    _shiftStatus = ShiftStatusCapsLock;
    
    [self shiftKeys];
}

- (IBAction)switchKeyboardMode:(UIButton*)sender {
    [self playKeyboardSound];
    
    self.numbersRow1View.hidden = YES;
    self.numbersRow2View.hidden = YES;
    self.symbolsRow1View.hidden = YES;
    self.symbolsRow2View.hidden = YES;
    self.numbersSymbolsRow3View.hidden = YES;
    
    //switches keyboard to ABC, 123, or #+= mode
    //case 1 = 123 mode, case 2 = #+= mode
    //default case = ABC mode
    
    switch (sender.tag) {
            
        case 1: {
            self.numbersRow1View.hidden = NO;
            self.numbersRow2View.hidden = NO;
            self.numbersSymbolsRow3View.hidden = NO;
            
            //change row 3 switch button image to #+= and row 4 switch button to ABC
            [self.switchModeRow3Button setTitle:@"#+=" forState:UIControlStateNormal];
            [self.switchModeRow3Button setTitle:@"#+=" forState:UIControlStateSelected];
            self.switchModeRow3Button.tag = 2;
            
            [self.switchModeRow4Button setTitle:@"ABC" forState:UIControlStateNormal];
            [self.switchModeRow4Button setTitle:@"ABC" forState:UIControlStateSelected];
            self.switchModeRow4Button.tag = 0;
        }
            break;
            
        case 2: {
            self.symbolsRow1View.hidden = NO;
            self.symbolsRow2View.hidden = NO;
            self.numbersSymbolsRow3View.hidden = NO;
            
            //change row 3 switch button image to 123
            [self.switchModeRow3Button setTitle:@"123" forState:UIControlStateNormal];
            [self.switchModeRow3Button setTitle:@"123" forState:UIControlStateSelected];
            self.switchModeRow3Button.tag = 1;
        }
            break;
            
        default:
            //change the row 4 switch button image to 123
            [self.switchModeRow4Button setTitle:@"123" forState:UIControlStateNormal];
            [self.switchModeRow4Button setTitle:@"123" forState:UIControlStateSelected];
            self.switchModeRow4Button.tag = 1;
            break;
    }
}

- (IBAction)switchToEmojiButtonAction:(id)sender {
    _categoriesSegmentedControl.selectedSegmentIndex = CategoryTypeEmoji;
    [self segmentedControlChangedValue:_categoriesSegmentedControl];
    [self manageAlphanumericKeyboardVisibility:NO];
}

@end
