//
//  GroupsViewController.m
//  FriendSnap
//
//  Created by cristian cirjan on 1/1/16.
//  Copyright © 2016 cristian cirjan. All rights reserved.
//

#import "GroupsViewController.h"
#import "EditFriendsViewController.h"

@interface GroupsViewController ()

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    self.friendsRelation= [[PFUser currentUser] relationForKey:@"friendsRelation"];
//    PFQuery *query = [self.friendsRelation query];
//    [query orderByAscending:@"username"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError *  error) {
//        if(error) {
//            NSLog(@"%@ %@", error, [error userInfo]);
//        }
//        else{
//            self.friends=objects;
//            [self.tableView reloadData];
//        }
//    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    // get friends relation using relation for key method. we add any kind of objects by giving them a string key, and then we can acess them by using the relation for key method
    self.friendsRelation= [[PFUser currentUser] relationForKey:@"friendsRelation"];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError *  error) {
        if(error) {
            NSLog(@"%@ %@", error, [error userInfo]);
        }
        else{
            self.friends=objects;
            [self.tableView reloadData];
        }
    }];
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEditFriends"]){
        // set destination viewcontroller and cast it to editfriendsviewcontroller
        EditFriendsViewController *viewController= (EditFriendsViewController *)segue.destinationViewController;
        viewController.friends= [NSMutableArray arrayWithArray:self.friends];
    }
}







//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // same procedure as in edit friends view controller, except here we're putting our existing relations into the Groups view contorller
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user= [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text=user.username;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
