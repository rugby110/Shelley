#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define ShelleyView UIView

@class SYParser;

@interface Shelley : NSObject {
    SYParser *_parser;
}

+ (Shelley *) withSelectorString:(NSString *)selectorString;
- (id)initWithSelectorString:(NSString *)selectorString;
- (NSArray *) selectFrom:(ShelleyView *)rootView;
- (NSArray *) selectFromViews:(NSArray *)views;

@end
