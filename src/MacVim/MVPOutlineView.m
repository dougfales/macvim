//
//  MVPOutlineView.m
//  MacVim
//
//  Created by Doug on 12/15/17.
//

#import "MVPOutlineView.h"
#import "MMAppController.h"

@implementation MVPOutlineView

// The only reason this subclass exists is so that I can make the ESC key return control to vim.
// It is very annoying to have your keyboard input going to the project tree instead of the buffer.
- (void)keyDown:(NSEvent *)event
{
    if(event.keyCode == 53) {
        [[MMAppController sharedInstance] returnFocusToTopmostVim];
    } else {
        [super keyDown:event];
    }
}

@end
