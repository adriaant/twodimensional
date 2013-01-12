#import <objc/runtime.h>
#import "NSMutableArray+Twodimensional.h"

@implementation NSMutableArray (Twodimensional)

static char defaultKey;  // used for runtime property creation


// Shortcut method to create matrix with all NSNull objects
- (id)initWithColumns:(NSUInteger)cols rows:(NSUInteger)rows
{
	return [self initWithColumns:cols rows:rows type:@"NSNull"];
}

// Create a matrix and initialize with instances from the given class name.
// The class given must respond to new or init, so it cannot be an NSNumber.
// Of course you could sublcass NSNumber and override the init method.
- (id)initWithColumns:(NSUInteger)cols rows:(NSUInteger)rows type:(NSString*)className
{
	Class arrayClass = NSClassFromString(className);

	self = [self initWithCapacity:cols];
	if (self) {
		// Store the classname as a runtime property of NSMutableArray. We do this
		// so we don't have to subclass NSMutableArray
		objc_setAssociatedObject(self, &defaultKey, className, OBJC_ASSOCIATION_RETAIN);

		for (NSUInteger i = 0; i < cols; i++) {
			NSMutableArray *rowArray = [[NSMutableArray alloc] initWithCapacity:rows];
			for (NSUInteger j = 0; j < rows; j++) {
				[rowArray addObject:arrayClass.new];
			}
			[self addObject:rowArray];
		}
	}
    return self;
}


// Return the object found at a given index pair. Throws exception if
// indices are out of bounds.
- (id)objectAtColumn:(NSUInteger)col row:(NSUInteger)row
{
    if (col >= self.numColumns) {
		NSString *str = [[NSString alloc] initWithFormat:
			@"*** -[NSMutableArray objectAtColumn:row:]: column (%ld) beyond bounds (%ld)", col, self.numColumns];
        [[NSException exceptionWithName:NSRangeException reason:str userInfo:nil] raise];
    }
    if (row >= self.numRows) {
		NSString *str = [[NSString alloc] initWithFormat:
			@"*** -[NSMutableArray objectAtColumn:row:]: row (%ld) beyond bounds (%ld)", row, self.numRows];
        [[NSException exceptionWithName:NSRangeException reason:str userInfo:nil] raise];
    }
    
    NSMutableArray *rowArray = [self objectAtIndex:col];
    return [rowArray objectAtIndex:row];
}


// Expands the two-dimensional array.
- (void)expandToColumns:(NSUInteger)cols rows:(NSUInteger)rows
{
	// determine default class
	NSString *className = (NSString*)objc_getAssociatedObject(self, &defaultKey);
	Class arrayClass = NSClassFromString(className);

	if (rows > self.numRows) {
		for (NSUInteger i = 0; i < self.numColumns; i++) {
			NSMutableArray *rowArray = [self objectAtIndex:i];
			while (rowArray.count < rows) {
				[rowArray addObject:arrayClass.new];
			}
		}
	}

	while (self.count < cols) {
		NSMutableArray *rowArray = [[NSMutableArray alloc] initWithCapacity:rows];
		for (NSUInteger j = 0; j < rows; j++) {
			[rowArray addObject:arrayClass.new];
		}
		[self addObject:rowArray];
    }
}


// Replace object at given index pair with the object provided.
- (void)setObject:(id)obj column:(NSUInteger)col row:(NSUInteger)row
{
	if (col >= self.numColumns || row >= self.numRows) {
		[self expandToColumns:col+1 rows:row+1];
	}
	
    NSMutableArray *rowArray = [self objectAtIndex:col];
    [rowArray replaceObjectAtIndex:row withObject:obj];
}


// Return a copy of the two-dimensional array, but transposed.
- (NSMutableArray*)transposed
{
	NSMutableArray *transposedArray = [[NSMutableArray alloc] initWithColumns:self.numRows rows:self.numColumns type:@"NSNull"];
	for (NSUInteger i = 0; i < self.numColumns; i++) {
		for (NSUInteger j = 0; j < self.numRows; j++) {
			id obj = [self objectAtColumn:i row:j];
			[transposedArray setObject:obj column:j row:i];
		}
	}
	return transposedArray;
}


// Number of columns.
- (NSUInteger)numColumns
{
    return self.count;
}


// Number of rows.
- (NSUInteger)numRows
{
    NSMutableArray *rowArray = [self objectAtIndex:0];
    return rowArray.count;
}


// Formatted description showing all values in a matrix.
-(NSString *)description
{
	NSMutableString *m = [[NSMutableString alloc] init];
	for (NSUInteger j = 0; j < self.numRows; j++) {
		for (NSUInteger i = 0; i < self.numColumns; i++) {
			id obj = [self objectAtColumn:i row:j];
			[m appendFormat:@"%@ ", [obj description]];
		}
		[m appendString:@"\n"];
	}

	return [[NSString alloc] initWithFormat:@"2D array with %ld columns and %ld rows:\n%@", self.numColumns, self.numRows, m];
}

@end
