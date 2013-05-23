//
//  VCPaginatedScrollView.m
//  Demo
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

#import "VCPaginatedScrollView.h"

@implementation VCPaginatedScrollView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize numberOfPages = _numberOfPages;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_scrollView.pagingEnabled = YES;
		_scrollView.scrollsToTop = NO;
		_scrollView.delegate = self;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		[self addSubview:_scrollView];
    }
    return self;
}

- (void)dealloc
{
	[_scrollView release], _scrollView = nil;
	[_pages release], _pages = nil;
	[_reusablePages release], _reusablePages = nil;
	[super dealloc];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	_scrollView.frame = self.bounds;
}

#pragma mark - Private Methods

#pragma mark - Reuse Queue Logic

- (void)queueReusableCell:(VCPageView *)aPage
{
	NSUInteger reusableQueueLimit = 2;

	if ([_reusablePages count] >= reusableQueueLimit) {
		return;
	}

	[_reusablePages addObject:aPage];
}

- (VCPageView *)dequeueReusableCell
{
	if ([_reusablePages count] == 0) return nil;

	VCPageView *page = nil;

	page = [[_reusablePages lastObject] retain]; // retain to avoid crash
	[_reusablePages removeLastObject];

	return [page autorelease];
}

- (BOOL)prepareReuseCellAtIndex:(NSUInteger)index
{
	VCPageView *cell = [self pageAtIndex:index];
    if ((id)cell != [NSNull null]) {
        [cell removeFromSuperview];
        [self queueReusableCell:cell];
        [_pages replaceObjectAtIndex:index withObject:[NSNull null]];
		return YES;
    }
	return NO;
}


#pragma mark - Public Methods

- (void)reloadData
{
	// remove all old views
	for (UIView *page in _pages) {
		if ([page isKindOfClass:[VCPageView class]]) {
			[page removeFromSuperview];
		}
	}

	// get number of Cells
	if ([self.dataSource respondsToSelector:@selector(numberOfPagesInPaginatedScrollView:)]) {
		_numberOfPages = [self.dataSource numberOfPagesInPaginatedScrollView:self];
	}
	_numberOfPages = MAX(_numberOfPages, 0);

	// initialize Cells arry with null objects
	[_pages release], _pages = nil;
	_pages = [[NSMutableArray alloc] init];
	for (NSUInteger i = 0; i < _numberOfPages; i++) {
		[_pages addObject:[NSNull null]];
	}

	// update content size
	[self updateContentSize];

	// set cell pool size for reusability, should be double of _numberOfCellsInRow
	[_reusablePages release], _reusablePages = nil;
	_reusablePages = [[NSMutableArray alloc] init];

	// call for layout
	[self setNeedsLayout];
}

@end