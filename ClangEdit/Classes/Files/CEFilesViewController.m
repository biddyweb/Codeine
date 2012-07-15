/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEFilesViewController.h"
#import "CEFilesViewController+Private.h"
#import "CEFilesViewController+NSOutlineViewDelegate.h"
#import "CEFilesViewController+NSOutlineViewDataSource.h"
#import "CEFilesViewItem.h"
#import "CEPreferences.h"
#import "CEInfoWindowController.h"
#import "CEApplicationDelegate.h"
#import "CEMainWindowController.h"
#import <Quartz/Quartz.h>

@implementation CEFilesViewController

@synthesize outlineView         = _outlineView;
@synthesize openDocumentMenu    = _openDocumentMenu;
@synthesize bookmarkMenu        = _bookmarkMenu;
@synthesize fsDirectoryMenu     = _fsDirectoryMenu;
@synthesize fsFileMenu          = _fsFileMenu;

- ( void )dealloc
{
    [ NOTIFICATION_CENTER removeObserver: self ];
    
    _outlineView.delegate   = nil;
    _outlineView.dataSource = nil;
    
    RELEASE_IVAR( _outlineView );
    RELEASE_IVAR( _rootItems );
    RELEASE_IVAR( _openDocumentMenu );
    RELEASE_IVAR( _bookmarkMenu );
    RELEASE_IVAR( _fsDirectoryMenu );
    RELEASE_IVAR( _fsFileMenu );
    RELEASE_IVAR( _quickLookItem );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    _rootItems = [ [ NSMutableArray alloc ] initWithCapacity: 10 ];
    
    [ _rootItems addObject: [ CEFilesViewItem openDocumentsItem ] ];
    
    #ifdef APPSTORE
        
        /* iCloud files (maybe...) */
        
    #else
        
        [ _rootItems addObject: [ CEFilesViewItem placesItem ] ];
        
    #endif
    
    [ _rootItems addObject: [ CEFilesViewItem bookmarksItems ] ];
    
    [ self setNextResponder: _outlineView.nextResponder ];
    [ _outlineView setNextResponder: self ];
    
    _outlineView.delegate               = self;
    _outlineView.dataSource             = self;
    _outlineView.autosaveExpandedItems  = YES;
    _outlineView.autosaveName           = NSStringFromClass( [ self class ] );
    
    [ _outlineView reloadItem: [ CEFilesViewItem openDocumentsItem ] reloadChildren: YES ];
    [ _outlineView reloadItem: [ CEFilesViewItem placesItem ]        reloadChildren: YES ];
    [ _outlineView reloadItem: [ CEFilesViewItem bookmarksItems ]    reloadChildren: YES ];
    
    [ _outlineView expandItem: [ CEFilesViewItem openDocumentsItem ] expandChildren: NO ];
    
    if( [ [ CEPreferences sharedInstance ] firstLaunch ] == YES )
    {
        [ _outlineView expandItem: [ CEFilesViewItem placesItem ]        expandChildren: NO ];
        [ _outlineView expandItem: [ CEFilesViewItem bookmarksItems ]    expandChildren: NO ];
    }
}

- ( IBAction )addBookmark: ( id )sender
{
    NSOpenPanel * panel;
    
    ( void )sender;
    
    panel                           = [ NSOpenPanel openPanel ];
    panel.allowsMultipleSelection   = NO;
    panel.canChooseDirectories      = YES;
    panel.canChooseFiles            = NO;
    panel.canCreateDirectories      = YES;
    panel.prompt                    = L10N( "AddBookmark" );
    
    [ panel beginSheetModalForWindow: self.view.window completionHandler: ^( NSInteger result )
        {
            NSString * path;
            
            if( result != NSFileHandlingPanelOKButton )
            {
                return;
            }
            
            path = [ panel.URL path ];
            
            [ [ CEPreferences sharedInstance ] addBookmark: path ];
            [ ( CEFilesViewItem * )[ CEFilesViewItem bookmarksItems ] addChild: [ CEFilesViewItem fileViewItemWithType: CEFilesViewItemTypeBookmark name: path ] ];
            [ _outlineView reloadItem: [ CEFilesViewItem bookmarksItems ] reloadChildren: YES ];
            [ _outlineView expandItem: [ CEFilesViewItem bookmarksItems ] ];
        }
    ];
}

- ( IBAction )removeBookmark: ( id )sender
{
    NSInteger        row;
    CEFilesViewItem * item;
    
    ( void )sender;
    
    row = _outlineView.selectedRow;
    
    if( row == -1 )
    {
        return;
    }
    
    item = [ _outlineView itemAtRow: row ];
    
    if( item == nil || item.type != CEFilesViewItemTypeBookmark )
    {
        return;
    }
    
    [ [ CEPreferences sharedInstance ] removeBookmark: item.name ];
    [ ( CEFilesViewItem * )[ CEFilesViewItem bookmarksItems ] removeChild: item ];
    [ _outlineView reloadItem: [ CEFilesViewItem bookmarksItems ] reloadChildren: YES ];
}

- ( IBAction )menuActionOpen: ( id )sender
{
    NSMenuItem      * menuItem;
    CEFilesViewItem  * item;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item = menuItem.representedObject;
}

