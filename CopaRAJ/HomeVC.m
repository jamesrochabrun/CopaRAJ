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


@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;
    self.matchesData = [NSMutableArray new];
    self.matchesObject = [NSMutableArray new];
    
    
//    [self getMatchesFromJson];
    [self pullMatchesFromCoreData];
    
    [self pullTeamsFromCoreData];
    
    if (self.teams.count == 0) {
        [self createTournamentTeams];
    }
    
    NSLog(@"sqlite dir = \n%@", appDelegate.applicationDocumentsDirectory);

}

//user gets the matches from the API
- (void)getMatchesFromJson {
    
    NSURL *url = [NSURL URLWithString:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&format=json&tz=America/Argentina_city&req=matchs&league=177&year=2016"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        self.matchesData = dictionary[@"match"];
        
        for (NSDictionary *match in self.matchesData) {
            Match *matchObject = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:self.moc];
            matchObject.localAbbr = match[@"local_abbr"];
            matchObject.visitorAbbr = match[@"visitor_abbr"];
            matchObject.hour = match[@"hour"];
            matchObject.minute = match[@"minute"];
            [self.matchesObject addObject:matchObject];
        }
        
//        NSLog(@"%@", self.matchesObject);

            NSError *mocError;
            
            if([self.moc save:&mocError]){
                NSLog(@"this was saved");
            }else{
                NSLog(@"an error has occurred,...%@", error);
            }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
//            NSLog(@"probando %@", self.matchesData);
            [self.tableView reloadData];
        });
    }];
    
    [task resume];
}


//getting results from coredata
- (void)pullMatchesFromCoreData {
    
    self.matchesObject = [NSMutableArray new];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Match"];
    NSError *error;
    self.matchesObject = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
    if(error == nil){
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
    
    NSArray *teamsIntournament = @[@"Argentina", @"Bolivia", @"Brazil", @"Chile", @"Columbia", @"Costa Rica", @"Ecuador", @"Haiti", @"Jamaica", @"Mexico", @"Panama", @"Paraguay", @"Peru", @"Uruguay", @"USA", @"Venezuela"];
    
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
    } else {
        NSLog(@"failed because %@", error);
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
