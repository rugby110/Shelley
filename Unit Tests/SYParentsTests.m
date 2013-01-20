//
//  SYParentsTests.m
//  Shelley
//
//  Created by Pete Hodgson on 7/22/11.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "SYParentsTests.h"

#import "SYParents.h"


@implementation SYParentsTests


- (void)testReturnsAllAncestors {
    ShelleyTestView *view = [[[ShelleyTestView alloc] init] autorelease];
    ShelleyTestView *viewA = [[[ShelleyTestView alloc] init] autorelease];
    
#if TARGET_OS_IPHONE
    ShelleyTestView *viewAA = [[[UIButton alloc] init] autorelease];
#else
    ShelleyTestView *viewAA = [[[NSButton alloc] init] autorelease];
#endif
    
    ShelleyTestView *viewAB = [[[ShelleyTestView alloc] init] autorelease];
    ShelleyTestView *viewABA = [[[ShelleyTestView alloc] init] autorelease];
    
    #if TARGET_OS_IPHONE
    ShelleyTestView *viewB = [[[UIButton alloc] init] autorelease];
#else
    ShelleyTestView *viewB = [[[NSButton alloc] init] autorelease];
#endif
    
    ShelleyTestView *viewBA = [[[ShelleyTestView alloc] init] autorelease];
    ShelleyTestView *viewC = [[[ShelleyTestView alloc] init] autorelease];
    
    [view addSubview:viewA];
    [viewA addSubview:viewAA];
    [viewA addSubview:viewAB];
    [viewAB addSubview:viewABA];
    
    [view addSubview:viewB]; 
    [viewB addSubview:viewBA];
    
    [view addSubview:viewC];
    
    SYParents *filter = [[[SYParents alloc] init]autorelease];
    
    NSArray *filteredViews = [filter applyToView:viewABA];
    STAssertEquals((NSUInteger)3, [filteredViews count], nil);
    [self assertArray:filteredViews containsObject:viewAB];
    [self assertArray:filteredViews containsObject:viewA];
    [self assertArray:filteredViews containsObject:view];
}

@end
