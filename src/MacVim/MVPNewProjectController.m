//
//  NewProjectController.m
//  MacVim
//
//  Created by Doug Fales on 3/27/10.
//  MacVimProject (MVP) by Doug Fales, 2010
//

#import "MVPNewProjectController.h"
#import "MMWindowController.h"
#import "MMAppController.h"
#import "MVPProject.h"

@interface MVPNewProjectController ()

- (NSString *)selectedName;
- (NSString *)selectedRoot;
- (NSString *)selectedIgnorePatterns;
- (void)checkEnableCreateButton;

@end

@implementation MVPNewProjectController

@synthesize windowController;

- (id) init {
	self = [super initWithWindowNibName:@"MVPNewProjectWindow"];
	return self;
}

- (void)dealloc {
	[windowController release]; windowController = nil;
	[super dealloc];
}

- (void)showNewProjectWindow {
    [self.window center];
    [self showWindow:nil];
    [self.window makeKeyAndOrderFront:self];
}

- (IBAction)createProject:(id)sender {
    NSString *projectPath = [self selectedRoot];
	MVPProject *project = [[MVPProject alloc] initWithRoot:projectPath andName:[self selectedName] andIgnorePatterns:[self selectedIgnorePatterns]];
	[self.windowController setProject:project];
    [MVPProject noticeRecentProject:[project pathToProjectFile]];
    [[MMAppController sharedInstance] updateRecentProjects];
	[self close];
}

- (IBAction)cancel:(id)sender {
	[self close];
}

- (IBAction)chooseRoot:(id)sender {	
    NSOpenPanel *panel = [NSOpenPanel openPanel];        
    [panel setFloatingPanel:YES];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
	int i = [panel runModal];
	if(i == NSModalResponseOK){
		NSURL *url = [[panel URLs] objectAtIndex:0];
		[rootPathLabel setStringValue:[url path]];
        self.projectName = [NSString stringWithFormat:@"%@", url.pathComponents.lastObject];
        // Maybe we should hide these files with a . prefix?
        // projectName = [NSString stringWithFormat:@".%@", url.pathComponents.lastObject];
        self.projectName = [_projectName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	}
	[self checkEnableCreateButton];    
}

- (void)checkEnableCreateButton {
	if([[self selectedName] length] > 0 && [[self selectedRoot] length] > 0) {
		[createButton setEnabled:YES];
	} else {
		[createButton setEnabled:NO];
	}
}

- (void)controlTextDidChange:(NSNotification *)aNotification{
	[self checkEnableCreateButton];
}

- (NSString *)selectedName {
    return _projectName;
}

- (NSString *)selectedRoot {
	NSString *rootPath = [[rootPathLabel stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return [rootPath stringByReplacingOccurrencesOfString:@"None selected" withString:@""];
}

- (NSString *)selectedIgnorePatterns {
	return [[ignorePatternsTextField stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
