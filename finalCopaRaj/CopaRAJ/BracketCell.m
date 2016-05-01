//
//  BracketCell.m
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 4/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "BracketCell.h"

@implementation BracketCell


//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
////        self.homeTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
////        self.homeTeamScore = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
////        self.homeTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
////        
////      
////        
////        self.visitorTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
////        self.visitorTeamScore = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
////        self.visitorTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
////        
////        
////        self.winnerTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
////        self.winnerTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//    }
//    return self;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //changing the fonts for the groupVC
    self.homeTeamLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.homeTeamScore.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.homeTeamPenalty.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    
    self.visitorTeamLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.visitorTeamScore.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.visitorTeamPenalty.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    
    self.winnerTeamLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:14];
}

-(void)setFBMatch:(FBMatch *)FBMatch{
    _FBMatch = FBMatch;
  
    //NSLog(@"%@", FBMatch.local_abbr);
    self.homeTeamImageView.image = [UIImage imageNamed:FBMatch.local];
    self.homeTeamLabel.text = FBMatch.local;
    
    self.visitorTeamImageView.image = [UIImage imageNamed:FBMatch.visitor];
    self.visitorTeamLabel.text = FBMatch.visitor;
    
    if ([FBMatch.status isEqual:@1]) {
        self.homeTeamPenalty.enabled = YES;
        self.homeTeamPenalty.text = [NSString stringWithFormat:@"P%@", FBMatch.pen1.stringValue];
        
        self.visitorTeamPenalty.enabled = YES;
        self.visitorTeamPenalty.text = [NSString stringWithFormat:@"P%@", FBMatch.pen2.stringValue];;
    } else {
        self.homeTeamPenalty.enabled = NO;
        self.homeTeamPenalty.hidden = YES;
        
        self.visitorTeamPenalty.enabled = NO;
        self.visitorTeamPenalty.hidden = YES;
    }
    if ([FBMatch.local_goals isEqualToString: @"x"]){
        FBMatch.local_goals = @"";
    } else {
        self.homeTeamScore.text = FBMatch.local_goals;
    }
    
    if ([FBMatch.visitor_goals isEqualToString: @"x"]){
        FBMatch.visitor_goals = @"";
    } else {
        self.visitorTeamScore.text = FBMatch.visitor_goals;
    }
}
@end

//NSString *scoreString = match.score;
//NSArray *seperatedScore = [match.score componentsSeparatedByString:@"-"];
//NSLog(@"THIS IS THE SCORE %@", seperatedScore[0]);
//self.homeTeamScore.text = seperatedScore[0];

//NSLog(@"THIS IS THE SCORE %@", seperatedScore[1]);
//self.visitorTeamScore.text = seperatedScore[1];
