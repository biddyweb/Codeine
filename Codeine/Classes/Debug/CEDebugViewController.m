/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEDebugViewController.h"
#import "CEDebugViewController+Private.h"
#import "CEPreferences.h"
#import "CEVerticalTabView.h"

@implementation CEDebugViewController

@synthesize tabView = _tabView;

- ( void )dealloc
{
    RELEASE_IVAR( _tabView );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{}

@end
