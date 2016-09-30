#import <Foundation/Foundation.h>
#import "SYFilter.h"

@interface SYNthElementFilter : NSObject<SYFilter>

@property (readonly) NSUInteger index;

- (id)initWithIndex:(NSUInteger)index;

@end
