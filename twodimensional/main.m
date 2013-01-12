//  Created by Adriaan Tijsseling on 01/10/13.

#import <Foundation/Foundation.h>
#import "NSMutableArray+Twodimensional.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool {
	    NSMutableArray *m = [[NSMutableArray alloc] initWithColumns:4 rows:3 type:@"NSNull"];
	    NSLog(@"%@", [m description]);
		[m setObject:@"bar" column:2 row:1];
		[m setObject:@"foo" column:5 row:3];
	    NSLog(@"%@", [m description]);
		NSMutableArray *t = [m transposed];
		NSLog(@"%@", [t description]);
	}
    return 0;
}
