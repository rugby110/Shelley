#import <Foundation/Foundation.h>
#import "SYFilter.h"

@interface SYParser : NSObject {
    NSScanner *_scanner;
    NSCharacterSet *_paramChars;
    NSCharacterSet *_numberChars;
    NSMutableArray *_currentParams;
    NSMutableArray *_currentArgs;
}

- (id)initWithSelectorString:(NSString *)selectorString;
- (id<SYFilter>)nextFilter;

@end
