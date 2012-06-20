//
//  ViewController.h
//  GLGeocoder
//
//  Created by Net Admin on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate, MKMapViewDelegate>
{
    CLGeocoder *geocoder;
    NSArray *placemarksArray;

}
- (IBAction)resignKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *ibTextFieldForLat;
@property (strong, nonatomic) IBOutlet UITextField *ibTextFieldForLong;
@property (strong, nonatomic) IBOutlet UIButton *ibButtonForGetAddress;
@property (strong, nonatomic) IBOutlet UIButton *ibButtonForGetLatLong;
@property (strong, nonatomic) IBOutlet UITextView *ibTextViewForAddress;
@property (strong, nonatomic) NSArray *placemarksArray;
@property (strong, nonatomic) IBOutlet MKMapView *mapViewForAnnotation;

- (IBAction)getAddress:(id)sender;
- (IBAction)getLatLong:(id)sender;

@end
