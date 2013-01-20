//
//  NSObjectWithAccessibilityLabel.h
//  Shelley
//
//  Created by Buckley on 1/17/13.
//  Copyright (c) 2013 ThoughtWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSViewWithAccessibilityLabel : NSView
{
    NSString* _accessiblityLabel;
}

- (id)initWithAccessibilityLabel:(NSString *)accessibilityLabel;

@end