- ( IBAction )menuActionClose: ( id )sender
{
    NSMenuItem      * menuItem;
    CEFilesViewItem  * item;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item = menuItem.representedObject;
}

- ( IBAction )menuActionShowInFinder: ( id )sender
{
    NSMenuItem      * menuItem;
    CEFilesViewItem  * item;
    NSString        * path;
    NSRange           range;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item  = menuItem.representedObject;
    range = [ item.name rangeOfString: @":" ];
    
    if( range.location == NSNotFound )
    {
        path = item.name;
    }
    else
    {
        path = [ item.name substringFromIndex: range.location + 1 ];
    }
    
    [ [ NSWorkspace sharedWorkspace ] selectFile: path inFileViewerRootedAtPath: nil ];
}

- ( IBAction )menuActionOpenInDefaultEditor: ( id )sender
{
    NSMenuItem      * menuItem;
    CEFilesViewItem  * item;
    NSString        * path;
    NSRange           range;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item  = menuItem.representedObject;
    range = [ item.name rangeOfString: @":" ];
    
    if( range.location == NSNotFound )
    {
        path = item.name;
    }
    else
    {
        path = [ item.name substringFromIndex: range.location + 1 ];
    }
    
    [ [ NSWorkspace sharedWorkspace ] openFile: path ];
}

- ( IBAction )menuActionDelete: ( id )sender
{
    NSMenuItem      * menuItem;
    CEFilesViewItem  * item;
    NSString        * path;
    NSRange           range;
    NSError         * error;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item  = menuItem.representedObject;
    range = [ item.name rangeOfString: @":" ];
    
    if( range.location == NSNotFound )
    {
        path = item.name;
    }
    else
    {
        path = [ item.name substringFromIndex: range.location + 1 ];
    }
    
    error = nil;
    
    {
        NSAlert * alert;
        
        alert = [ NSAlert alertWithMessageText: [ NSString stringWithFormat: L10N( "DeleteAlertTitle" ), [ FILE_MANAGER displayNameAtPath: path ] ] defaultButton: L10N( "OK" ) alternateButton: L10N( "Cancel" ) otherButton: nil informativeTextWithFormat: L10N( "DeleteAlertText" ) ];
        
        if( [ alert runModal ] != NSAlertDefaultReturn )
        {
            return;
        }
    }
    
    if( [ FILE_MANAGER removeItemAtPath: path error: &error ] == NO || error != nil )
    {
        {
            NSAlert * alert;
            
            alert            = [ NSAlert alertWithMessageText: L10N( "DeleteErrorTitle" ) defaultButton: L10N( "OK" ) alternateButton: nil otherButton: nil informativeTextWithFormat: L10N( "DeleteErrorText" ) ];
            alert.alertStyle = NSWarningAlertStyle;
            
            NSBeep();
            
            [ alert runModal ];
        }
    }
    else
    {
        {
            id parent;
            
            parent = item.parent;
            
            if( [ parent isKindOfClass: [ CEFilesViewItem class ] ] )
            {
                [ ( CEFilesViewItem * )parent removeChild: item ];
            }
            
            [ _outlineView reloadItem: parent reloadChildren: YES ];
        }
    }
}

- ( IBAction )menuActionRemoveBookmark: ( id )sender
{
    NSMenuItem      * menuItem;
    CEFilesViewItem  * item;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item = menuItem.representedObject;
    
    [ [ CEPreferences sharedInstance ] removeBookmark: item.name ];
    [ ( CEFilesViewItem * )[ CEFilesViewItem bookmarksItems ] removeChild: item ];
    [ _outlineView reloadItem: [ CEFilesViewItem bookmarksItems ] reloadChildren: YES ];
}

- ( IBAction )menuActionGetInfo: ( id )sender
{
    NSMenuItem              * menuItem;
    CEFilesViewItem          * item;
    CEInfoWindowController  * controller;
    NSString                * path;
    NSRange                   range;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item  = menuItem.representedObject;
    range = [ item.name rangeOfString: @":" ];
    
    if( range.location == NSNotFound )
    {
        path = item.name;
    }
    else
    {
        path = [ item.name substringFromIndex: range.location + 1 ];
    }
    
    controller = [ [ CEInfoWindowController alloc ] initWithPath: path ];
    
    if( controller != nil )
    {
        controller.releaseOnWindowClose = YES;
        
        [ controller.window center ];
        [ controller showWindow: sender ];
        [ controller.window makeKeyAndOrderFront: sender ];
        [ controller autorelease ];
    }
    else
    {
        NSBeep();
    }
}

- ( IBAction )menuActionQuickLook: ( id )sender
{
    NSMenuItem      * menuItem;
    CEFilesViewItem  * item;
    NSString        * path;
    NSRange           range;
    
    if( [ sender isKindOfClass: [ NSMenuItem class ] ] == NO )
    {
        return;
    }
    
    menuItem = sender;
    
    if( [ menuItem.representedObject isKindOfClass: [ CEFilesViewItem class ] ] == NO )
    {
        return;
    }
    
    item  = menuItem.representedObject;
    range = [ item.name rangeOfString: @":" ];
    
    if( range.location == NSNotFound )
    {
        path = item.name;
    }
    else
    {
        path = [ item.name substringFromIndex: range.location + 1 ];
    }
    
    [ APPLICATION showQuickLookPanelForItemAtPath: path sender: sender ];
}

@end
