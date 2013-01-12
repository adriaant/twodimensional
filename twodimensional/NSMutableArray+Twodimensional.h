#import <Foundation/Foundation.h>

@interface NSMutableArray (Twodimensional)

- (id)initWithColumns:(NSUInteger)cols rows:(NSUInteger)rows type:(NSString*)className;
- (id)initWithColumns:(NSUInteger)cols rows:(NSUInteger)rows;
- (void)expandToColumns:(NSUInteger)cols rows:(NSUInteger)rows;
- (id)objectAtColumn:(NSUInteger)col row:(NSUInteger)row;
- (void)setObject:(id)obj column:(NSUInteger)col row:(NSUInteger)row;
- (NSMutableArray*)transposed;
- (NSUInteger)numColumns;
- (NSUInteger)numRows;

@end
