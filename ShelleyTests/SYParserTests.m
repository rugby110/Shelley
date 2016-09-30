#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "SYParser.h"
#import "SYParents.h"
#import "SYPredicateFilter.h"
#import "SYClassFilter.h"
#import "SYNthElementFilter.h"
#import "XCTestCase+Extensions.h"

@interface SYParserTests: XCTestCase; @end

@implementation SYParserTests

- (void) testViewSelectorYieldsAClassFilter{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"view"];
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYClassFilter class]]);
    XCTAssertEqual([(SYClassFilter *)filter target], [ShelleyTestObject class]);
    filter = [parser nextFilter];
    XCTAssertNil( filter);
}

- (void) testParentSelectorYieldsASingleParentsOperator{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"parent"];
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYParents class]]);
    filter = [parser nextFilter];
    XCTAssertNil( filter);
}

- (void) testInvalidSelectorEventuallyCausesParserToBomb{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"view invalid-string"];
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertNotNil(filter);
    XCTAssertThrows([parser nextFilter] && [parser nextFilter]);
}

- (void) testNoArgPredicateSelectorParses
{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"noArgMethod"];
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYPredicateFilter class]]);
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    XCTAssertEqual([predicateFilter selector], @selector(noArgMethod));
    XCTAssertEqual([[predicateFilter args] count], (NSUInteger)0);
    
}

- (void) testSingleArgPredicateSelectorParses
{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"singleArg:123"];
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYPredicateFilter class]]);
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    XCTAssertEqual([predicateFilter selector], @selector(singleArg:));
    XCTAssertEqual([[predicateFilter args] count], (NSUInteger)1);
    NSNumber *firstArg = [[predicateFilter args] objectAtIndex:0];
    XCTAssertTrue([firstArg isEqualToNumber:[NSNumber numberWithInt:123]]);
}

- (void) testMultiArgPredicateSelectorParses
{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"argOne:123argTwo:'foo'argThree:789"];
    
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYPredicateFilter class]]);
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    XCTAssertEqual([predicateFilter selector], @selector(argOne:argTwo:argThree:));
    XCTAssertEqual([[predicateFilter args] count], (NSUInteger)3);
    NSNumber *firstArg = [[predicateFilter args] objectAtIndex:0];
    XCTAssertTrue( [firstArg isEqualToNumber:[NSNumber numberWithInt:123]]);
    NSString *secondArg = [[predicateFilter args] objectAtIndex:1];
    XCTAssertTrue( [secondArg isEqualToString:@"foo"]);
    NSNumber *thirdArg = [[predicateFilter args] objectAtIndex:2];
    XCTAssertTrue( [thirdArg isEqualToNumber:[NSNumber numberWithInt:789]]);
}

- (void) testParsesSingleQuoteStringArguments
{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"foo:'xyz'"];
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYPredicateFilter class]]);
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    XCTAssertEqual([predicateFilter selector], @selector(foo:));
    XCTAssertEqual([[predicateFilter args] count], (NSUInteger)1);
    XCTAssertTrue([[[predicateFilter args] objectAtIndex:0] isEqualToString:@"xyz"]);
}

- (void) testParsesDoubleQuoteStringArguments {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"foo:\"xyz\""];
    id<SYFilter> filter = [parser nextFilter];
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    XCTAssertEqual([predicateFilter selector], @selector(foo:));
    XCTAssertEqual([[predicateFilter args] count], (NSUInteger)1);
    XCTAssertTrue([[[predicateFilter args] objectAtIndex:0] isEqualToString:@"xyz"]);
}

- (void) testParsesQuotedStringsContainingSpaces {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"foo:'string with spaces'"];
    id<SYFilter> filter = [parser nextFilter];
    SYPredicateFilter *predicateFilter = (SYPredicateFilter *)filter;
    XCTAssertEqual([[predicateFilter args] count], (NSUInteger)1);
    XCTAssertTrue([[[predicateFilter args] objectAtIndex:0] isEqualToString:@"string with spaces"]);
    
}

- (void) testButtonShorthandClassSelectorParses {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"button"];
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYClassFilter class]]);
    XCTAssertEqual([(SYClassFilter *)filter target], [UIButton class]);
}

#if TARGET_OS_IPHONE
- (void) testMiscellaneousShorthandClassSelectorParses {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"navigationButton"];
    
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYClassFilter class]]);
    XCTAssertNotNil([(SYClassFilter *)filter target]);
    XCTAssertEqual([(SYClassFilter *)filter target], NSClassFromString(@"UINavigationButton"));
    parser = [[SYParser alloc] initWithSelectorString:@"navigationItemView"];
    filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYClassFilter class]]);
    XCTAssertNotNil([(SYClassFilter *)filter target]);
    XCTAssertEqual([(SYClassFilter *)filter target], NSClassFromString(@"UINavigationItemView"));
    parser = [[SYParser alloc] initWithSelectorString:@"alertView"];
    filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYClassFilter class]]);
    XCTAssertNotNil([(SYClassFilter *)filter target]);
    XCTAssertEqual([(SYClassFilter *)filter target], [UIAlertView class]);
}
#endif


- (void) testFirstSelectorParses
{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"first"];
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYNthElementFilter class]]);
    XCTAssertEqual( [(SYNthElementFilter *)filter index], (NSUInteger)0);
}

- (void) testIndexSelectorParses
{
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"index:124"];
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYNthElementFilter class]]);
    XCTAssertEqual( [(SYNthElementFilter *)filter index], (NSUInteger)124);
    
}


- (void) testExplicitClassSelectorParses {
    SYParser *parser = [[SYParser alloc] initWithSelectorString:@"view:'UITextView' somePredicate:'method'"];
    id<SYFilter> filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYClassFilter class]]);
    XCTAssertEqual([(SYClassFilter *)filter target], [UITextView class]);
    filter = [parser nextFilter];
    XCTAssertTrue([filter isKindOfClass:[SYPredicateFilter class]]);
    filter = [parser nextFilter];
    XCTAssertNil(filter);
}

@end
