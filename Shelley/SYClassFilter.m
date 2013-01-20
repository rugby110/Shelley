//
//  SYClassFilter.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYClassFilter.h"

@implementation SYClassFilter
@synthesize target=_targetClass;

+ (NSArray *) allDescendantsOf:(ShelleyView *)view{
    NSMutableArray *descendants = [NSMutableArray array];
    
#if TARGET_OS_IPHONE
    for (ShelleyView *subview in [view subviews]) {
        [descendants addObject:subview];
        [descendants addObjectsFromArray:[self allDescendantsOf:subview]];
    }
#else
    if ([view isKindOfClass: [NSApplication class]]) {
        for (NSWindow* window in [((NSApplication*) view) windows]) {
            [descendants addObject: window];
            [descendants addObjectsFromArray: [self allDescendantsOf: window]];
        }
        
        [descendants addObjectsFromArray: [self allDescendantsOf: [((NSApplication*) view) menu]]];
    }
    else if ([view isKindOfClass: [NSWindow class]]) {
        [descendants addObject: [((NSWindow*) view) contentView]];
        [descendants addObjectsFromArray: [self allDescendantsOf: [((NSWindow*) view) contentView]]];
    }
    else if ([view isKindOfClass: [NSMenu class]]) {
        for (NSMenuItem* item in [((NSMenu*) view) itemArray]) {
            [descendants addObject: item];
            [descendants addObjectsFromArray: [self allDescendantsOf: item]];
        }
    }
    else if ([view isKindOfClass: [NSMenuItem class]]) {
        for (NSMenuItem* item in [[((NSMenuItem*) view) submenu] itemArray]) {
            [descendants addObject: item];
            [descendants addObjectsFromArray: [self allDescendantsOf: item]];
        }
    }
    else if ([view isKindOfClass: [NSView class]])
    {
        for (NSView *subview in [((NSView*) view) subviews]) {
            [descendants addObject:subview];
            [descendants addObjectsFromArray:[self allDescendantsOf:subview]];
        }
    }
    
#endif
    return descendants;
}

- (id)initWithClass:(Class)class {
#if TARGET_OS_IPHONE
    return [self initWithClass:class includeSelf:NO];
#else
    return [self initWithClass:class includeSelf:YES];
#endif
}

- (id)initWithClass:(Class)class includeSelf:(BOOL)includeSelf {
    self = [super init];
    if (self) {
        _targetClass = class;
		_includeSelf = includeSelf;
        _justFilter = NO;
    }
    return self;
}

- (void)setDoNotDescend:(BOOL)doNotDescend {
    _justFilter = doNotDescend;
}

-(NSArray *)viewsToConsiderFromView:(ShelleyView *)view{
    if( _justFilter )
        return [NSArray arrayWithObject:view];
    
    NSMutableArray *allViews = _includeSelf ? [NSMutableArray arrayWithObject:view] : [NSMutableArray array];
    [allViews addObjectsFromArray:[SYClassFilter allDescendantsOf:view]];
    return allViews;
}


-(NSArray *)applyToView:(ShelleyView *)view{
    NSArray *allViews = [self viewsToConsiderFromView:view];
	
    // TODO: look at using predicates
    NSMutableArray *filteredDescendants = [NSMutableArray array];
    for (ShelleyView *v in allViews) {
        if( [v isKindOfClass:_targetClass] ){
            [filteredDescendants addObject:v];
        }
    }
    
    return filteredDescendants;
}

@end
