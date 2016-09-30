@import Foundation;
@import XCTest;

#define ShelleyTestObject    UIView
#define ShelleyTestView      UIView
#define ShelleyTestButton    UIButton
#define ShelleyTestTableView UITableView
#define ShelleyTestTableCell UITableViewCell

@interface XCTestCase(Extensions)

- (void)assertArray:(NSArray *)array containsObjects:(NSArray *)objects;
- (void)assertArray:(NSArray *)array containsExactlyObjects:(NSArray *)objects;
- (void)assertArray:(NSArray *)array containsObject:(id)object;

@end
