//
//  HuntDataSource.m
//  CS 470 Hunt
//
//  Created by student on 4/13/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "HuntDataSource.h"

@interface HuntDataSource ()
{
    BOOL _debug;
}

@property (nonatomic) NSMutableArray *allHunts;
@property (nonatomic) NSString *huntsURLString;
@property (nonatomic) DownloadAssistant *downloadAssistant;
@property (nonatomic) NSData *huntsNSData;

@end


@implementation HuntDataSource

- (NSMutableArray *) allHunts
{
    if( _allHunts == nil )
        _allHunts = [[NSMutableArray alloc] init];
    return _allHunts;
}

- (instancetype) initWithHuntsURLString: (NSString *) hURL
{
    if( (self = [super init]) == nil )
        return nil;
    
    self.huntsURLString = hURL;
    _debug = YES;
    
    _downloadAssistant = [[DownloadAssistant alloc]init];
    [self.downloadAssistant setDelegate:self];
    
    self.dataReadyForUse = NO;
    
    NSURL *url = [NSURL URLWithString:self.huntsURLString];
    [self.downloadAssistant downloadContentsOfURL:url];
    
    return self;
}

- (void) processHuntJSON
{
    NSError *parseError = nil;
    NSArray *jsonString = [NSJSONSerialization JSONObjectWithData:self.huntsNSData options:0 error:&parseError];
    
    if( _debug )
        NSLog( @"%@", jsonString );
    
    if( parseError )
    {
        NSLog( @"In hunts Badly formed JSON string: %@", [parseError localizedDescription] );
        return;
    }
    
    for( NSMutableDictionary *huntTuple in jsonString )
    {
        Hunt *hunt = [[Hunt alloc] initWithDictionary:huntTuple];
        if( _debug )
            [hunt print];
        [self.allHunts addObject:hunt];
        NSLog( @"num of hunts %lu", (unsigned long)[self.allHunts count] );
    }
    
    self.huntsNSData = nil;
    if( [self.delegate respondsToSelector:@selector(dataSourceReadyForUse:)] )
        [self.delegate performSelector:@selector(dataSourceReadyForUse:) withObject:self];
    
    
}

- (void) print
{
    NSLog( @"number of hunts %lu", (unsigned long)[self.allHunts count] );
    for( Hunt *h in self.allHunts )
        [h print];
}

- (void) acceptWebData:(NSData *) webData forURL:(NSURL *) url
{
    self.huntsNSData = webData;
    [self processHuntJSON];
    [self print];
    NSLog( @"completing printing hunts" );
    self.dataReadyForUse = YES;
    
}

- (Hunt *) huntWithName: (NSString *) huntName
{
    if( [self.allHunts count] == 0 )
        return nil;
    
    for( Hunt *hunt in self.allHunts )
        if( [hunt.title isEqualToString:huntName] )
            return hunt;
    return nil;
}

- (NSArray *) getAllhunts
{
    return  self.allHunts;
}

-(BOOL) deleteHuntAtIndex: (NSInteger) idx
{
    [self.allHunts removeObjectAtIndex:idx];
    return YES;
}

- (Hunt *) huntAtIndex: (int) idx
{
    if( idx >= [self.allHunts count] )
        return nil;
    return [self.allHunts objectAtIndex:idx];
}

- (NSInteger ) numberOfHunts
{
    return [self.allHunts count];
}

- (NSString *) HuntsTabBarTitle
{
    return @"Hunts";
}




@end
