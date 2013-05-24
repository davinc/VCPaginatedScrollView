//
//  VCPaginatedScrollViewController.m
//  YouConnect
//
//  Created by Vinay Chavan on 23/05/13.
//
//  Copyright (c) 2013 Vinay Chavan.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "VCPaginatedScrollViewController.h"

@interface VCPaginatedScrollViewController ()

@end

@implementation VCPaginatedScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[_paginatedScrollView release], _paginatedScrollView = nil;
	[super dealloc];
}

- (void)loadView
{
	[super loadView];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	_paginatedScrollView = [[VCPaginatedScrollView alloc] initWithFrame:self.view.bounds];
	_paginatedScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_paginatedScrollView.backgroundColor = [UIColor blackColor];
	_paginatedScrollView.dataSource = self;
	_paginatedScrollView.delegate = self;
	[self.view addSubview:_paginatedScrollView];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[_paginatedScrollView reloadData];
}

- (void)viewDidUnLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[_paginatedScrollView release], _paginatedScrollView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - VCPaginatedScrollViewDelegate


#pragma mark - VCPaginatedScrollViewDataSource

- (NSInteger)numberOfPagesInPaginatedScrollView:(VCPaginatedScrollView *)paginatedScrollView
{
	return 0;
}

- (VCPageView *)pagingScrollView:(VCPaginatedScrollView *)paginatedScrollView pageViewForIndex:(NSInteger)pageIndex
{
	return nil;
}

@end
