//
//  NSObjectWithAccessibilityLabel.m
//  Shelley
//
//  Created by Buckley on 1/17/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import "NSViewWithAccessibilityLabel.h"

@implementation NSViewWithAccessibilityLabel

- (id)initWithAccessibilityLabel:(NSString *)accessibilityLabel
{
    if (self = [super init])
    {
        _accessiblityLabel = [accessibilityLabel copy];
    }
    
    return self;
}

- (void) dealloc
{
    [_accessiblityLabel release];
    [super dealloc];
}

- (NSString*) FEX_accessibilityLabel
{
    return _accessiblityLabel;
}

@end
