#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "XCTestCase+Extensions.h"
#import "SYParents.h"

@interface SYParentsTests: XCTestCase
@end

@implementation SYParentsTests

- (void)testReturnsAllAncestors {
    ShelleyTestView *view = [[ShelleyTestView alloc] init];
    ShelleyTestView *viewA = [[ShelleyTestView alloc] init];

    ShelleyTestView *viewAA = [[UIButton alloc] init];
    ShelleyTestView *viewAB = [[ShelleyTestView alloc] init];
    ShelleyTestView *viewABA = [[ShelleyTestView alloc] init];

    ShelleyTestView *viewB = [[UIButton alloc] init];
    ShelleyTestView *viewBA = [[ShelleyTestView alloc] init];
    ShelleyTestView *viewC = [[ShelleyTestView alloc] init];

    [view addSubview:viewA];
    [viewA addSubview:viewAA];
    [viewA addSubview:viewAB];
    [viewAB addSubview:viewABA];
    [view addSubview:viewB];
    [viewB addSubview:viewBA];
    [view addSubview:viewC];
    SYParents *filter = [[SYParents alloc] init];
    NSArray *filteredViews = [filter applyToView:viewABA];
    XCTAssertEqual((NSUInteger)3, [filteredViews count]);
    [self assertArray:filteredViews containsObject:viewAB];
    [self assertArray:filteredViews containsObject:viewA];
    [self assertArray:filteredViews containsObject:view];
}

@end
