//
//  Copyright (c) 2012 feedtailor Inc. All rights reserved.
//

#import "FTCRC.h"

/* Table of CRCs of all 8-bit messages. */
static unsigned long ft_crc_table[256];

/* Flag: has the table been computed? Initially false. */
static int ft_crc_table_computed = 0;

/* Make the table for a fast CRC. */
static void ft_make_crc_table(void)
{
	unsigned long c;
	int n, k;
	for (n = 0; n < 256; n++) {
		c = (unsigned long) n;
		for (k = 0; k < 8; k++) {
			if (c & 1) {
				c = 0xedb88320L ^ (c >> 1);
			} else {
				c = c >> 1;
			}
		}
		ft_crc_table[n] = c;
	}
	ft_crc_table_computed = 1;
}

/*
 Update a running crc with the bytes buf[0..len-1] and return
 the updated crc. The crc should be initialized to zero. Pre- and
 post-conditioning (one's complement) is performed within this
 function so it shouldn't be done by the caller. Usage example:
 
 unsigned long crc = 0L;
 
 while (read_buffer(buffer, length) != EOF) {
 crc = update_crc(crc, buffer, length);
 }
 if (crc != original_crc) error();
 */
static unsigned long ft_update_crc(unsigned long crc,
								unsigned char *buf, int len)
{
	unsigned long c = crc ^ 0xffffffffL;
	int n;
	
	if (!ft_crc_table_computed)
		ft_make_crc_table();
	for (n = 0; n < len; n++) {
		c = ft_crc_table[(c ^ buf[n]) & 0xff] ^ (c >> 8);
	}
	return c ^ 0xffffffffL;
}

@implementation FTCRC

@synthesize CRC;

-(id) init
{
	self = [super init];
	if (self) {
		self.CRC = 0L;
	}
	return self;
}

-(void) updateWithData:(NSData*)data
{
	self.CRC = ft_update_crc(self.CRC, (unsigned char*)[data bytes], [data length]);
}

-(void) clear
{
	self.CRC = 0L;
}

@end

@implementation NSData (NSDataCRC)

-(UInt32) ft_CRC
{
	return ft_update_crc(0L, (unsigned char*)[self bytes], [self length]);
}

@end
