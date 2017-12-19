//
//  MVPMiniVimController.m
//  MacVim
//
//  Created by Doug on 12/18/17.
//

#import "MVPMiniVimController.h"
#import "MVPMiniWindowController.h"

@implementation MVPMiniVimController


- (id)initWithBackend:(id)backend pid:(int)processIdentifier andVimId:(int)idFromOldVC
{
    [super initWithBackend:backend pid:processIdentifier];
    identifier = idFromOldVC;
    return self;
}

- (void)setupWindowController
{
    windowController = [[MVPMiniWindowController alloc] initWithVimController:self];
    miniWindowController = windowController;
}

- (NSFont *)miniFont
{
    // TODO: should match selected font, if possible.
    return [NSFont fontWithName:@"Consolas" size:2.0];
}

- (void)setupAsMiniVimWindow {
    // set small font
    // set window size
    // set window style
    [miniWindowController setupAsMiniVim];
    [miniWindowController setFont:[self miniFont]];
}

- (void)handleMessage:(int)msgid data:(NSData *)data
{
    if(msgid == SetFontMsgID) {
        ASLogDebug(@"Skipping SetFontMsg in MVPMiniVimController.");
        return;
    }
    [super handleMessage:msgid data:data];
}

@end
