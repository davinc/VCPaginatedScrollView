//
//  VCRootViewController.m
//  Demo
//
//  Created by Vinay Chavan on 24/05/13.
//  Copyright (c) 2013 Vinay Chavan. All rights reserved.
//

#import "VCRootViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface VCRootViewController ()

@end

@implementation VCRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VCPaginatedScrollViewDataSource

- (NSInteger)numberOfPagesInPaginatedScrollView:(VCPaginatedScrollView *)paginatedScrollView
{
	return 10;
}

- (VCPageView *)pagingScrollView:(VCPaginatedScrollView *)paginatedScrollView pageViewForIndex:(NSInteger)pageIndex
{
	VCPageView *page = [paginatedScrollView dequeueReusableCell];
	if (page == nil) {
		page = [[[VCPageView alloc] init] autorelease];
		page.layer.borderColor = [UIColor greenColor].CGColor;
		page.layer.borderWidth = 20.0f;
	}
	page.backgroundColor = [UIColor colorWithWhite:(float)pageIndex/10.0 alpha:1];

	return page;
}

@end
