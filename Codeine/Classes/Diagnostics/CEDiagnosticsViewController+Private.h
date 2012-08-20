/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEDiagnosticsViewController.h"

@interface CEDiagnosticsViewController( Private )

- ( void )applicationStateDidChange: ( NSNotification * )notification;
- ( void )getDiagnostics;
- ( void )textViewSelectionDidChange: ( NSNotification * )notification;
- ( void )showPopover;

@end