//
//  IntegrationTests.m
//  Shelley
//
//  Created by Pete Hodgson on 7/17/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "IntegrationTests.h"
#import "Shelley.h"

#if TARGET_OS_IPHONE
#import "UIViewWithAccessibilityLabel.h"
#define UIViewWithAccessibilityLabel UIViewWithAccessibilityLabel
#else
#import "NSViewWithAccessibilityLabel.h"
#define UIViewWithAccessibilityLabel NSViewWithAccessibilityLabel
#endif

@implementation IntegrationTests

- (void) setUp{
    view = [[[ShelleyTestView alloc] init] autorelease];
    viewA = [[[ShelleyTestView alloc] init] autorelease];
    viewAA = [[[ShelleyTestButton alloc] init] autorelease];
    viewAB = [[[ShelleyTestView alloc] init] autorelease];
    viewABA = [[[ShelleyTestView alloc] init] autorelease];
    viewB = [[[ShelleyTestButton alloc] init] autorelease];
    viewBA = [[[ShelleyTestView alloc] init] autorelease];
    viewC = [[[ShelleyTestView alloc] init] autorelease];
    
    [view addSubview:viewA];
    [viewA addSubview:viewAA];
    [viewA addSubview:viewAB];
    [viewAB addSubview:viewABA];
    
    [view addSubview:viewB]; 
    [viewB addSubview:viewBA];
    
    [view addSubview:viewC];
}

- (void) ShelleyTestViewReturnsAllSubviews {
    ShelleyTestView *someView = [[[ShelleyTestView alloc] init] autorelease];
    [someView addSubview:[[[ShelleyTestView alloc] init] autorelease]];
    [someView addSubview:[[[ShelleyTestView alloc] init] autorelease]];
    [someView addSubview:[[[ShelleyTestView alloc] init] autorelease]];
    
    Shelley *shelley = [Shelley withSelectorString:@"view"];
    
    NSArray *selectedViews = [shelley selectFrom:someView];
    
    STAssertEquals(selectedViews.count, someView.subviews.count, nil);
    [self assertArray:selectedViews containsObjects:someView.subviews];
}

- (void) ShelleyTestViewReturnsAllDescendants {
    Shelley *shelley = [Shelley withSelectorString:@"view"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)7, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewA];
    [self assertArray:selectedViews containsObject:viewAA];
    [self assertArray:selectedViews containsObject:viewAB];
    [self assertArray:selectedViews containsObject:viewABA];
    [self assertArray:selectedViews containsObject:viewAB];
    [self assertArray:selectedViews containsObject:viewB];
    [self assertArray:selectedViews containsObject:viewBA];
    [self assertArray:selectedViews containsObject:viewC];
}

- (void) testDescendantReturnsAllDescendantsPlusSelf_ForBackwardsCompatibilityWithUIQuery {
    Shelley *shelley = [Shelley withSelectorString:@"descendant"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)8, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:view];
}

- (void) testButtonReturnsAllDescendantsWhichAreButtons {
    Shelley *shelley = [Shelley withSelectorString:@"button"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)2, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewAA];
    [self assertArray:selectedViews containsObject:viewB];
}

-(void) ShelleyTestViewButtonReturnsAllGrandChildrenWhichAreButtons {
    Shelley *shelley = [Shelley withSelectorString:@"view button"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewAA];
}

-(void) testButtonParentReturnsTheRootView {
    ShelleyTestView *rootView = [[[ShelleyTestView alloc] init] autorelease];
    [rootView addSubview:[[[ShelleyTestButton alloc] init] autorelease]];
    
    Shelley *shelley = [Shelley withSelectorString:@"button parent"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:rootView];
}

- (void) testFirstSelectsFirstViewInMatchSet {
    ShelleyTestView *rootView = [[[ShelleyTestView alloc] init] autorelease];
    ShelleyTestButton *firstButton = [[[ShelleyTestButton alloc] init] autorelease];
    [rootView addSubview:[[[ShelleyTestView alloc] init] autorelease]];
    [rootView addSubview:firstButton];
    [rootView addSubview:[[[ShelleyTestButton alloc] init] autorelease]];
    [rootView addSubview:[[[ShelleyTestView alloc] init] autorelease]];
    
    Shelley *shelley = [Shelley withSelectorString:@"button first"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:firstButton];
}

- (void) testFirstReturnsAnEmptyArrayWhenThereAreNoViewsInMatchSet {
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'I DO NOT EXIST' first"];
    NSArray *selectedViews = [shelley selectFrom:view];
    STAssertEquals((NSUInteger)0, selectedViews.count, nil);
}



- (void) testIndexSelectsNthViewInMatchSet {
    Shelley *shelley = [Shelley withSelectorString:@"button index:1"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewB];

}

- (void) testSelectsOnlyViewsWhichAreHidden {
    [viewA setHidden:YES];
    [viewABA setHidden:YES];
    [viewBA setHidden:YES];
    
    Shelley *shelley = [Shelley withSelectorString:@"view isHidden"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)3, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewA];
    [self assertArray:selectedViews containsObject:viewABA];
    [self assertArray:selectedViews containsObject:viewBA];

}


- (void) testMarkedSelectsOnlyViewsWithMatchingAccessibilityLabel {
    ShelleyTestView *rootView = [[[ShelleyTestView alloc] init]autorelease];
    UIViewWithAccessibilityLabel *subviewA = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"brap"] autorelease];
    UIViewWithAccessibilityLabel *subviewB = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"flap"] autorelease];
    UIViewWithAccessibilityLabel *subviewC = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:nil] autorelease];
    UIViewWithAccessibilityLabel *subviewD = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"brap"] autorelease];
    
    [rootView addSubview:subviewA];
    [rootView addSubview:subviewB];
    [rootView addSubview:subviewC];
    [rootView addSubview:subviewD];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'brap'"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)2, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subviewA];
    [self assertArray:selectedViews containsObject:subviewD];
}

