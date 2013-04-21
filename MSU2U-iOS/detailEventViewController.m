//
//  detailEventViewController.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/12/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "detailEventViewController.h"

@interface detailEventViewController ()
@end

@implementation detailEventViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*UIImageView *tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [tempImg setImage:[UIImage imageNamed:@"womensoccerBG.png"]];
    [self.tableView setBackgroundView:tempImg];
    */
    [self orientationChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell.backgroundColor = [UIColor colorWithRed:(185.0/255.0) green:(142.0/255.0) blue:(47.0/255.0) alpha:1];
    //cell.backgroundView.backgroundColor = [UIColor colorWithRed:(185.0/255.0) green:(142.0/255.0) blue:(47.0/255.0) alpha:1];
    cell.backgroundView.alpha = 0.9;
}

- (void)orientationChanged
{
    //[self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    NSLog(@"Whoa we shifted?! orientation == %d\n",[[UIDevice currentDevice]orientation]);
    
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
    {
        UIImageView *tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [tempImg setImage:[UIImage imageNamed:@"twitterBG.png"]];
        [self.tableView setBackgroundView:tempImg];
    }
    else if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait)
    {
        UIImageView *tempImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        [tempImg setImage:[UIImage imageNamed:@"womensoccerBG.png"]];
        [self.tableView setBackgroundView:tempImg];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup the text in the navigation bar
    self.title = receivedEvent.category;
    
    //Set your labels
    self.titleLabel.text = receivedEvent.title;
    self.locationLabel.text = receivedEvent.location;
    NSLog(@"The date is %@\n",receivedEvent.startdate);
    self.startingDateLabel.text = [NSDateFormatter localizedStringFromDate:receivedEvent.startdate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    //Setup the images
    if([receivedEvent.isHomeGame isEqualToString:@"yes"])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            [self downloadImageForHome:receivedEvent.teamlogo andAway:receivedEvent.opponentlogo];
        });
        
        //Set the home label to say 'Midwestern State'
        self.homeTeamName.text = @"Midwestern State";
        
        if ([receivedEvent.title rangeOfString:@" at "].location==NSNotFound)
        {
            //'vs' was used
            NSArray * components = [receivedEvent.title componentsSeparatedByString:@" vs "];
            NSString *trimmedText = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.awayTeamName.text = (NSString *)trimmedText;
        }
        else
        {
            NSArray * components = [receivedEvent.title componentsSeparatedByString:@" at "];
            NSString *trimmedText = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.awayTeamName.text = (NSString *)trimmedText;
        }
        
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            [self downloadImageForHome:receivedEvent.opponentlogo andAway:receivedEvent.teamlogo];
        });
        self.awayTeamName.text = @"Midwestern State";
        
        if ([receivedEvent.title rangeOfString:@" at "].location==NSNotFound)
        {
            //'vs' was used
            NSArray * components = [receivedEvent.title componentsSeparatedByString:@" vs "];
            NSString *trimmedText = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.homeTeamName.text = (NSString *)trimmedText;
        }
        else
        {
            NSArray * components = [receivedEvent.title componentsSeparatedByString:@" at "];
            NSString *trimmedText = [[components objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            self.homeTeamName.text = (NSString *)trimmedText;
        }
    }
}

-(void)sendEventInformation:(Event*)eventInfo
{
    receivedEvent = eventInfo;
    receivedEvent.teamlogo = @"http://www.msumustangs.com/images/logos/m6.png";
    //Give the addEventToCalendarClass the event information so that the event can be added to the calendar if required
    /*self.title = receivedEvent.category;
    self.startDate = self.receivedStartDate;
    self.startTime = self.receivedStartTime;*/
}

-(void)downloadImageForHome:(NSString*)homeTeam andAway:(NSString *)awayTeam
{
    homeTeam = [homeTeam stringByReplacingOccurrencesOfString:@" " withString:@""];
    awayTeam = [awayTeam stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self.homePhoto setImageWithURL:[NSURL URLWithString:homeTeam]
                  placeholderImage:[UIImage imageNamed:@"Default.png"]];
    [self.awayPhoto setImageWithURL:[NSURL URLWithString:awayTeam]
                  placeholderImage:[UIImage imageNamed:@"Default.png"]];
    
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)addToCalendar {
    //Setup the variables for this event in the addEventToMainCalendar class
    addEventToCalendar * myCal = [[addEventToCalendar alloc]init];
    
    NSLog(@"Well, the date on my end before sending to addEventToMainCalendar is %@\n",receivedEvent.startdate);
    myCal.calendarEventTitle = receivedEvent.title;
    myCal.calendarEventStartDate = receivedEvent.startdate;
    myCal.calendarEventEndDate = receivedEvent.enddate;
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
    
    if(![receivedEvent.location isEqualToString:@"TBA"])
    {
        Class mapItemClass = [MKMapItem class];
        
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:receivedEvent.location
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
                         initWithTitle:@"Location TBA"
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
    NSURL *url = [NSURL URLWithString:receivedEvent.link];
    SHKItem *item = [SHKItem URL:url title:receivedEvent.title contentType:SHKURLContentTypeWebpage];
    
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

@end
