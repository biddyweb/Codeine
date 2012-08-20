/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CECodeCompletionViewController.h"
#import "CECodeCompletionViewController+Private.h"
#import "CECodeCompletionViewController+NSTableViewDelegate.h"
#import "CECodeCompletionViewController+NSTableViewDataSource.h"
#import "CEBackgroundView.h"

@implementation CECodeCompletionViewController

@synthesize isOpening = _isOpening;
@synthesize tableView = _tableView;

- ( id )initWithCompletionResults: ( NSArray * )results
{
    if( ( self = [ self init ] ) )
    {
        _results = [ results retain ];
    }
    
    return self;
}

- ( void )dealloc
{
    _tableView.delegate   = nil;
    _tableView.dataSource = nil;
    
    RELEASE_IVAR( _results );
    RELEASE_IVAR( _tableView );
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    _tableView.delegate   = self;
    _tableView.dataSource = self;
}

- ( void )openInPopoverRelativeToRect: ( NSRect )rect ofView: ( NSView * )view preferredEdge: ( NSRectEdge )edge delay: ( BOOL )delay
{
    void ( ^ open )( void );
    
    @synchronized( self )
    {
        _cancel = NO;
    }
    
    open = ^( void )
    {
        if( _cancel == NO )
        {
            [ super openInPopoverRelativeToRect: rect ofView: view preferredEdge: edge ];
        }
        
        _isOpening = NO;
    };
    
    if( delay == YES )
    {
        _isOpening = YES;
        
        dispatch_after
        (
            dispatch_time( DISPATCH_TIME_NOW, NSEC_PER_SEC ),
            dispatch_get_main_queue(),
            open
        );
    }
    else
    {
        open();
    }
}

- ( void )keyDown: ( NSEvent * )event
{
    [ self closePopover ];
    [ APPLICATION sendEvent: event ];
}

- ( void )cancelOpening
{
    @synchronized( self )
    {
        _cancel = YES;
    }
}

@end