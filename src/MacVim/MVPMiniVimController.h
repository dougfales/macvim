//
//  MVPMiniVimController.h
//  MacVim
//
//  Created by Doug on 12/18/17.
//

#import "MMVimController.h"
#import "MVPMiniWindowController.h"

@interface MVPMiniVimController : MMVimController {
    MVPMiniWindowController *miniWindowController;
}

- (id)initWithBackend:(id)backend pid:(int)processIdentifier andVimId:(int)identifier;
- (void)setupAsMiniVimWindow;
@end
