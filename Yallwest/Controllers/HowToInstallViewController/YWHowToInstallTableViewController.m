//
//  YWHowToInstallTableViewController.m
//  Yallwest
//
//  Created by Andrey Lisovskiy on 31.03.16.
//  Copyright © 2016 Andrey Lisovskiy. All rights reserved.
//

#import "YWHowToInstallTableViewController.h"

@interface YWHowToInstallTableViewController ()

@end

@implementation YWHowToInstallTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationBar];

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Methods -

- (void)setupNavigationBar
{
    //backButton
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_arrow"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(popViewControllerAnimated:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    
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

@end
