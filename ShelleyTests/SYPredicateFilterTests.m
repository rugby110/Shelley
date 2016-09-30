@import Foundation;
@import XCTest;
#import "Shelley.h"
#import "SYPredicateFilter.h"

@interface DummyView: ShelleyView

@property (nonatomic) BOOL methodWasCalled;
@property (nonatomic) BOOL returnValue;

@end

@implementation DummyView

- (instancetype)init
{
    self = [super init];
    _methodWasCalled = NO;
    return self;
}

- (BOOL)dummyMethod
{
    self.methodWasCalled = YES;
    return self.returnValue;
}

@end

@interface SYPredicateFilterTests: XCTestCase
@end

@implementation SYPredicateFilterTests

- (void)testGracefullyHandlesViewNotRespondingToSelector
{
    ShelleyView *view = [[ShelleyView alloc] init];
    SYPredicateFilter *filter = [[SYPredicateFilter alloc] initWithSelector:@selector(notPresent) args:@[]];
    NSArray *filteredViews = [filter applyToView:view];
    XCTAssertNotNil(filteredViews);
    XCTAssertEqual((NSUInteger)0, [filteredViews count]);
}

- (void)testCallsPredicateMethodOnView
{
    DummyView *view = [[DummyView alloc] init];
    SYPredicateFilter *filter = [[SYPredicateFilter alloc] initWithSelector:@selector(dummyMethod) args:@[]];
    XCTAssertFalse([view methodWasCalled]);
    [filter applyToView:view];
    XCTAssertTrue([view methodWasCalled]);
}

- (void) testFiltersOutViewIfPredicateReturnsNO
{
    DummyView *view = [[DummyView alloc] init];
    view.returnValue = NO;
    SYPredicateFilter *filter = [[SYPredicateFilter alloc] initWithSelector:@selector(dummyMethod) args:@[]];
    NSArray *filteredViews = [filter applyToView:view];
    XCTAssertNotNil(filteredViews);
    XCTAssertEqual((NSUInteger)0, [filteredViews count]);
}

- (void) testDoesNotFiltersOutViewIfPredicateReturnsYES{
    DummyView *view = [[DummyView alloc] init];
    view.returnValue = YES;
    SYPredicateFilter *filter = [[SYPredicateFilter alloc] initWithSelector:@selector(dummyMethod) args:[NSArray array]];
    NSArray *filteredViews = [filter applyToView:view];
    XCTAssertNotNil(filteredViews);
    XCTAssertEqual((NSUInteger)1, [filteredViews count]);
    XCTAssertEqual(view, [filteredViews objectAtIndex:0]);
}

@end
