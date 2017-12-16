//
//  WelcomeController.m
//  MacVim
//
//  Created by Doug on 12/15/17.
//

#import "MVPWelcomeController.h"
#import "MVPProject.h"
#import "MMAppController.h"
#import "RecentProjectCellView.h"

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
    _recentProjectsTableView.doubleAction = @selector(projectSelected:);
    _recentProjectsTableView.target = self;
    _recentProjectsTableView.rowHeight = 40;
//    recentProjectsTableView.intercellSpacing = NSMakeSize(0,0);
    self.window.backgroundColor = [NSColor whiteColor];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowCloseButton] setHidden:YES];
    // Consider this approach: https://stackoverflow.com/a/22099377/3612845
    self.folderImage = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericFolderIcon)];
    [_folderImage setSize:NSMakeSize(32,32)];
    [self addCloseButton];
    [_recentProjectsTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
//    NSAttributedString *newProjectTitle = [[NSAttributedString alloc] initWithString:_newProjectButton.title attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor colorWithRed:75.0/255.0f green:180/255.0f blue:75/255.0f alpha:1], NSForegroundColorAttributeName, nil]];
//    [self.newProjectButton setAttributedTitle:newProjectTitle];
}

- (void)addCloseButton {
    self.closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
    _closeButton.bezelStyle = NSBezelStyleCircular;
    _closeButton.bordered = NO;
    _closeButton.title = @"";
    _closeButton.image = [NSImage imageNamed:NSImageNameStopProgressFreestandingTemplate];
    _closeButton.alphaValue = 0.4;
    NSButtonCell *cell = _closeButton.cell;
    cell.imageScaling = NSImageScaleProportionallyDown;
    cell.backgroundColor = [NSColor clearColor];
    _closeButton.frame = NSMakeRect(5, self.titleView.frame.size.height - 20, 16, 16);
    _closeButton.target = self;
    _closeButton.action = @selector(close);
    _closeButton.hidden = YES;
    [self.titleView addSubview:_closeButton];
    [self setupTrackingArea];
}
- (void)setupTrackingArea
{
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:_titleView.frame
                                            options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInActiveApp)
                                              owner:self userInfo:nil];
    [_titleView addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _closeButton.hidden = NO;
}

- (void)mouseExited:(NSEvent *)theEvent {
    _closeButton.hidden = YES;
}

- (void)show {
    [self.window makeKeyAndOrderFront:self];
    [self.window makeFirstResponder:_recentProjectsTableView];
}

- (IBAction)newProject:(id)sender
{
    [[MMAppController sharedInstance] newProjectForTopmostVimController:self];
    [self close];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.recentProjects count];
}

- (void)projectSelected:(id)sender
{
    NSString *projectPath = [self.recentProjects objectAtIndex:_recentProjectsTableView.clickedRow];
    [[MMAppController sharedInstance] openProjectAtPath:projectPath];
    [self close];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *fullPath = [self.recentProjects objectAtIndex:row];
    return [[fullPath stringByDeletingLastPathComponent] stringByAbbreviatingWithTildeInPath];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    RecentProjectCellView *rpCellView = [tableView makeViewWithIdentifier:@"RecentProjectCellView" owner:self];
    NSString *fullPath = [self.recentProjects objectAtIndex:row];
    rpCellView.projectName.stringValue = [[fullPath lastPathComponent] stringByDeletingPathExtension];
    rpCellView.projectPath.stringValue = [[fullPath stringByDeletingLastPathComponent] stringByAbbreviatingWithTildeInPath];
    rpCellView.icon.image = self.folderImage;
    return rpCellView;
}

@end
