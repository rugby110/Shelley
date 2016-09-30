#import <Foundation/Foundation.h>

@protocol SelectorEngine <NSObject>

- (NSArray *)selectViewsWithSelector:(NSString *)selector;

@end

