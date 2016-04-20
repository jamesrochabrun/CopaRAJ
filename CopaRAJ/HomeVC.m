//
//  HomeVC.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "HomeVC.h"
#import "HomeTableViewCell.h"
#import "Match.h"
#import "AppDelegate.h"
#import "Team.h"


@interface HomeVC ()<UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *matchesData;
@property NSMutableArray *matchesObject;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property Match *matchObject;


@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;
    self.matchesData = [NSMutableArray new];
    self.matchesObject = [NSMutableArray new];
    
    [self updateMatchesFromJson];
    
    [self pullMatchesFromCoreData];
    
    if (self.matchesObject.count == 0) {
    [self getMatchesFromJsonAndSaveInCoreData];
    }else if (self.matchesObject.count > 0)
    
    
    [self pullTeamsFromCoreData];
    if (self.teams.count == 0) {
        [self createTournamentTeams];
    }
    
    NSLog(@"sqlite dir = \n%@", appDelegate.applicationDocumentsDirectory);
    
}

//user gets the matches from the API
- (void)getMatchesFromJsonAndSaveInCoreData {
    
    for (int i = 1; i< 4; i++) {
        
        NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=matchs&format=json&tz=America/Chicago&lang=en&league=177&round=%i",i];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            self.matchesData = dictionary[@"match"];
            
            for (NSDictionary *match in self.matchesData) {
                
                self.matchObject = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:self.moc];
                self.matchObject.localAbbr = match[@"local_abbr"];
                self.matchObject.visitorAbbr = match[@"visitor_abbr"];
                
                //testing
                self.matchObject.groupCode = match[@"round"];
                NSLog(@"%@ vs %@ in round %@", self.matchObject.visitorAbbr, self.matchObject.localAbbr, self.matchObject.groupCode);
                
                self.matchObject.hour = match[@"hour"];
                self.matchObject.minute = match[@"minute"];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
                [dateFormat setDateFormat:@"yyyy/MM/dd"];
                NSDate *date = [dateFormat dateFromString:match[@"date"]];
                self.matchObject.date = date;
                [self.matchesObject addObject:self.matchObject];

            }
            
            NSError *mocError;
            if([self.moc save:&mocError]){
                NSLog(@"this was saved and there are %lu", self.matchesObject.count);
            }else{
                NSLog(@"an error has occurred,...%@", error);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [self.tableView reloadData];
            });
        }];
        [task resume];
    }
}

- (void)updateMatchesFromJson {
    
    for (int i = 1; i< 4; i++) {
        
        NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=matchs&format=json&tz=America/Chicago&lang=en&league=177&round=%i",i];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            self.matchesData = dictionary[@"match"];
            
            for (NSDictionary *match in self.matchesData) {
                
//                self.matchObject = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:self.moc];
                self.matchObject.localAbbr = match[@"local_abbr"];
                self.matchObject.visitorAbbr = match[@"visitor_abbr"];
                
                //testing
                self.matchObject.groupCode = match[@"round"];
                NSLog(@"%@ vs %@ in round %@", self.matchObject.visitorAbbr, self.matchObject.localAbbr, self.matchObject.groupCode);
                
                self.matchObject.hour = match[@"hour"];
                self.matchObject.minute = match[@"minute"];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
                [dateFormat setDateFormat:@"yyyy/MM/dd"];
                NSDate *date = [dateFormat dateFromString:match[@"date"]];
                self.matchObject.date = date;
//                [self.matchesObject addObject:self.matchObject];
            }
            
            NSError *mocError;
            if([self.moc save:&mocError]){
                NSLog(@"this was saved and there are %lu", self.matchesObject.count);
            }else{
                NSLog(@"an error has occurred,...%@", error);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [self.tableView reloadData];
            });
        }];
        [task resume];
    }

    
    
}


- (void)pullMatchesFromCoreData {
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Match"];
    
    NSError *error;
    
    NSMutableArray *coreDataArray = [NSMutableArray new];
    coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
    
    if(error == nil){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        self.matchesObject = [[coreDataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
        [self.tableView reloadData];

    }else{
        NSLog(@"Error: %@", error);
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchesObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Match *match = [self.matchesObject objectAtIndex:indexPath.row];
    cell.teamOneName.text = match.localAbbr;
    cell.teamTwoName.text = match.visitorAbbr;
    
    //testing
    cell.locationLabel.text = match.groupCode;
    return cell;
}


- (void)pullTeamsFromCoreData {
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Team"];
    NSError *error;
    NSMutableArray *coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
    
    if (error == nil) {
        self.teams = [[NSMutableArray alloc]initWithArray:coreDataArray];
    } else {
        NSLog(@"%@", error);
    }
    
    if (self.teams.count == 0) {
        NSLog(@"Core data doesn't have any teams");
        [self createTournamentTeams];
        
    }
}

- (void)createTournamentTeams {
    
    NSArray *teamsIntournament = @[@"Argentina", @"Bolivia", @"Brazil", @"Chile", @"Colombia", @"Costa Rica", @"Ecuador", @"Haiti", @"Jamaica", @"Mexico", @"Panama", @"Paraguay", @"Peru", @"Uruguay", @"USA", @"Venezuela"];
    
    NSArray *teamAbbrevs = @[@"ARG", @"BOL", @"BRA", @"CHI", @"COL", @"CRC", @"ECU", @"HAI", @"JAM", @"MEX", @"PAN", @"PAR", @"PER", @"URU", @"USA", @"VEN"];
    
    self.teams = [NSMutableArray new];
    int index = 0;
    for (NSString *teamName in teamsIntournament) {
        Team *newTeam = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.moc];
        [newTeam createDefaultTeamSettingsForTeam:newTeam andName:teamName];
        
        NSString *abr = [teamAbbrevs objectAtIndex:index];
        newTeam.abbreviationName = abr;
        index++;

        [self.teams addObject:newTeam];
    }
    
    NSError *error;
    if ([self.moc save:&error]) {
        NSLog(@"teams was saved to coredata");
    } else {
        NSLog(@"failed because %@", error);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
