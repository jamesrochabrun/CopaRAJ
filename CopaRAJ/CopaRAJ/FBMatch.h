//
//  FBMatch.h
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/25/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBMatch : NSObject
//Match info
@property NSString *matchID;
@property NSString *groupCode;
@property NSString *image_stadium;
@property NSString *live_minute;
@property BOOL playoffs;
@property NSString *schedule;
@property NSString *stadium;
@property NSInteger status;
@property NSMutableArray *goals;
@property NSMutableArray *cards;
@property NSMutableArray *changes;//substitutions
@property NSMutableArray *timeline;


//team local info
@property NSString *local;
@property NSString *local_abbr;
@property NSString *local_goals;
@property NSString *local_pos;//possessiong %
@property NSString *local_sot;//shots
@property NSString *local_son;//shots on target
@property NSUInteger local_soff;//offsides
@property NSString *local_frk;//free kicks
@property NSString *local_blk; //saves
@property NSString *local_yc; //yellow cards
@property NSUInteger local_rc; //red cards
@property NSString *local_tactic;
@property NSMutableArray *local_Lineup;
@property NSNumber *pen1;


//team visitor info
@property NSString *visitor;
@property NSString *visitor_abbr;
@property NSString *visitor_goals;
@property NSString *visitor_pos;//possessiong %
@property NSString *visitor_sot;//shots
@property NSString *visitor_son;//shots on target
@property NSUInteger visitor_soff;//offsides
@property NSString *visitor_frk;//free kicks
@property NSString *visitor_blk; //saves
@property NSString *visitor_yc; //yellow cards
@property NSUInteger visitor_rc; //red cards
@property NSString *visitor_tactic;
@property NSMutableArray *visitor_Lineup;
@property NSNumber *pen2;


@end
