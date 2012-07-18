/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEPreferencesLinkerOptionsViewController+NSTableViewDataSource.h"
#import "CELinkerObject.h"
#import "CEPreferences.h"

@implementation CEPreferencesLinkerOptionsViewController( NSTableViewDataSource )

- ( NSInteger )numberOfRowsInTableView: ( NSTableView * )tableView
{
    NSArray * objects;
    
    objects = nil;
    
    if( tableView == _frameworksTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeFramework ];
    }
    else if( tableView == _sharedLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeSharedLibrary ];
    }
    else if( tableView == _staticLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeStaticLibrary ];
    }
    
    return ( NSInteger )( objects.count );
}

- ( id )tableView: ( NSTableView * )tableView objectValueForTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )row
{
    NSArray        * objects;
    CELinkerObject * object;
    
    objects = nil;
    
    if( tableView == _frameworksTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeFramework ];
    }
    else if( tableView == _sharedLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeSharedLibrary ];
    }
    else if( tableView == _staticLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeStaticLibrary ];
    }
    
    if( objects == nil || ( NSUInteger )row >= objects.count )
    {
        return nil;
    }
    
    object = [ objects objectAtIndex: ( NSUInteger )row ];
    
    if( [ tableColumn.identifier isEqualToString: CEPreferencesLinkerOptionsViewControllerTableViewColumnIconIdentifier ] )
    {
        return object.icon;
    }
    else if( [ tableColumn.identifier isEqualToString: CEPreferencesLinkerOptionsViewControllerTableViewColumnNameIdentifier ] )
    {
        return [ object.name stringByDeletingPathExtension ];
    }
    else if( [ tableColumn.identifier isEqualToString: CEPreferencesLinkerOptionsViewControllerTableViewColumnPathIdentifier ] )
    {
        return [ object.path stringByDeletingLastPathComponent ];
    }
    else if( [ tableColumn.identifier isEqualToString: CEPreferencesLinkerOptionsViewControllerTableViewColumnLanguageIdentifier ] )
    {
        return [ NSNumber numberWithInteger: object.language ];
    }
    
    return nil;
}

- ( void )tableView: ( NSTableView * )tableView setObjectValue: ( id )object forTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )row
{
    NSArray            * objects;
    CELinkerObject     * linkerObject;
    CESourceFileLanguage language;
    
    ( void )tableColumn;
    
    if( tableView == _frameworksTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeFramework ];
    }
    else if( tableView == _sharedLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeSharedLibrary ];
    }
    else if( tableView == _staticLibsTableView )
    {
        objects = [ CELinkerObject linkerObjectsWithType: CELinkerObjectTypeStaticLibrary ];
    }
    
    @try
    {
        linkerObject = [ objects objectAtIndex: ( NSUInteger )row ];
    }
    @catch( NSException * e )
    {
        ( void )e;
    }
    
    language = ( CESourceFileLanguage )[ ( NSNumber * )object integerValue ];
    
    [ [ CEPreferences sharedInstance ] setLanguage: language ofLinkerObject: linkerObject ];
    [ tableView reloadData ];
}

@end
