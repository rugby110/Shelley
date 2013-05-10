//
//  SYParents.m
//  Shelley
//
//  Created by Pete Hodgson on 7/20/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYParents.h"


@implementation SYParents

-(NSArray *)applyToView:(ShelleyView *)view{
    NSMutableArray *ancestors = [NSMutableArray array];
    
#if TARGET_OS_IPHONE
    ShelleyView *currentView = view;
    
    while(( currentView = [currentView superview] )){
        [ancestors addObject:currentView];
    }
#else
    id currentView = view;
    
    while (currentView != nil) {
        if ([currentView isKindOfClass: [NSApplication class]]) {
            currentView = nil;
        }
        else if ([currentView isKindOfClass: [NSWindow class]]) {
            currentView = [NSApplication sharedApplication];
        }
        else if ([currentView isKindOfClass: [NSMenuItem class]]) {
            currentView = [((NSMenuItem*) currentView) parentItem];
            
            if (currentView == nil) {
                currentView = [NSApplication sharedApplication];
            }
        }
        else if ([currentView isKindOfClass: [NSView class]]) {
            currentView = [((NSView*) currentView) superview];
            
            if (currentView == nil) {
                currentView = [((NSView*) currentView) window];
            }
        }
        
        if (currentView != nil) {
            [ancestors addObject: currentView];
        }
    }
    
#endif
    
    return ancestors;
}

- (BOOL) nextFilterShouldNotDescend {
    return YES;
}

@end
