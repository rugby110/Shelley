#import <Foundation/Foundation.h>
#import "SYFilter.h"

@interface SYParser : NSObject

@property (nonatomic, readonly) NSScanner *scanner;
@property (nonatomic, readonly) NSCharacterSet *paramChars;
@property (nonatomic, readonly) NSCharacterSet *numberChars;
@property (nonatomic, readonly) NSMutableArray *currentParams;
@property (nonatomic, readonly) NSMutableArray *currentArgs;

- (id)initWithSelectorString:(NSString *)selectorString;
- (id<SYFilter>)nextFilter;

@end
