//
//  AddEditConfiguration.h
//  ExperimentVPN
//
//  Created by lidahe on 15/10/9.
//  Copyright © 2015年 lidahe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMConstants.h"

@interface AddEditConfiguration : NSObject

+(AddEditConfiguration *)sharedInstance;
-(void)save;
-(void)loadProfile;
-(void)start;
-(void)stop;
-(void)check;
-(void) remove;

@end
