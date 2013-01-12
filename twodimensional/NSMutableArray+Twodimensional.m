#import "NSMutableArray+Multidimension.h"

@implementation NSMutableArray (Multidimension)


- (id)initWithColumns:(NSUInteger)cols rows:(NSUInteger)rows
{
	self = [self initWithCapacity:cols];
	if (self) {
	    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
        for (NSUInteger j = 0; j < rows; j++) {
            [rowArray addObject:[NSNull null]];
        }
        [self addObject:rowArray];
	}
    return self;
}


- (id)objectAtColumn:(NSUInteger)col row:(NSUInteger)row
{
    if (col >= [self numColumns]) {
		NSString *str = [[NSString alloc] initWithFormat:
			@"*** -[NSMutableArray objectAtColumn:row:]: column (%ld) beyond bounds (%ld)", col, [self numColumns]];
        [[NSException exceptionWithName:NSRangeException reason:str userInfo:nil] raise];
    }
    if (row >= [self numRows]) {
		NSString *str = [[NSString alloc] initWithFormat:
			@"*** -[NSMutableArray objectAtColumn:row:]: row (%ld) beyond bounds (%ld)", row, [self numRows]];
        [[NSException exceptionWithName:NSRangeException reason:str userInfo:nil] raise];
    }
    
    NSMutableArray *rowArray = [self objectAtIndex:col];
    return [rowArray objectAtIndex:row];
}


- (void)setObject:(id)obj column:(NSUInteger)col row:(NSUInteger)row
{
	while (self.count <= col) {
        [self addObject:NSMutableArray.new];
    }
	
    NSMutableArray *rowArray = [self objectAtIndex:col];
	while (rowArray.count <= row) {
        [rowArray addObject:[NSNull null]];
    }
    [rowArray replaceObjectAtIndex:row withObject:obj];
}


- (NSUInteger)numColumns
{
    return self.count;
}


- (NSUInteger)numRows
{
    NSMutableArray *rowArray = [self objectAtIndex:0];
    return rowArray.count;
}

@end