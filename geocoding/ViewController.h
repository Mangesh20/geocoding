//  geocoding
//  Class Name: ViewController.h
//  Abstract: In this class we have imported the CoreLocation and MapKit framework. Created the object of class CLGeocoder for geocoding.  
//
//  Created by Net Admin on 19/06/12.
//  Copyright (c) 2012 . All rights reserved.
//  Author: Mangesh T. (mangesh20@gmail.com)
//  


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate, MKMapViewDelegate>
{
    CLGeocoder *geocoder;
    NSArray *placemarksArray;

}
@property (strong, nonatomic) IBOutlet UITextField *ibTextFieldForLat;
@property (strong, nonatomic) IBOutlet UITextField *ibTextFieldForLong;
@property (strong, nonatomic) IBOutlet UIButton *ibButtonForGetAddress;
@property (strong, nonatomic) IBOutlet UIButton *ibButtonForGetLatLong;
@property (strong, nonatomic) IBOutlet UITextView *ibTextViewForAddress;
@property (strong, nonatomic) NSArray *placemarksArray;
@property (strong, nonatomic) IBOutlet MKMapView *mapViewForAnnotation;

- (IBAction)getAddress:(id)sender;
- (IBAction)getLatLong:(id)sender;
- (IBAction)resignKeyboard:(id)sender;

@end
