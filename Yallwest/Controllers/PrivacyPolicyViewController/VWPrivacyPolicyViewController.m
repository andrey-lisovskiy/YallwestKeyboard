//
//  VWPrivacyPolicyViewController.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 05.04.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "VWPrivacyPolicyViewController.h"

@interface VWPrivacyPolicyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation VWPrivacyPolicyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.textView setContentOffset:CGPointZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods -

- (void)setupNavigationBar {
    //cancelButton
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    
    //titleView
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 180.f, 25.f)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleView.frame];
    
    UIFont *font = [UIFont fontWithName:@"Futura-Medium" size:18.0];
    UIColor *color = [UIColor colorWithRed:54./255 green:156./255 blue:214./255 alpha:1.0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.title];
    [attributedString addAttributes:@{NSKernAttributeName : @(2),
                                      NSFontAttributeName : font,
                                      NSForegroundColorAttributeName : color}
                              range:NSMakeRange(0, self.title.length)];
    titleLabel.attributedText = attributedString;
    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleView;
}

- (void)setupTextView {
    self.textView.textContainerInset = UIEdgeInsetsMake(20.0, 8.0, 0.0, 8.0);
}

#pragma mark - Actions -

- (void)close {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
