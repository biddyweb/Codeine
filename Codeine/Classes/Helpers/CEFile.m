/*******************************************************************************
 * Copyright (c) 2012, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

#import "CEFile.h"
#import "CEFile+Private.h"

@implementation CEFile

@synthesize path        = _path;
@synthesize url         = _url;
@synthesize isDirectory = _isDirectory;
@synthesize isPackage   = _isPackage;
@synthesize readable    = _readable;
@synthesize writable    = _writable;

+ ( id )fileWithPath: ( NSString * )path
{
    return [ [ [ self alloc ] initWithPath: path ] autorelease ];
}

+ ( id )fileWithURL: ( NSURL * )url
{
    return [ [ [ self alloc ] initWithURL: url ] autorelease ];
}

- ( id )initWithPath: ( NSString * )path
{
    if( ( self = [ self initWithURL: [ NSURL fileURLWithPath: path ] ] ) )
    {}
    
    return self;
}

- ( id )initWithURL: ( NSURL * )url
{
    NSDictionary * attributes;
    NSError      * error;
    
    if( ( self = [ self init ] ) )
    {
        _url    = [ url retain ];
        _path   = [ [ _url path ] retain ];
        
        if( [ FILE_MANAGER fileExistsAtPath: _path isDirectory: &_isDirectory ] == NO )
        {
            [ self release ];
            
            return nil;
        }
        
        error       = nil;
        attributes  = [ FILE_MANAGER attributesOfItemAtPath: _path error: &error ];
        
        if( attributes.count == 0 || error != nil )
        {
            [ self release ];
            
            return nil;
        }
        
        _attributes = [ attributes retain ];
        _isPackage  = [ [ NSWorkspace sharedWorkspace ] isFilePackageAtPath: _path ];
        _readable   = [ FILE_MANAGER isReadableFileAtPath: _path ];
        _writable   = [ FILE_MANAGER isWritableFileAtPath: _path ];
    }
    
    return self;
}

- ( void )dealloc
{
    RELEASE_IVAR( _path );
    RELEASE_IVAR( _url );
    RELEASE_IVAR( _attributes );
    RELEASE_IVAR( _name );
    RELEASE_IVAR( _kind );
    RELEASE_IVAR( _icon );
    RELEASE_IVAR( _labelColor );
    RELEASE_IVAR( _size );
    RELEASE_IVAR( _creationDate );
    RELEASE_IVAR( _modificationDate );
    RELEASE_IVAR( _creationTime );
    RELEASE_IVAR( _modificationTime );
    RELEASE_IVAR( _owner );
    RELEASE_IVAR( _group );
    RELEASE_IVAR( _humanPermissions );
    
    [ super dealloc ];
}

- ( void )refresh
{
    NSDictionary * attributes;
    NSError      * error;
    
    RELEASE_IVAR( _attributes );
    RELEASE_IVAR( _name );
    RELEASE_IVAR( _kind );
    RELEASE_IVAR( _icon );
    RELEASE_IVAR( _labelColor );
    RELEASE_IVAR( _size );
    RELEASE_IVAR( _creationDate );
    RELEASE_IVAR( _modificationDate );
    RELEASE_IVAR( _creationTime );
    RELEASE_IVAR( _modificationTime );
    RELEASE_IVAR( _owner );
    RELEASE_IVAR( _group );
    RELEASE_IVAR( _humanPermissions );
    
    error       = nil;
    attributes  = [ FILE_MANAGER attributesOfItemAtPath: _path error: &error ];
    
    if( attributes.count > 0 && error == nil )
    {
        _attributes = [ attributes retain ];
    }
}

- ( NSString * )name
{
    if( _name == nil )
    {
        _name = [ [ FILE_MANAGER displayNameAtPath: _path ] retain ];
    }
    
    return _name;
}

- ( NSString * )kind
{
    NSString * type;
    
    if( _kind == nil )
    {
        type  = [ [ NSWorkspace sharedWorkspace ] typeOfFile: _path error: NULL ];
        _kind = [ [ [ NSWorkspace sharedWorkspace ] localizedDescriptionForType: type ] retain ];
    }
    
    return _name;
}

- ( NSColor * )labelColor
{
    if( _labelColor == nil )
    {
        [ _url getResourceValue: &_labelColor forKey: NSURLLabelColorKey error: NULL ];
        [ _labelColor retain ];
    }
    
    return _labelColor;
}

- ( NSImage * )icon
{
    NSImage  * icon;
    CGImageRef cgImage;
    NSRect     rect;
    
    if( _icon == nil )
    {
        icon    = [ [ NSWorkspace sharedWorkspace ] iconForFile: _path ];
        rect    = NSMakeRect( ( CGFloat )0, ( CGFloat )0, ( CGFloat )512, ( CGFloat )512 );
        cgImage = [ icon CGImageForProposedRect: &rect context: nil hints: nil ];
        _icon   = [ [ NSImage alloc ] initWithCGImage: cgImage size: NSMakeSize( ( CGFloat )512, ( CGFloat )512 ) ];
    }
    
    return _icon;
}

- ( NSUInteger )bytes
{
    if( _bytes == 0 )
    {
        _bytes = [ ( NSNumber * )[ _attributes objectForKey: NSFileSize ] unsignedIntegerValue ];
    }
    
    return _bytes;
}

- ( NSString * )size
{
    if( _size == nil )
    {
        _size = [ [ NSString stringForDataSizeWithBytes: self.bytes ] retain ];
    }
    
    return _size;
}

- ( NSDate * )creationDate
{
    if( _creationDate == nil )
    {
        _creationDate = [ [ _attributes objectForKey: NSFileCreationDate ] retain ];
    }
    
    return _creationDate;
}

- ( NSDate * )modificationDate
{
    if( _modificationDate == nil )
    {
        _modificationDate = [ [ _attributes objectForKey: NSFileModificationDate ] retain ];
    }
    
    return _modificationDate;
}

- ( NSString * )creationTime
{
    NSDateFormatter * dateFormatter;
    
    if( _creationTime == nil )
    {
        dateFormatter                               = [ NSDateFormatter new ];
        dateFormatter.doesRelativeDateFormatting    = YES;
        dateFormatter.dateStyle                     = NSDateFormatterLongStyle;
        dateFormatter.timeStyle                     = NSDateFormatterShortStyle;
        
        _creationTime = [ [ dateFormatter stringFromDate: self.creationDate ] retain ];
        
        [ dateFormatter release ];
    }
    
    return _creationTime;
}

- ( NSString * )modificationTime
{
    NSDateFormatter * dateFormatter;
    
    if( _modificationTime == nil )
    {
        dateFormatter                               = [ NSDateFormatter new ];
        dateFormatter.doesRelativeDateFormatting    = YES;
        dateFormatter.dateStyle                     = NSDateFormatterLongStyle;
        dateFormatter.timeStyle                     = NSDateFormatterShortStyle;
        
        _modificationTime = [ [ dateFormatter stringFromDate: self.modificationDate ] retain ];
        
        [ dateFormatter release ];
    }
    
    return _modificationTime;
}

- ( NSString * )owner
{
    if( _hasPermissions == NO )
    {
        [ self getPermissions ];
    }
    
    return _owner;
}

- ( NSString * )group
{
    if( _hasPermissions == NO )
    {
        [ self getPermissions ];
    }
    
    return _group;
}

- ( NSUInteger )ownerID
{
    if( _hasPermissions == NO )
    {
        [ self getPermissions ];
    }
    
    return _ownerID;
}

- ( NSUInteger )groupID
{
    if( _hasPermissions == NO )
    {
        [ self getPermissions ];
    }
    
    return _groupID;
}

- ( NSUInteger )permissions
{
    if( _hasPermissions == NO )
    {
        [ self getPermissions ];
    }
    
    return _permissions;
}

- ( NSUInteger )octalPermissions
{
    if( _hasPermissions == NO )
    {
        [ self getPermissions ];
    }
    
    return _octalPermissions;
}

- ( NSString * )humanPermissions
{
    if( _hasPermissions == NO )
    {
        [ self getPermissions ];
    }
    
    return _humanPermissions;
}

@end