- (void) testMarkedSelectedSubstringMatchesWhileMarkedExactlyOnlySelectsExactMatches {
    ShelleyTestView *rootView = [[[ShelleyTestView alloc] init]autorelease];
    UIViewWithAccessibilityLabel *subviewA = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"Frankly"] autorelease];
    UIViewWithAccessibilityLabel *subviewB = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"rank"] autorelease];
    UIViewWithAccessibilityLabel *subviewC = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"Fr-anky"] autorelease];
    UIViewWithAccessibilityLabel *subviewD = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:nil] autorelease];
    UIViewWithAccessibilityLabel *subviewE = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@" rank"] autorelease];

    [rootView addSubview:subviewA];
    [rootView addSubview:subviewB];
    [rootView addSubview:subviewC];
    [rootView addSubview:subviewD];
    [rootView addSubview:subviewE];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'rank'"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)3, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subviewA];
    [self assertArray:selectedViews containsObject:subviewB];
    [self assertArray:selectedViews containsObject:subviewE];

    shelley = [Shelley withSelectorString:@"view markedExactly:'rank'"];
    selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subviewB];
}

- (void) testHandlesDoubleQuotedstringsWithSingleQuotesAndSpacesInside {
    ShelleyTestView *rootView = [[[ShelleyTestView alloc] init]autorelease];
    UIViewWithAccessibilityLabel *subview = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"I'm selected"] autorelease];
    [rootView addSubview:subview];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:\"I'm selected\""];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subview];
}

- (void) testHandlesSingleQuotesWithDoubleQuotesInside {
    ShelleyTestView *rootView = [[[ShelleyTestView alloc] init]autorelease];
    UIViewWithAccessibilityLabel *subview = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"say \"hi\" now"] autorelease];
    [rootView addSubview:subview];
    
    Shelley *shelley = [Shelley withSelectorString:@"view marked:'say \"hi\" now'"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:subview];
}

- (void) testAppliesFiltersSequentiallyInADepthFirstManner {
    ShelleyTestView *rootView = [[[ShelleyTestView alloc] init]autorelease];

    ShelleyTestButton *buttonA = [[[ShelleyTestButton alloc] init] autorelease];
    ShelleyTestButton *buttonAA = [[[ShelleyTestButton alloc] init] autorelease];
    ShelleyTestView *nonButtonB = [[[ShelleyTestView alloc] init]autorelease];
    ShelleyTestButton *buttonBA = [[[ShelleyTestButton alloc] init] autorelease];
    
    [rootView addSubview:buttonA];
    [buttonA addSubview:buttonAA];
    [rootView addSubview:nonButtonB];
    [nonButtonB addSubview:buttonBA];
    
    Shelley *shelley = [Shelley withSelectorString:@"button button"];
    NSArray *selectedViews = [shelley selectFrom:rootView];
    
    // The only button whose parent is a button is button AA
    STAssertEquals((NSUInteger)1, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:buttonAA];
}

- (void) testWeFilterOutDupes {
    Shelley *shelley = [Shelley withSelectorString:@"button parent descendant button"];
    NSArray *selectedViews = [shelley selectFrom:view];
    
    STAssertEquals((NSUInteger)2, selectedViews.count, nil);
    [self assertArray:selectedViews containsObject:viewAA];
    [self assertArray:selectedViews containsObject:viewB];
}

- (void) testAllowsSelectionOfSiblingsAndCousinsViaParentFilter {
    ShelleyTestTableView *tableView = [[[ShelleyTestTableView alloc] init]autorelease];
    
    ShelleyTestTableCell *cellA = [[[ShelleyTestTableCell alloc] init] autorelease];
    UIViewWithAccessibilityLabel *subviewA = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"cell A"] autorelease];
    ShelleyTestButton *buttonA = [[[ShelleyTestButton alloc] init]autorelease];    
    [cellA addSubview:subviewA];
    [cellA addSubview:buttonA];

    ShelleyTestTableCell *cellB = [[[ShelleyTestTableCell alloc] init] autorelease];
    UIViewWithAccessibilityLabel *subviewB = [[[UIViewWithAccessibilityLabel alloc] initWithAccessibilityLabel:@"cell B"] autorelease];
    ShelleyTestButton *buttonB = [[[ShelleyTestButton alloc] init]autorelease];    
    [cellB addSubview:subviewB];
    [cellB addSubview:buttonB];
    
    [tableView addSubview:cellA];
    [tableView addSubview:cellB];
    
    NSArray *selectedViews = [[Shelley withSelectorString:@"view marked:'cell B'"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:subviewB]];

    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObjects:cellB,tableView,nil]];
    
#if TARGET_OS_IPHONE
    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableViewCell'"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:cellB]];
    
    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableViewCell' button"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:buttonB]];
    
    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableView'"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:tableView]];    

    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'UITableView' view marked:'cell A'"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:subviewA]];
#else
    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'NSTextView'"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:cellB]];
    
    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent view:'NSTextView' button"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:buttonB]];
    
    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent tableView"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:tableView]];
    
    selectedViews = [[Shelley withSelectorString:@"view marked:'cell B' parent tableView view marked:'cell A'"] selectFrom:tableView];
    [self assertArray:selectedViews containsExactlyObjects:[NSArray arrayWithObject:subviewA]];
#endif
}

@end
