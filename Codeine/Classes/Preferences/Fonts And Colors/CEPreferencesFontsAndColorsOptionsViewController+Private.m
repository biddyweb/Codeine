/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina - www.xs-labs.com
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *  -   Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *  -   Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *  -   Neither the name of 'Jean-David Gadina' nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************/
 
/* $Id$ */

#import "CEPreferencesFontsAndColorsOptionsViewController+Private.h"
#import "CEPreferencesFontsAndColorsOptionsViewController+NSTableViewDataSource.h"
#import "CEPreferencesFontsAndColorsOptionsViewController+CEColorChooserViewDelegate.h"
#import "CEPreferences.h"
#import "CEColorTheme.h"
#import "CEApplicationDelegate.h"
#import "CEColorChooserView.h"

@implementation CEPreferencesFontsAndColorsOptionsViewController( Private )

- ( void )updateView
{
    NSString      * font;
    CEPreferences * prefs;
    
    prefs = [ CEPreferences sharedInstance ];
    font  = [ NSString stringWithFormat: @"%@ - %.01f", [ prefs fontName ], [ prefs fontSize ] ];
    
    [ _fontTextField setStringValue: font ];
    
    _tableView.backgroundColor = [ prefs backgroundColor ];
    
    [ _tableView reloadData ];
}

- ( void )getColorThemes
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

- ( void )resetAlertDidEnd: ( NSAlert * )alert returnCode: ( NSInteger )returnCode contextInfo: ( void * )contextInfo
{
    NSArray    * items;
    NSMenuItem * item;
    
    ( void )alert;
    ( void )contextInfo;
    
    if( returnCode == NSAlertDefaultReturn )
    {
        items = [ _colorThemesPopUp itemArray ];
        
        for( item in items )
        {
            if( [ item.representedObject isKindOfClass: [ CEColorTheme class ] ] == YES )
            {
                [ _colorThemesPopUp removeItemWithTitle: item.title ];
            }
        }
        
        [ [ CEApplicationDelegate sharedInstance ] resetColorThemes: nil ];
        [ self getColorThemes ];
        [ [ CEPreferences sharedInstance ] setColorsFromColorTheme: [ CEColorTheme defaultColorThemeWithName: @"Codeine - Dark" ] ];
    }
}

- ( void )createColorChooserViews
{
    NSInteger            numViews;
    NSInteger            i;
    CEColorChooserView * view;
    
    [ _colorChooserViews release ];
    
    numViews           = [ self numberOfRowsInTableView: _tableView ];
    _colorChooserViews = [ [NSMutableArray alloc ] initWithCapacity: ( NSUInteger )numViews ];
    
    for( i = 0; i < numViews; i++ )
    {
        view = [ [ CEColorChooserView alloc ] initWithFrame: NSZeroRect ];
        
        [ _colorChooserViews addObject: view ];
        [ view release ];
    }
}

@end
