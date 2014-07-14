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

@implementation VCPageView

@synthesize index;

@end


@implementation VCPaginatedScrollView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize numberOfPages = _numberOfPages;
@synthesize centerPageIndex = _centerPageIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_centerPageIndex = -1;

		_pageMargin = 20.0;
		
		_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_scrollView.bounces = YES;
		_scrollView.pagingEnabled = YES;
		_scrollView.scrollsToTop = NO;
		_scrollView.delegate = self;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.directionalLockEnabled = YES;
		[self addSubview:_scrollView];
    }
    return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	_centerPageIndex = -1;
	
	_pageMargin = 20.0;
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_scrollView.bounces = YES;
	_scrollView.pagingEnabled = YES;
	_scrollView.scrollsToTop = NO;
	_scrollView.delegate = self;
	_scrollView.showsVerticalScrollIndicator = NO;
	_scrollView.showsHorizontalScrollIndicator = NO;
	[self addSubview:_scrollView];
}

- (void)dealloc
{
	[_scrollView release], _scrollView = nil;
	[_pages release], _pages = nil;
	[_reusablePages release], _reusablePages = nil;
	[super dealloc];
}


#pragma mark - Private Methods

- (VCPageView *)pageAtIndex:(NSInteger)index
{
	if (index < 0 || index >= _numberOfPages) {
		return nil;
	}
	VCPageView *page = [_pages objectAtIndex:index];
	return page;
}

- (void)updateContentSize
{
	_scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * _numberOfPages,
										 _scrollView.bounds.size.height);
}

- (void)configurePage:(VCPageView *)page forIndex:(NSInteger)index
{
	page.index = index;
	// extra stuff
}


#pragma mark - Layout

- (NSInteger)currentCenterPageIndex
{
	CGPoint currentOffset = _scrollView.contentOffset;

	return (NSInteger)(currentOffset.x / _scrollView.bounds.size.width);
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self layoutPages];
}

- (void)layoutPages
{
	// get current visible center index
	NSInteger currentCenterPageIndex = [self currentCenterPageIndex];

	// if same as _centerPageIndex return;
	if (_centerPageIndex == currentCenterPageIndex) {
		return;
	}

	_centerPageIndex = currentCenterPageIndex;

	// layout visible items
	[self layoutPageAtIndex:_centerPageIndex-1];
	[self layoutPageAtIndex:_centerPageIndex];
	[self layoutPageAtIndex:_centerPageIndex+1];

	// prepare for reuse previous pages
	[self prepareReusePageAtIndex:_centerPageIndex-2];

	// prepare for reuse upcoming pages
	[self prepareReusePageAtIndex:_centerPageIndex+2];
	
	[self updateContentSize];
}

- (void)layoutPageAtIndex:(NSInteger)index
{
	BOOL shouldLayout = NO;
	VCPageView *page = [self pageAtIndex:index];
	if (page == nil) return;
	
	if ((id)page == [NSNull null]) {
		if ([self.dataSource respondsToSelector:@selector(pagingScrollView:pageViewForIndex:)]) {
			page = (VCPageView *)[self.dataSource pagingScrollView:self pageViewForIndex:index];
			page.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		}
		[self configurePage:page forIndex:index];
		
		[_pages replaceObjectAtIndex:index withObject:page];
		[_scrollView addSubview:page];
		
		shouldLayout = YES;
	}else {
		if (page.index != index) {
			[self configurePage:page forIndex:index];
			shouldLayout = YES;
		}
	}
	
	if (shouldLayout) {
		page.frame = [self frameForPageAtIndex:index];
	}
}

- (CGRect)frameForPageAtIndex:(NSInteger)index
{
	CGRect pageFrame = _scrollView.bounds;

	// horizontal scroll
	pageFrame.origin.x = index * _scrollView.bounds.size.width + _pageMargin;
	pageFrame.size.width -= _pageMargin * 2;

	return pageFrame;
}

- (CGRect)frameForPaginatedScrollView
{
	CGRect frame = self.bounds;
    frame.origin.x -= _pageMargin;
    frame.size.width += (2 * _pageMargin);
	return frame;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self setNeedsLayout];
}


#pragma mark - Reuse Queue Logic

- (void)queueReusablePage:(VCPageView *)aPage
{
	NSUInteger reusableQueueLimit = 2;

	if ([_reusablePages count] >= reusableQueueLimit) {
		return;
	}

	[_reusablePages addObject:aPage];
}

- (VCPageView *)dequeueReusablePage
{
	if ([_reusablePages count] == 0) return nil;

	VCPageView *page = nil;

	page = [[_reusablePages lastObject] retain]; // retain to avoid crash
	[_reusablePages removeLastObject];

	return [page autorelease];
}

- (BOOL)prepareReusePageAtIndex:(NSUInteger)index
{
	VCPageView *cell = [self pageAtIndex:index];
	if (cell == nil) {
		return NO;
	}
    if ((id)cell != [NSNull null]) {
        [cell removeFromSuperview];
        [self queueReusablePage:cell];
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
	_scrollView.frame = [self frameForPaginatedScrollView];
	[self updateContentSize];

	// set cell pool size for reusability, should be double of _numberOfCellsInRow
	[_reusablePages release], _reusablePages = nil;
	_reusablePages = [[NSMutableArray alloc] init];

	// call for layout
	[self setNeedsLayout];
}

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
	CGRect rectToScroll = [self frameForPageAtIndex:index];
	[_scrollView scrollRectToVisible:rectToScroll
							animated:animated];
}

@end
