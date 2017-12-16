//
//  WelcomeController.m
//  MacVim
//
//  Created by Doug on 12/15/17.
//

#import "MVPWelcomeController.h"
#import "MVPProject.h"
#import "MMAppController.h"

@interface MVPWelcomeController ()

@end

@implementation MVPWelcomeController

- (id) init {
    self = [super initWithWindowNibName:@"WelcomeController"];
    self.recentProjects = [MVPProject recentProjects];

    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    recentProjectsTableView.doubleAction = @selector(projectSelected:);
    recentProjectsTableView.target = self;
    recentProjectsTableView.rowHeight = 40;
//    recentProjectsTableView.intercellSpacing = NSMakeSize(0,0);
    self.window.backgroundColor = [NSColor whiteColor];
}

- (void)show {
    [self.window makeKeyAndOrderFront:self];
    [self.window makeFirstResponder:recentProjectsTableView];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.recentProjects count];
}

- (void)projectSelected:(id)sender
{
    NSString *projectPath = [self.recentProjects objectAtIndex:recentProjectsTableView.clickedRow];
    [[MMAppController sharedInstance] openProjectAtPath:projectPath];
    [self close];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *fullPath = [self.recentProjects objectAtIndex:row];
    return [[fullPath stringByDeletingLastPathComponent] stringByAbbreviatingWithTildeInPath];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTextField *result = [tableView makeViewWithIdentifier:@"RecentProjectView" owner:self];

    if (result == nil) {
        NSRect f = recentProjectsTableView.frame;
        result = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, f.size.width, 40)];
        result.identifier = @"RecentProjectView";
    }
    NSString *fullPath = [self.recentProjects objectAtIndex:row];
    result.stringValue = [[fullPath stringByDeletingLastPathComponent] stringByAbbreviatingWithTildeInPath];
    result.backgroundColor = recentProjectsTableView.backgroundColor;
    result.bezeled = NO;
    return result;
    
}

@end
