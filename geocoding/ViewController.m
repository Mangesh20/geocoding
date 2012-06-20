//
//  ViewController.m
//  GLGeocoder
//
//  Created by Net Admin on 19/06/12.
//  Copyright (c) 2012 . All rights reserved.
//  Author: Mangesh T. (mangesh20@gmail.com)

#import "ViewController.h"
#import "Annotation.h"
@interface ViewController ()

//method to display the annotation on map view for the location returned by geocoding
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

    //Init your coordinated with CLLocation object
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[ibTextFieldForLat.text floatValue] longitude:[ibTextFieldForLong.text floatValue]];
    
    //instance menthod of CLGeocoder for reverse geocoding
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //copy instance variable with placemarks array
        self.placemarksArray = placemarks;
        
        //enumurate the objects from the array and create the address to show in textview
        //the placemarks is an array and it returns the objects of the class CLPlacemark.
        //most of the time the array returns only single address but at some situation it may 
        //return multiple addresses
        [self.placemarksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CLPlacemark *placeInfo = obj;
            
            NSString *address = [NSString stringWithFormat:@"%@",placeInfo.name];
            
            if ([placeInfo.subLocality length]>0) {
                address = [address stringByAppendingFormat:@",%@",placeInfo.subLocality];
            }
            if ([placeInfo.locality length]>0) {
                address = [address stringByAppendingFormat:@",%@",placeInfo.locality];
            }
            if ([placeInfo.country length]>0) {
                address = [address stringByAppendingFormat:@",%@",placeInfo.country];
            }
            if ([placeInfo.postalCode length]>0) {
                address = [address stringByAppendingFormat:@",%@",placeInfo.postalCode];
            }
            
            ibTextViewForAddress.text = [NSString stringWithString:address];
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
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(Annotation *)annotation
{
    static NSString *identifier = @"identifier";
    
    
    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
    
    pinAnnotation.canShowCallout = YES;
    
    
    return pinAnnotation;
}

@end
