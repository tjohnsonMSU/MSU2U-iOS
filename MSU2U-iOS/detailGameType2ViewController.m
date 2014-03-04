//
//  detailGameType2ViewController.m
//  MSU2U-iOS
//
//  Created by Hieu Tran on 1/22/14.
//  Copyright (c) 2014 Matthew Farmer. All rights reserved.
//

#import "detailGameType2ViewController.h"

@interface detailGameType2ViewController ()

@end

@implementation detailGameType2ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup the text in the navigation bar
    self.title = receivedGame.category;
    
    //Set your labels
  //  self.titleLabel.text = receivedGame.title;
    self.locationLabel.text = receivedGame.location;
    NSLog(@"The date is %@\n",receivedGame.startdate);
    self.startingDateLabel.text = [NSDateFormatter localizedStringFromDate:receivedGame.startdate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
//    self.hostPlaceName.text = receivedGame.hostplace;
    
    //Setup the images
    if([receivedGame.isHomeGame isEqualToString:@"yes"])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            [self downloadImageForHome:receivedGame.teamlogo andAway:receivedGame.opponentlogo];
        });
        
        //Set the home label to say 'Midwestern State'
       // self.hostPlaceName.text = @"Midwestern State";
        if ([receivedGame.title rangeOfString:@" at "].location==NSNotFound)
        {
            //'vs' was used
            NSArray * components = [receivedGame.title componentsSeparatedByString:@"  "];
            NSString *trimmedText = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.awayTeamName.text = (NSString *)trimmedText;
        }
/*        else if([receivedGame.title rangeOfString:@" at "].location== NSNotFound)
        {
            NSArray * components = [receivedGame.title componentsSeparatedByString:@" vs " ];
            NSString *trimmedText = [[components objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.awayTeamName.text = (NSString *)trimmedText;
        } */
        else
        {
            NSArray * components = [receivedGame.title componentsSeparatedByString:@" at "];
            NSString *trimmedText = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.awayTeamName.text = (NSString *)trimmedText;
        }
        
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            [self downloadImageForHome:receivedGame.opponentlogo andAway:receivedGame.teamlogo];
        });
      //  self.awayTeamName.text = @"Midwestern State";
      //  self.awayTeamName.text = receivedGame.
        if ([receivedGame.title rangeOfString:@" at "].location==NSNotFound)
        {
            //'vs' was used
            NSArray * components = [receivedGame.title componentsSeparatedByString:@"  "];
            NSString *trimmedText = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.awayTeamName.text = (NSString *)trimmedText;
        }
    /*    else if([receivedGame.title rangeOfString:@" at "].location== NSNotFound)
        {
            NSArray * components = [receivedGame.title componentsSeparatedByString:@" vs " ];
            NSString *trimmedText = [[components objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.awayTeamName.text = (NSString *)trimmedText;
        }*/
        else
        {
            NSArray * components = [receivedGame.title componentsSeparatedByString:@" at "];
            NSString *trimmedText = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.awayTeamName.text = (NSString *)trimmedText;
        }
    }

 
}
-(void)sendGameInformation:(Game*)gameInfo
{
    receivedGame = gameInfo;
    receivedGame.teamlogo = @"http://www.msumustangs.com/images/logos/m6.png";
}


-(void)downloadImageForHome:(NSString*)homeTeam andAway:(NSString *)awayTeam
{
//    homeTeam = [homeTeam stringByReplacingOccurrencesOfString:@" " withString:@""];
    awayTeam = [awayTeam  stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"My hometeam URL is %@\n",homeTeam);
    
//    [self.homePhoto setImageWithURL:[NSURL URLWithString:homeTeam] placeholderImage:[UIImage imageNamed:@"ncaa_default.png"] options:0 andResize:CGSizeMake(50, 50)];
    [self.awayPhoto setImageWithURL:[NSURL URLWithString:awayTeam] placeholderImage:[UIImage imageNamed:@"ncaa_default.png"] options:0 andResize:CGSizeMake(50,50)];
    
    CGSize size = {50,50};
//    self.homePhoto.image = [self imageWithImage:self.homePhoto.image scaledToSize:size];
    self.awayPhoto.image = [self imageWithImage:self.awayPhoto.image scaledToSize:size];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)addToCalendar {
    //Setup the variables for this game in the addEventToMainCalendar class
    addEventToCalendar * myCal = [[addEventToCalendar alloc]init];
    
    NSLog(@"Well, the date on my end before sending to addEventToMainCalendar is %@\n",receivedGame.startdate);
    myCal.calendarEventTitle = receivedGame.title;
    myCal.calendarEventStartDate = receivedGame.startdate;
    myCal.calendarEventEndDate = receivedGame.enddate;
    [myCal addEventToMainCalendar];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                //TODO
                [self showInMap];
                break;
            }
            case 1:
            {
                [self addToCalendar];
                break;
            }
            default:
                break;
        }
    }
}


-(void)showInMap
{
    // Check for iOS 6
    
    if(![receivedGame.location isEqualToString:@"TBA"])
    {
        Class mapItemClass = [MKMapItem class];
        
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:receivedGame.location
                         completionHandler:^(NSArray *placemarks, NSError *error) {
                             
                             // Convert the CLPlacemark to an MKPlacemark
                             // Note: There's no error checking for a failed geocode
                             CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
                             MKPlacemark *placemark = [[MKPlacemark alloc]
                                                       initWithCoordinate:geocodedPlacemark.location.coordinate
                                                       addressDictionary:geocodedPlacemark.addressDictionary];
                             
                             // Create a map item for the geocoded address to pass to Maps app
                             MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                             [mapItem setName:geocodedPlacemark.name];
                             
                             // Set the directions mode to "Driving"
                             // Can use MKLaunchOptionsDirectionsModeWalking instead
                             NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
                             
                             // Get the "Current User Location" MKMapItem
                             MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                             
                             // Pass the current location and destination map items to the Maps app
                             // Set the direction mode in the launchOptions dictionary
                             [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
                             
                         }];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Location TBA #msu2u"
                              message:@"Sorry, the event location is TBA (To Be Announced)"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)sharePressed:(UIBarButtonItem *)sender
{
    // Create the item to share (in this example, a url)
    SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"%@ in %@",receivedGame.title,receivedGame.location]];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
@end
