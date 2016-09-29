#import "SYFrankSelectorEngine.h"
#import "Shelley.h"

#define xstr(s) str(s)
#define str(s) #s
#define VERSIONED_NAME "Shelley " xstr(SHELLEY_PRODUCT_VERSION)
const unsigned char what_string[] = "@(#)" VERSIONED_NAME "\n";

static NSString *const registeredName = @"shelley_compat";

@implementation SYFrankSelectorEngine

+ (void)load
{
    SYFrankSelectorEngine *registeredInstance = [[self alloc]init];
    [SelectorEngineRegistry registerSelectorEngine:registeredInstance WithName:registeredName];
    NSLog(@"%s registered with Frank as selector engine named '%@'", VERSIONED_NAME, registeredName);
}

- (NSArray *)selectViewsWithSelector:(NSString *)selector
{
    NSLog( @"Using %s to select views with selector: %@", VERSIONED_NAME, selector );
    
    Shelley *shelley = [Shelley withSelectorString:selector];
    return [shelley selectFromViews:[[UIApplication sharedApplication] windows]];
}

@end
