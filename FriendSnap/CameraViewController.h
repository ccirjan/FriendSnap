//
//  CameraViewController.h
//  FriendSnap
//
//  Created by cristian cirjan on 1/1/16.
//  Copyright © 2016 cristian cirjan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSMutableArray * recipients;

- (IBAction)cancel:(id)sender;


@end
