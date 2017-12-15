//
//  MVPPreviewView.m
//  MacVim
//
//  Created by Doug on 12/14/17.
//

#import "MVPPreviewView.h"
#import "MMTextView.h"

@implementation MVPPreviewView

- (void)drawRect:(NSRect)dirtyRect {
    if(self.windowController) {
        MMTextView *tv = (MMTextView *)[[self.windowController vimView] textView];
        [tv displayRectIgnoringOpacity:dirtyRect inContext:[NSGraphicsContext currentContext]];
    }

}

@end
