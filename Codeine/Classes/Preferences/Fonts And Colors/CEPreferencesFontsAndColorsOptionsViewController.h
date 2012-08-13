/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEViewController.h"

@interface CEPreferencesFontsAndColorsOptionsViewController: CEViewController
{
@protected
    
    NSTextField   * _fontTextField;
    NSPopUpButton * _colorThemesPopUp;
    NSTableView   * _tableView;
    
@private
    
    RESERVED_IVARS( CEPreferencesFontsAndColorsOptionsViewController , 5 );
}

@property( nonatomic, readwrite, retain ) IBOutlet NSTextField   * fontTextField;
@property( nonatomic, readwrite, retain ) IBOutlet NSPopUpButton * colorThemesPopUp;
@property( nonatomic, readwrite, retain ) IBOutlet NSTableView   * tableView;

- ( IBAction )chooseFont: ( id )sender;
- ( IBAction )chooseColorTheme: ( id )sender;

@end
