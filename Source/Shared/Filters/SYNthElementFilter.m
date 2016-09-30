#import "SYNthElementFilter.h"

@interface SYNthElementFilter ()
@property (nonatomic) NSUInteger index;
@end

@implementation SYNthElementFilter

- (id)initWithIndex:(NSUInteger)index
{
    self = [super init];
    _index = index;
    return self;
}

- (NSArray *)applyToViews:(NSArray *)views
{
    if( [views count] > _index )
        return [NSArray arrayWithObject:[views objectAtIndex:_index]];
    else
        return [NSArray array];
}

- (void)setDoNotDescend:(BOOL)doNotDescend
{
    // ignored
}

- (BOOL) nextFilterShouldNotDescend
{
    return NO;
}

@end
