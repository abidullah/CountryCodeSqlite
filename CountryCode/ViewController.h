//
//  ViewController.h
//  CountryCode
//
//  Created by Aftab Mohammed on 2/17/15.
//  Copyright (c) 2015 Aftab Mohammed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface ViewController : UIViewController
{
    NSArray *BDVCountryNameAndCodePlist;
    NSMutableDictionary *dictDialingCodes;
    NSMutableArray *countryNames;
    NSMutableArray *prefixDialingCodes;
    sqlite3 * database;
    
    IBOutlet UILabel *countryname;
    IBOutlet UILabel *countrycode;
    IBOutlet UILabel *countryshortname;
    IBOutlet UISearchBar *searchMe;
    IBOutlet UILabel *reslut;
    IBOutlet UIImageView *myImage;

}

@end

