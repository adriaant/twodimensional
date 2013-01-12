#import <Foundation/Foundation.h>

// based on https://github.com/laprasdrum/MutabledimensionalArray

@interface NSMutableArray (Multidimension)

- (id)initWithColumns:(NSUInteger)cols rows:(NSUInteger)rows;
- (id)objectAtColumn:(NSUInteger)col row:(NSUInteger)row;
- (void)setObject:(id)obj column:(NSUInteger)col row:(NSUInteger)row;
- (NSUInteger)numColumns;
- (NSUInteger)numRows;

@end