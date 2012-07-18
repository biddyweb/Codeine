/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEViewController.h"

@class CEFilesViewItem;

@interface CEFilesViewController: CEViewController
{
@protected
    
    NSOutlineView   * _outlineView;
    NSMutableArray  * _rootItems;
    NSMenu          * _openDocumentMenu;
    NSMenu          * _bookmarkMenu;
    NSMenu          * _fsDirectoryMenu;
    NSMenu          * _fsFileMenu;
    CEFilesViewItem * _quickLookItem;
    
@private
    
    RESERVERD_IVARS( CEFilesViewController , 5 );
}

@property( nonatomic, readwrite, retain ) IBOutlet NSOutlineView * outlineView;
@property( nonatomic, readwrite, retain ) IBOutlet NSMenu        * openDocumentMenu;
@property( nonatomic, readwrite, retain ) IBOutlet NSMenu        * bookmarkMenu;
@property( nonatomic, readwrite, retain ) IBOutlet NSMenu        * fsDirectoryMenu;
@property( nonatomic, readwrite, retain ) IBOutlet NSMenu        * fsFileMenu;

- ( IBAction )addBookmark: ( id )sender;
- ( IBAction )removeBookmark: ( id )sender;
- ( IBAction )menuActionOpen: ( id )sender;
- ( IBAction )menuActionClose: ( id )sender;
- ( IBAction )menuActionShowInFinder: ( id )sender;
- ( IBAction )menuActionOpenInDefaultEditor: ( id )sender;
- ( IBAction )menuActionDelete: ( id )sender;
- ( IBAction )menuActionRemoveBookmark: ( id )sender;
- ( IBAction )menuActionGetInfo: ( id )sender;
- ( IBAction )menuActionQuickLook: ( id )sender;
- ( IBAction )menuActionSetColorLabel: ( id )sender;

@end
