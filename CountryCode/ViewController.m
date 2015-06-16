//
//  ViewController.m
//  CountryCode
//
//  Created by Aftab Mohammed on 2/17/15.
//  Copyright (c) 2015 Aftab Mohammed. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(NSString*)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"sample.sqlite"];
    
    if ([fileManager fileExistsAtPath:txtPath] == NO) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"sqlite"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    }
    
    if ([fileManager fileExistsAtPath:txtPath] == YES) {
        [fileManager removeItemAtPath:txtPath error:&error];
    }
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"sqlite"];
    [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
    
    NSLog(@"DB Path %@",paths);
    return [[paths objectAtIndex:0]stringByAppendingPathComponent:@"sample.sqlite"];
}

//open database
-(void)openDB {
    
    if(sqlite3_open([[self filePath]UTF8String], &database) !=SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Databese failed to open");
    }
    else {
        NSLog(@"database opened");
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
   }


-(IBAction) search: (id) sender
{
    NSString *seartext = self->searchMe.text;
    NSString *capitalizedString = [seartext capitalizedString];
    if ([seartext isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Search field cannot be blank"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    [self openDB];
    
    
    NSString*sql = [NSString stringWithFormat:@"SELECT name, dialcode,code FROM tblName WHERE dialcode=\"+%@\"",capitalizedString];
    
    const char *query_stmt = [sql UTF8String];
    NSLog(@"%@",sql);
    sqlite3_stmt*statement;
    
    if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, nil)==SQLITE_OK) {
        
        if (sqlite3_step(statement)==SQLITE_ROW) {
            NSString *customer = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            countryname.text = customer;
            NSString *code1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            countrycode.text = code1;
            NSString *code2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,2)];
            countryshortname.text = code2;
            reslut.text = @"Result";
            NSString *myNewString =[customer stringByReplacingOccurrencesOfString:@" " withString:@"-"];
            NSString *imagefile;
            imagefile=[NSString stringWithFormat:@"%@.png",myNewString];
            UIImage *image = [UIImage imageNamed:imagefile];
            myImage.image = image;
        }
        else{
             reslut.text = @"Record Not found";
            myImage.image = nil;
            countryname.text = nil;
            countrycode.text = nil ;
            countryshortname.text = nil;
            self->searchMe.text= @"";
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
