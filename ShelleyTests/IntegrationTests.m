@import Foundation;
@import XCTest;
#import "XCTestCase+Extensions.h"
#import "Shelley.h"

@interface IntegrationTests: XCTestCase

@property (nonatomic) ShelleyTestView *view;
@property (nonatomic) ShelleyTestView *viewA;
@property (nonatomic) ShelleyTestView *viewAA;
@property (nonatomic) ShelleyTestView *viewAB;
@property (nonatomic) ShelleyTestView *viewABA;
@property (nonatomic) ShelleyTestView *viewB;
@property (nonatomic) ShelleyTestView *viewBA;
@property (nonatomic) ShelleyTestView *viewC;

@end

@implementation IntegrationTests

- (void)testMarkedSelectedSubstringMatchesWhileMarkedExactlyOnlySelectsExactMatches
{
    ShelleyTestView *rootView = [[ShelleyTestView alloc] init];
    UIView *subviewA = [[UIView alloc] init];
    subviewA.accessibilityLabel = @"Frankly";
    UIView *subviewB = [[UIView alloc] init];
    subviewB.accessibilityLabel = @"rank";
    UIView *subviewC = [[UIView alloc] init];
    subviewC.accessibilityLabel = @"Fr-anky";
    UIView *subviewD = [[UIView alloc] init];
    subviewD.accessibilityLabel = nil;
    UIView *subviewE = [[UIView alloc] init];
    subviewE.accessibilityLabel = @" rank";
    [rootView addSubview:subviewA];
    [rootView addSubview:subviewB];
    [rootView addSubview:subviewC];
    [rootView addSubview:subviewD];
    [rootView addSubview:subviewE];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'rank'"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    XCTAssertEqual((NSUInteger)3, selectedViews.count);
    [self assertArray:selectedViews containsObject:subviewA];
    [self assertArray:selectedViews containsObject:subviewB];
    [self assertArray:selectedViews containsObject:subviewE];
    shelley = [Shelley withSelectorString:@"view markedExactly:'rank'"];
    selectedViews = [shelley selectFrom:rootView];
    XCTAssertEqual((NSUInteger)1, selectedViews.count);
    [self assertArray:selectedViews containsObject:subviewB];
}



@end


//
//- (void) testHandlesDoubleQuotedstringsWithSingleQuotesAndSpacesInside {
//    ShelleyTestView *rootView = [[[ShelleyTestView alloc] init]autorelease];
//    UIViewWithAccessibilityLabel *subview = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"I'm selected"] autorelease];
//    [rootView addSubview:subview];
//    
//    Shelley *shelley = [Shelley withSelectorString:@"view marked:\"I'm selected\""];
//    NSArray *selectedViews = [shelley selectFrom:rootView];
//    
//    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
//    [self assertArray:selectedViews containsObject:subview];
//}
//
//- (void) testHandlesSingleQuotesWithDoubleQuotesInside {
//    ShelleyTestView *rootView = [[[ShelleyTestView alloc] init]autorelease];
//    UIViewWithAccessibilityLabel *subview = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"say \"hi\" now"] autorelease];
//    [rootView addSubview:subview];
//    
//    Shelley *shelley = [Shelley withSelectorString:@"view marked:'say \"hi\" now'"];
//    NSArray *selectedViews = [shelley selectFrom:rootView];
//    
//    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
//    [self assertArray:selectedViews containsObject:subview];
//}
//
//- (void) testAppliesFiltersSequentiallyInADepthFirstManner {
//    ShelleyTestView *rootView = [[[ShelleyTestView alloc] init]autorelease];
//    
//    ShelleyTestButton *buttonA = [[[ShelleyTestButton alloc] init] autorelease];
//    ShelleyTestButton *buttonAA = [[[ShelleyTestButton alloc] init] autorelease];
//    ShelleyTestView *nonButtonB = [[[ShelleyTestView alloc] init]autorelease];
//    ShelleyTestButton *buttonBA = [[[ShelleyTestButton alloc] init] autorelease];
//    
//    [rootView addSubview:buttonA];
//    [buttonA addSubview:buttonAA];
//    [rootView addSubview:nonButtonB];
//    [nonButtonB addSubview:buttonBA];
//    
//    Shelley *shelley = [Shelley withSelectorString:@"button button"];
//    NSArray *selectedViews = [shelley selectFrom:rootView];
//    
//    // The only button whose parent is a button is button AA
//    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
//    [self assertArray:selectedViews containsObject:buttonAA];
//}
//
//- (void) testWeFilterOutDupes {
//    Shelley *shelley = [Shelley withSelectorString:@"button parent descendant button"];
//    NSArray *selectedViews = [shelley selectFrom:view];
//    
//    STAssertEquals((NSUInteger)2, selectedViews.count, nil);
//    [self assertArray:selectedViews containsObject:viewAA];
//    [self assertArray:selectedViews containsObject:viewB];
//}
//
//- (void) testAllowsSelectionOfSiblingsAndCousinsViaParentFilter {
//    ShelleyTestTableView *tableView = [[[ShelleyTestTableView alloc] init]autorelease];
//    
//    ShelleyTestTableCell *cellA = [[[ShelleyTestTableCell alloc] init] autorelease];
//    UIViewWithAccessibilityLabel *subviewA = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"cell A"] autorelease];
//    ShelleyTestButton *buttonA = [[[ShelleyTestButton alloc] init]autorelease];
//    [cellA addSubview:subviewA];
//    [cellA addSubview:buttonA];
//    
//    ShelleyTestTableCell *cellB = [[[ShelleyTestTableCell alloc] init] autorelease];
//    UIViewWithAccessibilityLabel *subviewB = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"cell B"] autorelease];
//    ShelleyTestButton *buttonB = [[[ShelleyTestButton alloc] init]autorelease];
//    [cellB addSubview:subviewB];
//    [cellB addSubview:buttonB];
//    
//    [tableView addSubview:cellA];
//    [tableView addSubview:cellB];
//    
//    NSArray *selectedViews = [[Shelley withSelectorString:@"view marked:'cell B'"] selectFrom:tableView];
//    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:subviewB]];
//    
//    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent"] selectFrom:tableView];
//    NSArray *expectedViews;
//    
//    if (NSClassFromString(@"UITableViewCellScrollView")) { // iOS 7 +
//        expectedViews = [NSArray arrayWithObjects:cellB,tableView,[cellB superview],nil];
//    } else { // iOS 6 -
//        expectedViews = [NSArray arrayWithObjects:cellB,tableView,nil];
//    }
//    
//    [self assertArray:selectedViews containsExactlyObjects:expectedViews];
//    
//    
//#if TARGET_OS_IPHONE
//    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableViewCell'"] selectFrom:tableView];
//    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:cellB]];
//    
//    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableViewCell' button"] selectFrom:tableView];
//    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:buttonB]];
//    
//    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableView'"] selectFrom:tableView];
//    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:tableView]];
//    
//    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableView' view marked:'cell A'"] selectFrom:tableView];
//    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:subviewA]];
//#else
//    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'NSTextView'"] selectFrom:tableView];
//    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:cellB]];
//    
//    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'NSTextView' button"] selectFrom:tableView];
//    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:buttonB]];
//    
//    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent tableView"] selectFrom:tableView];
//    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:tableView]];
//    
//    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent tableView view marked:'cell A'"] selectFrom:tableView];
//    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:subviewA]];
//#endif
//}
//
//@end
