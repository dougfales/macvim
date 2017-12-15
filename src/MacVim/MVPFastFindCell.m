//
//  FastFindCell.m
//  MacVim
//
//  Created by Doug Fales on 4/3/10.
//  MacVimProject (MVP) by Doug Fales, 2010
//

#import "MVPFastFindCell.h"
#import "MVPFastFindController.h"
#import "MVPProject.h"
#import "MVPFastFindResult.h"

@implementation MVPFastFindCell

@synthesize fastFindController;

- copyWithZone:(NSZone *)zone {
	MVPFastFindCell *cell = (MVPFastFindCell *)[super copyWithZone:zone];
	cell.fastFindController = self.fastFindController;
    return cell;
}

- (void)dealloc {
	[fastFindController release]; fastFindController = nil;
	[super dealloc];
}

- (void)drawTitle:(NSRect)cellFrame {
    NSAttributedString *title = [self addFilenameAttributes:[[self objectValue] title]];
    [title drawAtPoint:NSMakePoint(cellFrame.origin.x + 28, cellFrame.origin.y + 4)];
}

- (void)drawPath:(NSRect)cellFrame {
    NSString *path = [[self objectValue] name];
    [path drawAtPoint:NSMakePoint(cellFrame.origin.x + 28, cellFrame.origin.y + 21) withAttributes:[self pathAttributes]];
}

- (void)drawIcon:(NSRect)cellFrame inView:(NSView *)controlView {
    float startY = cellFrame.origin.y;
    if([controlView isFlipped]) {
        NSAffineTransform *transform = [NSAffineTransform transform];
        [transform translateXBy:0.0 yBy:cellFrame.size.height];
        [transform scaleXBy:1.0 yBy:-1.0];
        [transform concat];
        startY = -cellFrame.origin.y;
    }
    
    NSImage *icon = [[self objectValue] icon];
    NSRect toRect = NSMakeRect(cellFrame.origin.x +2, startY + 3, 25, 25);
    NSRect fromRect = NSMakeRect(0, 0, [icon size].width, [icon size].height);
    NSImageInterpolation interp = [[NSGraphicsContext currentContext] imageInterpolation];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [icon drawInRect:toRect fromRect:fromRect operation:NSCompositingOperationSourceOver fraction:1.0];
    [[NSGraphicsContext currentContext] setImageInterpolation:interp]; // Not part of graphics state; won't be reset by restoreGraphicsState
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {

    [[NSGraphicsContext currentContext] saveGraphicsState];

    [self drawTitle:cellFrame];
	
    [self drawPath:cellFrame];
	
    [self drawIcon:cellFrame inView:controlView];

	[[NSGraphicsContext currentContext] restoreGraphicsState];
	
}

- (NSColor *)textColor {
    return ([self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor grayColor]);
}

-(NSAttributedString *)addFilenameAttributes:(NSString *)filename  {
	NSDictionary *filenameAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[self textColor], NSForegroundColorAttributeName, [NSFont systemFontOfSize:14], NSFontAttributeName, nil];
	NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:filename attributes:filenameAttributes]; 
    NSRange r =	[filename rangeOfString:[fastFindController searchString]];
    [aString addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:14] range:r];
    NSColor *searchStringHighlightColor = ([self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor blackColor]);
	[aString addAttribute:NSForegroundColorAttributeName value:searchStringHighlightColor range:r];
    return aString;    
}

-(NSDictionary *)pathAttributes  {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self textColor], NSForegroundColorAttributeName,
            [NSFont systemFontOfSize:9], NSFontAttributeName, nil];
}

@end
