/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CESourceFile.h"

typedef enum
{
    CELinkerObjectTypeFramework     = 0x00,
    CELinkerObjectTypeSharedLibrary = 0x01,
    CELinkerObjectTypeStaticLibrary = 0x02
}
CELinkerObjectType;

@interface CELinkerObject: NSObject
{
@protected
    
    CELinkerObjectType   _type;
    CESourceFileLanguage _language;
    NSString           * _path;
    
@private
    
    RESERVERD_IVARS( CELinkerObject, 5 );
}

@property( atomic, readonly ) CELinkerObjectType    type;
@property( atomic, readonly ) CESourceFileLanguage  language;
@property( atomic, readonly ) NSString            * path;
@property( atomic, readonly ) NSString            * name;
@property( atomic, readonly ) NSImage             * icon;

+ ( id )linkerObjectWithPath: ( NSString * )path type: ( CELinkerObjectType )type;
+ ( id )linkerObjectWithPath: ( NSString * )path type: ( CELinkerObjectType )type language: ( CESourceFileLanguage )language;
- ( id )initWithPath: ( NSString * )path type: ( CELinkerObjectType )type;
- ( id )initWithPath: ( NSString * )path type: ( CELinkerObjectType )type language: ( CESourceFileLanguage )language;

@end
