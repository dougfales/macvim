//
//  RecentProjectCellView.h
//  MacVim
//
//  Created by Doug on 12/16/17.
//

#import <Cocoa/Cocoa.h>

@interface RecentProjectCellView : NSTableCellView

@property (assign) IBOutlet NSTextField *projectName;
@property (assign) IBOutlet NSTextField *projectPath;
@property (assign) IBOutlet NSTextField *projectStats;
@property (assign) IBOutlet NSImageView *icon;

@end
