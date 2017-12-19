//
//  MVPMiniVimView.m
//  MacVim
//
//  Created by Doug on 12/18/17.
//

#import "MacVim.h"
#import "MVPMiniVimView.h"

@implementation MVPMiniVimView

- (void)frameSizeMayHaveChanged
{
    // NOTE: Whenever a call is made that may have changed the frame size we
    // take the opportunity to make sure all subviews are in place and that the
    // (rows,columns) are constrained to lie inside the new frame.  We not only
    // do this when the frame really has changed since it is possible to modify
    // the number of (rows,columns) without changing the frame size.
    
    // Give all superfluous space to the text view. It might be smaller or
    // larger than it wants to be, but this is needed during live resizing.
    NSRect textViewRect = [self textViewRectForVimViewSize:[self frame].size];
    [textView setFrame:textViewRect];
    
    [self placeScrollbars];
    
    // It is possible that the current number of (rows,columns) is too big or
    // too small to fit the new frame.  If so, notify Vim that the text
    // dimensions should change, but don't actually change the number of
    // (rows,columns).  These numbers may only change when Vim initiates the
    // change (as opposed to the user dragging the window resizer, for
    // example).
    //
    // Note that the message sent to Vim depends on whether we're in
    // a live resize or not -- this is necessary to avoid the window jittering
    // when the user drags to resize.
    int constrained[2];
    NSSize textViewSize = [textView frame].size;
    [textView constrainRows:&constrained[0] columns:&constrained[1]
                     toSize:textViewSize];
    
    int rows, cols;
    [textView getMaxRows:&rows columns:&cols];
    
    if (constrained[0] != rows || constrained[1] != cols) {
        NSData *data = [NSData dataWithBytes:constrained length:2*sizeof(int)];
        int msgid = [self inLiveResize] ? LiveResizeMsgID
        : SetTextDimensionsMsgID;
        
        ASLogDebug(@"Notify Vim that text dimensions changed from %dx%d to "
                   "%dx%d (%s)", cols, rows, constrained[1], constrained[0],
                   MessageStrings[msgid]);
        NSLog(@"Skipping message about text dimensions...");
      //  [vimController sendMessageNow:msgid data:data timeout:1];
        
        // We only want to set the window title if this resize came from
        // a live-resize, not (for example) setting 'columns' or 'lines'.
        if ([self inLiveResize]) {
            [[self window] setTitle:[NSString stringWithFormat:@"%dx%d",
                                     constrained[1], constrained[0]]];
        }
    }
}

@end
