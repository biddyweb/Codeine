/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEPreferencesFileTypesAddNewViewController.h"

@implementation CEPreferencesFileTypesAddNewViewController

@synthesize textField       = _textField;
@synthesize popUpButton     = _popUpButton;
@synthesize fileExtension   = _fileExtension;
@synthesize language        = _language;

- ( void )dealloc
{
    RELEASE_IVAR( _textField );
    RELEASE_IVAR( _popUpButton );
    RELEASE_IVAR( _fileExtension );
    
    [ super dealloc ];
}

- ( IBAction )ok: ( id )sender
{
    NSString * extension;
    
    extension = [ _textField stringValue ];
    
    if( extension.length == 0 )
    {
        [ self cancel: sender ];
        
        return;
    }
    
    if( [ extension hasPrefix: @"." ] )
    {
        if( extension.length == 1 )
        {
            [ self cancel: sender ];
            
            return;
        }
        
        extension = [ extension substringFromIndex: 1 ];
    }
    
    _fileExtension = [ extension copy ];
    _language      = ( CESourceFileLanguage )[ _popUpButton selectedTag ];
    
    [ self.window orderOut: sender ];
    [ APPLICATION endSheet: self.window ];
}

- ( IBAction )cancel: ( id )sender
{
    ( void )sender;
    
    [ self.window orderOut: sender ];
    [ APPLICATION endSheet: self.window ];
}

@end
