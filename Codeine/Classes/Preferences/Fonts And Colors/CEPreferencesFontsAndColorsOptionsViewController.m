/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEPreferencesFontsAndColorsOptionsViewController.h"
#import "CEPreferencesFontsAndColorsOptionsViewController+Private.h"
#import "CEPreferencesFontsAndColorsOptionsViewController+NSTableViewDataSource.h"
#import "CEPreferencesFontsAndColorsOptionsViewController+NSTableViewDelegate.h"
#import "CEPreferences.h"
#import "CEColorTheme.h"

@implementation CEPreferencesFontsAndColorsOptionsViewController

@synthesize fontTextField               = _fontTextField;
@synthesize colorThemesPopUp            = _colorThemesPopUp;
@synthesize tableView                   = _tableView;

- ( void )dealloc
{
    [ NOTIFICATION_CENTER removeObserver: self ];
    
    _tableView.delegate   = nil;
    _tableView.dataSource = nil;
    
    RELEASE_IVAR( _fontTextField );
    RELEASE_IVAR( _colorThemesPopUp );
    RELEASE_IVAR( _tableView );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    [ self updateView ];
    
    [ NOTIFICATION_CENTER addObserver: self selector: @selector( updateView ) name: CEPreferencesNotificationValueChanged object: nil ];
    
    {
        NSArray      * themes;
        CEColorTheme * theme;
        NSMenuItem   * item;
        
        themes = [ CEColorTheme defaultColorThemes ];
        
        for( theme in themes )
        {
            [ _colorThemesPopUp addItemWithTitle: theme.name ];
            
            item                   = [ _colorThemesPopUp itemWithTitle: theme.name ];
            item.representedObject = theme;
        }
    }
    
    _tableView.delegate   = self;
    _tableView.dataSource = self;
}

- ( IBAction )chooseFont: ( id )sender
{
    NSFontManager * manager;
    NSFontPanel   * panel;
    NSFont        * font;
    
    font    = [ NSFont fontWithName: [ [ CEPreferences sharedInstance ] fontName ] size: [ [ CEPreferences sharedInstance ] fontSize ] ];
    manager = [ NSFontManager sharedFontManager ];
    panel   = [ manager fontPanel: YES ];
    
    [ manager setSelectedFont: font isMultiple: NO ];
    [ manager setDelegate: self ];
    
    [ panel makeKeyAndOrderFront: sender ];
}

- ( void )changeFont: ( id )sender
{
    NSFontManager * manager;
    NSFont        * font;
    
    if( [ sender isKindOfClass: [ NSFontManager class ] ] == NO )
    {
        return;
    }
    
    manager = ( NSFontManager * )sender;
    font    = [ manager convertFont: [ manager selectedFont ] ];
    
    [ [ CEPreferences sharedInstance ] setFontName: [ font fontName ] ];
    [ [ CEPreferences sharedInstance ] setFontSize: [ font pointSize ] ];
}

- ( IBAction )chooseColorTheme: ( id )sender
{
    CEColorTheme * theme;
    
    ( void )sender;
    
    theme = [ [ _colorThemesPopUp selectedItem ] representedObject ];
    
    if( theme == nil )
    {
        return;
    }
    
    [ [ CEPreferences sharedInstance ] setColorsFromColorTheme: theme ];
}

@end
