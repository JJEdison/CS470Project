//
//  StepDataSource.h
//  CS 470 Hunt
//
//  Created by Riley Fewell on 4/19/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Step.h"
#import "DownloadAssistant.h"

@protocol DataSourceReadyForUseDelegate;

@interface StepDataSource : NSObject<WebDataReadyDelegate>

//@property (nonatomic) id<DataSourceReadyForUseDelegate> delegate;
@property (nonatomic) id<DataSourceReadyForUseDelegate> delegate;
@property (nonatomic) BOOL dataReadyForUse;

- (instancetype) initWithStepsURL: (NSString *) sURL;


@end


@protocol DownloadReadyForUseDelegate <NSObject>

@optional

-(void) dataSourceReadyForUse: (StepDataSource *) dataSource;

@end




