@protocol SYFilter <NSObject>

- (void)setDoNotDescend:(BOOL)doNotDescend;
- (NSArray *)applyToViews:(NSArray *)views;
- (BOOL)nextFilterShouldNotDescend;

@end
