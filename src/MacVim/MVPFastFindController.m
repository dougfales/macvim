//
//  FastFindController.m
//  MacVim
//
//  Created by Doug Fales on 3/28/10.
//  MacVimProject (MVP) by Doug Fales, 2010
//

#import "MVPFastFindController.h"
#import "MVPProject.h"
#import "MMAppController.h"
#import "MMVimController.h"
#import "MVPFastFindCell.h"
#import "MVPFastFindResult.h"

@implementation MVPFastFindController

@synthesize project, query;

- (id) init {
	self = [super initWithWindowNibName:@"MVPFastFind"];
    self.query = [[NSMetadataQuery alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queryNote:)
                                                 name:nil
                                               object:self.query];
    
    NSSortDescriptor *byName = [[NSSortDescriptor alloc]
                                initWithKey:(id)kMDItemFSName
                                ascending:YES];
    
    NSSortDescriptor *byAccess = [[NSSortDescriptor alloc]
                                initWithKey:(id)kMDItemLastUsedDate
                                ascending:NO];
    
    NSSortDescriptor *byMTime = [[NSSortDescriptor alloc]
                                  initWithKey:(id)kMDItemContentModificationDate    
                                  ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:byAccess, byMTime, byName,
                                nil];
    
    [self.query setSortDescriptors:sortDescriptors];
    [self.query setDelegate:self];
	return self;
}

-(void)setProject:(MVPProject *)newProject
{
    if(newProject != self.project)
    {
        [newProject retain];
        [project release];
        project = newProject;
        NSArray *scopes = [NSArray arrayWithObjects:[self.project pathToRoot], nil];
        [self.query setSearchScopes:scopes];
    }
}

-(void)awakeFromNib {
	NSTableColumn *column = [[tableView tableColumns] objectAtIndex:0];
	MVPFastFindCell *fastFindCell = [[[MVPFastFindCell alloc] init] autorelease];
	fastFindCell.fastFindController = self;
	[column setDataCell:fastFindCell];
}
- (void)queryNote:(NSNotification *)note {
    if ([[note name] isEqualToString:NSMetadataQueryDidStartGatheringNotification]) {
        [tableView reloadData];
    } else if ([[note name] isEqualToString:NSMetadataQueryDidFinishGatheringNotification]) {
        [tableView reloadData];
    } else if ([[note name] isEqualToString:NSMetadataQueryGatheringProgressNotification]) {
        // Do nothing. Query still going.
    } else if ([[note name] isEqualToString:NSMetadataQueryDidUpdateNotification]) {
        // TODO: reload data? A file may have appeared, disappeared, etc.
    }
}

- (void)controlTextDidChange:(NSNotification *)obj
{
    [self doSearch];
	[tableView reloadData];
}

- (void)doSearch {
    NSString *searchString = [searchField stringValue];
    NSUInteger options = (NSCaseInsensitivePredicateOption|NSDiacriticInsensitivePredicateOption);
    searchString = [NSString stringWithFormat:@"%@*", searchString];
    NSPredicate *predicateToRun = [NSComparisonPredicate
                             predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"*"]
                             rightExpression:[NSExpression expressionForConstantValue:searchString]
                             modifier:NSDirectPredicateModifier
                             type:NSLikePredicateOperatorType
                             options:options];
    [self.query setPredicate:predicateToRun];
    [self.query startQuery];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [query resultCount];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMetadataItem *item = [query resultAtIndex:row];
    MVPFastFindResult* result = [[MVPFastFindResult alloc] initWithItem:item andProject:self.project];
    return result;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	[self openEntryInTab:[self pathToSelectedItem]];
	[self close];
	return NO;
}

- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector {
	BOOL result = NO;
	
    if (commandSelector == @selector(insertNewline:))
    {
		NSString *firstResult = [self pathAtIndex:0];
		if(firstResult) {
            [self openEntryInTab:firstResult];
			result = YES;
			[self close];
		}
    }
	
	return result;
}

- ( void ) keyDown: ( NSEvent * ) event {
	if ([[self window] firstResponder] == tableView) {
		NSString *keyPresses = [event characters];
		NSRange firstChar = NSMakeRange(0, 1);
		if([keyPresses compare:@"v" options:NSCaseInsensitiveSearch range:firstChar] ==  NSOrderedSame) {
			[self splitOpenWithVertical:YES];
			return;
		} else if( [keyPresses compare:@"s" options:NSCaseInsensitiveSearch range:firstChar] ==  NSOrderedSame) {
			[self splitOpenWithVertical:NO];
			return;
		} else if([keyPresses compare:@"\n" options:NSCaseInsensitiveSearch range:firstChar] ==  NSOrderedSame) {
			return;
		}				  
	} 
	[[self nextResponder] keyDown:event];
}

- (NSString *)pathAtIndex:(NSInteger)i
{
    if(i >= 0 && i < query.resultCount){
        NSMetadataItem *item = [query resultAtIndex:i];
        return [[item valueForAttribute:NSMetadataItemPathKey] stringByEscapingSpecialFilenameCharacters];
    }
    return nil;
}

- (NSString *)pathToSelectedItem {
    return [self pathAtIndex:[tableView selectedRow]];
}

- (void)splitOpenWithVertical:(BOOL)verticalSplit {
    MMVimController *vc = [[MMAppController sharedInstance] topmostVimController];
    NSString *cmd = [NSString stringWithFormat:@"%@ %@<CR>", (verticalSplit ? @":vsp" : @":sp"), [self pathToSelectedItem]];
    [vc addVimInput:cmd];
    [self close];
}

- (void)openEntryInTab:(NSString *)filePath {
    MMVimController *vc = [[MMAppController sharedInstance] topmostVimController];
    NSString *cmd = [NSString stringWithFormat:@":tabedit %@<CR>", filePath];
    [vc addVimInput:cmd];
}

- (NSString *)searchString {
	return [searchField stringValue];
}

- (void)show {
	[self.window makeKeyAndOrderFront:self];
	[self.window makeFirstResponder:searchField];
}

@end
