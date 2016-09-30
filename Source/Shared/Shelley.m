#import "Shelley.h"
#import "SYParser.h"

@implementation Shelley

#pragma mark - Init

- (id)initWithSelectorString:(NSString *)selectorString
{
    self = [super init];
    _parser = [[SYParser alloc] initWithSelectorString:selectorString];
    return self;
}

+ (Shelley *)withSelectorString:(NSString *)selectorString
{
    return [[self alloc] initWithSelectorString:selectorString];
}

- (void)removeDuplicatesFromArray:(NSMutableArray *)mutableArray
{
    NSArray *copy = [mutableArray copy];
    NSInteger index = [copy count] - 1;
    for (id object in [copy reverseObjectEnumerator]) {
        if ([mutableArray indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [mutableArray removeObjectAtIndex:index];
        }
        index--;
    }
}

- (NSArray *)applyFilter:(id<SYFilter>)filter toViews:(NSArray *)views
{
    NSMutableArray *filteredViews = [NSMutableArray arrayWithArray:[filter applyToViews:views]];
    [self removeDuplicatesFromArray:filteredViews];
    return filteredViews;
}

- (NSArray *)selectFromViews:(NSArray *)views
{
    id<SYFilter> filter = [_parser nextFilter];
    id<SYFilter> prevFilter = filter;
    if (!filter) {
        return [NSArray array];
    }
    NSArray *filteredViews = [filter applyToViews:views];
    while ((filter = [_parser nextFilter])){
        [filter setDoNotDescend:[prevFilter nextFilterShouldNotDescend]];
        filteredViews = [self applyFilter:filter toViews:filteredViews];
        prevFilter = filter;
    }
    return filteredViews;
}

- (NSArray *)selectFrom:(ShelleyView *)rootView
{
    return [self selectFromViews:[NSArray arrayWithObject:rootView]];
}

@end
