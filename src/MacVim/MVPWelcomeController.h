//
//  WelcomeController.h
//  MacVim
//
//  Created by Doug on 12/15/17.
//

#import <Cocoa/Cocoa.h>

@interface MVPWelcomeController : NSWindowController<NSTableViewDelegate, NSTableViewDataSource> 

@property (assign) IBOutlet NSButton *newProjectButton;
@property (assign) IBOutlet NSView *titleView;
@property (assign) IBOutlet NSTableView *recentProjectsTableView;
@property (nonatomic,retain) NSArray *recentProjects;
@property (nonatomic,retain) NSImage *folderImage;
@property (nonatomic,retain) NSButton *closeButton;

- (void)show;
- (IBAction)newProject:(id)sender;

@end
