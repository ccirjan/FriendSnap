//
//  CameraViewController.m
//  FriendSnap
//
//  Created by cristian cirjan on 1/1/16.
//  Copyright © 2016 cristian cirjan. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    // viewdidload is good for creating things, loading data, and configuring displays once. For data and animations that need to refresh and reappear, we need to use veiwwillappear or viewdidappear
    [super viewDidLoad];
    self.recipients= [[NSMutableArray alloc]init];

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    if (self.image == nil && [self.videoFilePath length] == 0) {
    //    // initialize the picker control
    self.imagePicker =[[UIImagePickerController alloc]init];
    // sets the image picker as the delegate of the camera view controller
    self.imagePicker.delegate=self;
    // not allowing to edit photos yet.
    self.imagePicker.allowsEditing=NO;
    self.imagePicker.videoMaximumDuration= 10;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    [self presentViewController:self.imagePicker animated:NO completion:nil];
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


#pragma mark - Image Picker Controller delegate
// take user to the chat tableview after a picture has been cancelled 
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.tabBarController setSelectedIndex:0];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //show wheyher image or vid
    NSString *mediaType= [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString *) kUTTypeImage]){
        // a photo was taken or selected!
        self.image= [info objectForKey:UIImagePickerControllerOriginalImage];
        //check to see if camera is being used, save if yes
        if(self.imagePicker.sourceType== UIImagePickerControllerSourceTypeCamera){
            //save the image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        
    }
    else {
        //video taken/selected
        NSURL *imagePickerURL =[info objectForKey:UIImagePickerControllerMediaURL];
        self.videoFilePath= [imagePickerURL path];
        if( self.imagePicker.sourceType== UIImagePickerControllerSourceTypeCamera){
            //save the video
            if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)){
                
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);}
            
        }
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // same procedure as in edit friends view controller, except here we're putting our existing relations into the Groups view contorller
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user= [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text=user.username;
    
    // when there are more friends than cells on the screen, cells get reused, but the checkmarks are now distributed to different friends (when you scroll down). This if-else statement fixes that.
    if ([self. recipients containsObject:user.objectId]){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselects users (dehighlights row)immidiately after click
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // this fuction adds users, using a reference to the tableview cell
    // add/delete selected users from our list of friends
    // indicate when a user has been selected
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    PFUser *user =[self.friends objectAtIndex:indexPath.row];
    // adds checkmark to (uncheckmarked) friends, and deletes to (checkmarked) friends
    if(cell.accessoryType==UITableViewCellAccessoryNone) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
    }
    else {
        cell.accessoryType=UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
      NSLog(@"%@", self.recipients);
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
#pragma mark - IBActions



- (IBAction)cancel:(id)sender {
    [self reset];
    
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender {
    if (self.image==nil && [self.videoFilePath length]==0){
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Try Again!" message:@"Please capture or select a photo or video to share!" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        }
    else{
        [self uploadMessage];
        [self reset];
        [self.tabBarController setSelectedIndex:0];
    }
}
#pragma mark - Helper methods
-(void) uploadMessage{
    //Check if image or photo
    // if image, shrink it
    // upload file itself
    // upload message details
    
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if(self.image !=nil){
        // if there is an image to send, we first resize the image in helper method. Then we set file data, name, and type to that resized image. in else clause, we do with video
        UIImage *newImage =[self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData =UIImagePNGRepresentation(newImage);
        fileName=@"image.png";
        fileType=@"image";
    }
    else {
        fileData=[NSData dataWithContentsOfFile:self.videoFilePath];
        fileName=@"video.mov";
        fileType=@"video";
    }
    // PFFfile is the Parse class for files to upload to parse. In this case we are sending the message, which contains our photo or video, and is sent to selected recipients.
    PFFile *file =[PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error){
            UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Error!" message:@"Please send your message again." preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            PFObject *message= [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientsIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *  error) {
                if (error){
                    UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Error!" message:@"Please send your message again." preferredStyle:(UIAlertControllerStyleAlert)];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else{
                    //everything was successful
                    
                }
            }];
            
            
        }
    }];
  
}

- (void)reset {
    self.image=nil;
    self.videoFilePath=nil;
    [self.recipients removeAllObjects];
}
-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height {
    CGSize newSize= CGSizeMake(width, height);
    CGRect newRectangle= CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    // resizes image passed in as an argument
    [image drawInRect:newRectangle];
    UIImage *resizedImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
    
}
@end
