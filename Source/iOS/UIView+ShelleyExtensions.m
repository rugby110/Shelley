#import "LoadableCategory.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+ShelleyExtensions.h"

@implementation ShelleyCategoryLoader; @end

BOOL substringMatch(NSString *actualString, NSString *expectedSubstring){
    // for some reason Apple like to re-encode some spaces into non-breaking spaces, for example in the 
    // UITextFieldLabel's accessibilityLabel. We work around that here by subbing the nbsp for a regular space
    NSString *nonBreakingSpace = [NSString stringWithUTF8String:"\u00a0"];
    actualString = [actualString stringByReplacingOccurrencesOfString:nonBreakingSpace withString:@" "];
    
    return actualString && ([actualString rangeOfString:expectedSubstring].location != NSNotFound);    
}

@implementation UIView (ShelleyExtensions)

- (BOOL)marked:(NSString *)targetLabel
{
    return substringMatch([self accessibilityLabel], targetLabel);
}

- (BOOL)markedExactly:(NSString *)targetLabel
{
    return [[self accessibilityLabel] isEqualToString:targetLabel];
}

- (BOOL)isAnimating
{
    return (self.layer.animationKeys.count > 0);
}

- (BOOL)isNotAnimating
{
    return (self.layer.animationKeys.count == 0);
}

@end

@implementation UILabel (ShelleyExtensions)
- (BOOL)text:(NSString *)expectedText
{
    return substringMatch([self text], expectedText);
}
@end

@implementation UITextField (ShelleyExtensions)

- (BOOL)placeholder:(NSString *)expectedPlaceholder
{
    return substringMatch([self placeholder], expectedPlaceholder);
}

- (BOOL)text:(NSString *)expectedText
{
    return substringMatch([self text], expectedText);
}

@end

@implementation UIScrollView (ShelleyExtensions)
-(void)scrollDown:(int)offset
{
	[self setContentOffset:CGPointMake(0,offset) animated:NO];
}

-(void)scrollToBottom
{
	CGPoint bottomOffset = CGPointMake(0, [self contentSize].height);
	[self setContentOffset: bottomOffset animated: YES];
}

@end

@implementation UITableView (ShelleyExtensions)

-(NSArray *)rowIndexPathList
{
	NSMutableArray *rowIndexPathList = [NSMutableArray array];
	NSInteger numberOfSections = [self numberOfSections];
	for(NSInteger i=0; i< numberOfSections; i++) {
		NSInteger numberOfRowsInSection = [self numberOfRowsInSection:i];
		for(int j=0; j< numberOfRowsInSection; j++) {
			[rowIndexPathList addObject:[NSIndexPath indexPathForRow:j inSection:i]];
		}
	}
	return rowIndexPathList;
}

-(void)scrollDownRows:(int)numberOfRows
{
	NSArray *indexPathsForVisibleRows = [self indexPathsForVisibleRows];
	NSArray *rowIndexPathList = [self rowIndexPathList];
	
	NSIndexPath *indexPathForLastVisibleRow = [indexPathsForVisibleRows lastObject];
	
	NSInteger indexOfLastVisibleRow = [rowIndexPathList indexOfObject:indexPathForLastVisibleRow];
	NSInteger scrollToIndex = indexOfLastVisibleRow + numberOfRows;
	if (scrollToIndex >= rowIndexPathList.count) {
		scrollToIndex = rowIndexPathList.count - 1;
	}
	NSIndexPath *scrollToIndexPath = [rowIndexPathList objectAtIndex:scrollToIndex];
	[self scrollToRowAtIndexPath:scrollToIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)scrollToBottom
{
    NSInteger numberOfSections = [self numberOfSections];
    NSInteger numberOfRowsInSection = [self numberOfRowsInSection:numberOfSections-1];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfRowsInSection-1 inSection:numberOfSections-1];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end

