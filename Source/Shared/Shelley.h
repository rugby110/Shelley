#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define ShelleyView UIView
#import "UIView+ShelleyExtensions.h"

@class SYParser;

@interface Shelley : NSObject

@property (nonatomic, readonly) SYParser *parser;

+ (Shelley *) withSelectorString:(NSString *)selectorString;
- (id)initWithSelectorString:(NSString *)selectorString;
- (NSArray *) selectFrom:(ShelleyView *)rootView;
- (NSArray *) selectFromViews:(NSArray *)views;

@end
