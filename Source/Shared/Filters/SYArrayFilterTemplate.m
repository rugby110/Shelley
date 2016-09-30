#import "SYArrayFilterTemplate.h"

@implementation SYArrayFilterTemplate

- (NSArray *)applyToView:(ShelleyView *)view
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSArray *)applyToViews:(NSArray *)views
{
    NSMutableArray *filteredViews = [NSMutableArray array];
    for (ShelleyView *view in views) {
        [filteredViews addObjectsFromArray:[self applyToView:view]];
    }    
    return filteredViews;
}

- (void)setDoNotDescend:(BOOL)doNotDescend {
}

- (BOOL) nextFilterShouldNotDescend {
    return NO;
}

@end
