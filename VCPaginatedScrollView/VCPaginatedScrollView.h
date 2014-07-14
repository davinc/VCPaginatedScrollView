//
//  VCPaginatedScrollView.h
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

#import <UIKit/UIKit.h>

// VCPageView Protocol
@protocol VCPageView <NSObject>
@required
@property (nonatomic, assign) NSInteger index;
@end

// VCPageView Base Class
@interface VCPageView : UIView <VCPageView>
@end




@class VCPaginatedScrollView;


@protocol VCPaginatedScrollViewDelegate <UIScrollViewDelegate> @end

@protocol VCPaginatedScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInPaginatedScrollView:(VCPaginatedScrollView *)paginatedScrollView;
- (id<VCPageView>)pagingScrollView:(VCPaginatedScrollView *)paginatedScrollView pageViewForIndex:(NSInteger)pageIndex;

@end


@interface VCPaginatedScrollView : UIView <UIScrollViewDelegate>
{
@private
	UIScrollView *_scrollView;
	NSInteger _centerPageIndex;

	NSMutableArray *_pages;
	NSInteger _numberOfPages;
	CGFloat _pageMargin;

	NSMutableArray *_reusablePages;
}

@property (nonatomic, assign) id<VCPaginatedScrollViewDataSource> dataSource;
@property (nonatomic, assign) id<VCPaginatedScrollViewDelegate> delegate;

@property (nonatomic, readonly) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger centerPageIndex;

- (void)reloadData;

- (id<VCPageView>)dequeueReusablePage;

- (void)scrollToPageAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
