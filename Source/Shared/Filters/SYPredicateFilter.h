#import <Foundation/Foundation.h>
#import "SYArrayFilterTemplate.h"

@interface SYPredicateFilter : SYArrayFilterTemplate {
    SEL _selector;
    NSArray *_args;
    
}
@property (readonly) SEL selector;
@property (readonly) NSArray *args;

- (id)initWithSelector:(SEL)selector args:(NSArray *)args;

@end
