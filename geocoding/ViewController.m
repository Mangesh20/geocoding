//
//  ViewController.m
//  GLGeocoder
//
//  Created by Net Admin on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Annotation.h"
@interface ViewController ()
- (void)displayAnnotationWitPlacemarksArray;
@end

@implementation ViewController
@synthesize ibTextFieldForLat;
@synthesize ibTextFieldForLong;
@synthesize ibButtonForGetAddress;
@synthesize ibButtonForGetLatLong;
@synthesize ibTextViewForAddress;
@synthesize placemarksArray;
@synthesize mapViewForAnnotation;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    geocoder = [[CLGeocoder alloc] init];

}

- (void)viewDidUnload
{
    [self setIbTextFieldForLat:nil];
    [self setIbTextFieldForLong:nil];
    [self setIbButtonForGetAddress:nil];
    [self setIbButtonForGetLatLong:nil];
    [self setIbTextViewForAddress:nil];
    self.placemarksArray = nil;
    [self setMapViewForAnnotation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)getAddress:(id)sender {
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[ibTextFieldForLat.text floatValue] longitude:[ibTextFieldForLong.text floatValue]];
    
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        self.placemarksArray = placemarks;
     
        
        [self.placemarksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CLPlacemark *placeInfo = obj;
            ibTextViewForAddress.text = [NSString stringWithFormat:@"%@, %@, %@, %@, %@",placeInfo.name,placeInfo.subLocality, placeInfo.locality,placeInfo.country, placeInfo.postalCode];
        }];

        [self displayAnnotationWitPlacemarksArray];

        NSLog(@"%@",error);
    }];
    
}

- (IBAction)getLatLong:(id)sender {
    [geocoder geocodeAddressString:ibTextViewForAddress.text completionHandler:^(NSArray *placemarks, NSError *error) {
        self.placemarksArray = placemarks;
        CLPlacemark *placeInfo = [placemarks objectAtIndex:0];
        ibTextFieldForLat.text = [NSString stringWithFormat:@"%f",placeInfo.location.coordinate.latitude ];
        ibTextFieldForLong.text = [NSString stringWithFormat:@"%f",placeInfo.location.coordinate.longitude ];
        
        [self displayAnnotationWitPlacemarksArray];

    }];
}


- (void)displayAnnotationWitPlacemarksArray
{

    NSLog(@"Placemarks Array %@",placemarksArray);
    
    Annotation *annotaion = [[Annotation alloc] init];
    NSMutableArray *arrayForAnnotation = [[NSMutableArray alloc] init];
    
    
    [self.placemarksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CLPlacemark *placeInfo = obj;
        //placeInfo.region.radius can be used to draw overlay
        annotaion.coordinate = placeInfo.location.coordinate;
        annotaion.title = placeInfo.name;
        annotaion.subtitle = placeInfo.country;
        [arrayForAnnotation addObject:annotaion];
        
        MKCoordinateRegion region;
        region.center.latitude = placeInfo.location.coordinate.latitude;
        region.center.longitude = placeInfo.location.coordinate.longitude;
        region.span.latitudeDelta = 0.05;
        region.span.longitudeDelta = 0.05;
        [mapViewForAnnotation setRegion:region];
        
    }];
    [self.mapViewForAnnotation addAnnotations:arrayForAnnotation];
    


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)resignKeyboard:(id)sender {
    [ibTextViewForAddress resignFirstResponder];
    [ibTextFieldForLat resignFirstResponder];
    [ibTextFieldForLong resignFirstResponder];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"identifier";
    MKPinAnnotationView *pinAnnotation;
    
    
    if (pinAnnotation == nil) {
        pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    [pinAnnotation setDraggable:YES];
    pinAnnotation.canShowCallout = YES;
    return pinAnnotation;
}

@end
