//
//  WelcomeController.h
//  MacVim
//
//  Created by Doug on 12/15/17.
//

#import <Cocoa/Cocoa.h>

@interface MVPWelcomeController : NSWindowController<NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet NSTableView *recentProjectsTableView;
}

@property (nonatomic,retain) NSArray *recentProjects;

- (void)show;

@end
