#import "XCTestCase+Extensions.h"

@implementation XCTestCase (Extensions)

- (void)assertArray:(NSArray *)array containsObjects:(NSArray *)objects
{
    for (id obj in objects) {
        [self assertArray:array containsObject:obj];
    }
}

- (void)assertArray:(NSArray *)array containsExactlyObjects:(NSArray *)objects
{
    XCTAssertEqual([objects count], [array count]);
    [self assertArray:array containsObjects:objects];
}

- (void)assertArray:(NSArray *)array containsObject:(id)object
{
    XCTAssertTrue([array containsObject:object]);
}

@end
