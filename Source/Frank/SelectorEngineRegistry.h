#import <Foundation/Foundation.h>

@protocol SelectorEngine <NSObject>

- (NSArray *)selectViewsWithSelector:(NSString *)selector;

@end

@interface SelectorEngineRegistry : NSObject

+ (void)registerSelectorEngine:(id<SelectorEngine>)engine WithName:(NSString *)name;
+ (NSArray *)selectViewsWithEngineNamed:(NSString *)engineName usingSelector:(NSString *)selector;

@end
