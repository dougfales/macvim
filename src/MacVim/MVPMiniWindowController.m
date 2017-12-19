//
//  MVPMiniWindowController.m
//  MacVim
//
//  Created by Doug on 12/18/17.
//

#import "MVPMiniWindowController.h"
#import "MVPMiniVimView.h"
#import "MMWindowController.h"
#import "MMAppController.h"
#import "MMTextView.h"
#import "MMTypesetter.h"
#import "MMVimController.h"
#import "MMVimView.h"
#import "MMWindow.h"
#import "MMWindowController.h"
#import "Miscellaneous.h"

@interface MVPMiniWindowController ()

@end

@implementation MVPMiniWindowController

- (void)setupVimView:(NSView *)contentView
{
    vimView = [[MVPMiniVimView alloc] initWithFrame:[contentView frame]
                                 vimController:vimController];
    [vimView setAutoresizingMask:NSViewNotSizable];
}

- (void)setupAsMiniVim

{
    NSRect frame = decoratedWindow.frame;
    frame.size = NSMakeSize(200,700);
    [decoratedWindow setFrame:frame display:YES];
    
}

- (void)processInputQueueDidFinish
{
    // NOTE: Resizing is delayed until after all commands have been processed
    // since it often happens that more than one command will cause a resize.
    // If we were to immediately resize then the vim view size would jitter
    // (e.g.  hiding/showing scrollbars often happens several time in one
    // update).
    // Also delay toggling the toolbar until after scrollbars otherwise
    // problems arise when showing toolbar and scrollbar at the same time, i.e.
    // on "set go+=rT".


    // NOTE: If the window has not been presented then we must avoid resizing
    // the views since it will cause them to be constrained to the screen which
    // has not yet been set!
    if (windowPresented && shouldResizeVimView) {
        shouldResizeVimView = NO;

        // Make sure full-screen window stays maximized (e.g. when scrollbar or
        // tabline is hidden) according to 'fuopt'.

        BOOL didMaximize = NO;
        shouldMaximizeWindow = NO;

        // Resize Vim view and window, but don't do this now if the window was
        // just reszied because this would make the window "jump" unpleasantly.
        // Instead wait for Vim to respond to the resize message and do the
        // resizing then.
        // TODO: What if the resize message fails to make it back?
        if (!didMaximize) {
            //NSSize originalSize = [vimView frame].size;
           // int rows = 0, cols = 0;
            //            NSSize contentSizeOld = [vimView constrainRows:&rows columns:&cols
            //                                                    toSize:
            //                                [self constrainContentSizeToScreenSize:[vimView desiredSize]]];

            NSSize contentSize = NSMakeSize(5000, 5000);
            [vimView setFrameSize:contentSize];


            NSSize fullWindowSize = contentSize;


  //          [self resizeWindowToFitContentSize:fullWindowSize
    //                              keepOnScreen:keepOnScreen];

        }

        keepOnScreen = NO;
    }
}

- (void)resizeWindowToFitContentSize:(NSSize)contentSize
                        keepOnScreen:(BOOL)onScreen
{
    //NO
}

@end
