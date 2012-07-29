/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEAboutWindowController.h"
#import "CEBackgroundView.h"

@implementation CEAboutWindowController

@synthesize versionTextField = _versionTextField;
@synthesize backgroundView   = _backgroundView;
@synthesize iconView         = _iconView;

- ( void )dealloc
{
    RELEASE_IVAR( _versionTextField );
    RELEASE_IVAR( _backgroundView );
    RELEASE_IVAR( _iconView );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    NSString * version;
    NSString * build;
    NSString * versionString;
    NSImage  * icon;
    CGImageRef cgImage;
    NSRect     rect;
    
    version = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: NSBundleInfoKeyCFBundleShortVersionString ];
    build   = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: NSBundleInfoKeyCFBundleVersion ];
    
    versionString = [ NSString stringWithFormat:  L10N( "AppVersion" ), version, [ build uppercaseString ] ];
    
    [ _versionTextField setStringValue: versionString ];
    [ _backgroundView setBackgroundColor: [ NSColor whiteColor ] ];
    
    icon    = [ NSImage imageNamed: @"Application" ];
    rect    = NSMakeRect( ( CGFloat )0, ( CGFloat )0, ( CGFloat )512, ( CGFloat )512 );
    cgImage = [ icon CGImageForProposedRect: &rect context: nil hints: nil ];
    icon   = [ [ NSImage alloc ] initWithCGImage: cgImage size: NSMakeSize( ( CGFloat )512, ( CGFloat )512 ) ];
    
    [ _iconView setImage: icon ];
    [ icon release ];
}

@end
