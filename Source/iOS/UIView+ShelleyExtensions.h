#import <Foundation/Foundation.h>

@interface ShelleyCategoryLoader : NSObject

- (BOOL)marked:(NSString *)targetLabel;
- (BOOL)markedExactly:(NSString *)targetLabel;
- (BOOL)isAnimating;
- (BOOL)isNotAnimating;

@end
