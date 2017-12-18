//
//  SearchResult.m
//  MacVim
//
//  Created by Doug Fales on 1/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchResult.h"


@implementation SearchResult

- (id)initWithFile:(NSString *)file andLine:(NSInteger)lineNo andMatch:(NSString *)match andSearchText:(NSString *)search
{
	if((self = [super init])) {
		self.children = [NSMutableArray new];
		self.name = file;
		self.matchLine = match;
		self.lineNumber = lineNo;
		NSRange lastFileSeparator = [self.name rangeOfString:@"/" options:NSBackwardsSearch];
		if(lastFileSeparator.location == NSNotFound) {
			self.basename = self.name;
		} else {
			self.basename = [self.name substringFromIndex:lastFileSeparator.location + 1];
		}

		self.searchText = search;
		
	}	
	return self;
}

- (void)dealloc 
{
	[children release];
	[name release];
	[matchLine release];
	[searchText release];
	[super dealloc];
}

- (NSColor *)textColor:(BOOL)selected {
    return (selected ? [NSColor alternateSelectedControlTextColor] : [NSColor grayColor]);
}
- (NSColor *)searchTextColor:(BOOL)selected {
    return (selected ? [NSColor alternateSelectedControlTextColor] : [NSColor blackColor]);
}

- (NSString *)displayName
{
    if([self.children count] == 0) {
        return [NSString stringWithFormat:@"\t%ld: %@", self.lineNumber, self.matchLine];
    } else {
        return [NSString stringWithFormat:@"%@ -- %@", self.basename, self.name];
    }
}

- (NSAttributedString *)attributedDisplayName:(BOOL)selected
{
    NSString *str = [self displayName];
    if([self.children count] == 0) {
        NSRange searchTextLocation = [str rangeOfString:self.searchText];
        NSDictionary *matchLineAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[self textColor:selected], NSForegroundColorAttributeName,
                                             [NSFont systemFontOfSize:11], NSFontAttributeName, nil];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self displayName] attributes:matchLineAttributes];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[self searchTextColor:selected] range:searchTextLocation];
        [attributedString addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:11] range:searchTextLocation];
        return attributedString;
    }
    return [[NSAttributedString alloc] initWithString:str];
}

@synthesize children;
@synthesize name;
@synthesize basename;
@synthesize matchLine;
@synthesize lineNumber;
@synthesize	searchText;

@end
