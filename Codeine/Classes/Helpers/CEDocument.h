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

#import "CEFile.h"
#import "CESourceFile.h"

@class CEFile;
@class CEUUID;

@interface CEDocument: NSObject
{
@protected
    
    CEFile       * _file;
    CESourceFile * _sourceFile;
    NSString     * _name;
    CEUUID       * _uuid;
    
@private
    
    RESERVED_IVARS( CEDocument, 5 );
}

@property( atomic, readwrite, retain ) CEFile       * file;
@property( atomic, readonly          ) CESourceFile * sourceFile;
@property( atomic, readonly          ) NSString     * name;
@property( atomic, readonly          ) NSImage      * icon;
@property( atomic, readonly          ) CEUUID       * uuid;

+ ( id )documentWithPath: ( NSString * )path;
+ ( id )documentWithURL: ( NSURL * )url;
+ ( id )documentWithLanguage: ( CESourceFileLanguage )language;
- ( id )initWithPath: ( NSString * )path;
- ( id )initWithURL: ( NSURL * )url;
- ( id )initWithLanguage: ( CESourceFileLanguage )language;
- ( void )save;
- ( BOOL )save: ( NSError ** )error;

@end
