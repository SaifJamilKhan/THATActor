//
//  ViewController.m
//  CarChecker
//
//  Created by Saif Khan on 2013-08-17.
//  Copyright (c) 2013 Saif Khan. All rights reserved.
//

#import "feeder.h"

@interface feeder ()
@property (strong, nonatomic) IBOutlet UITextField *makeText;
@property (strong, nonatomic) IBOutlet UITextField *modelText;

@end

@implementation feeder
{
      NSArray *tableData;
     UITableView *ishaTable;
    UINavigationBar *navBar;
    UINavigationItem *navItem;
 //   IBOutlet UINavigationItem *navItem;
    
}
@synthesize ishaTable;
@synthesize navBar;
@synthesize navItem;
@synthesize responseData;
- (void)viewDidLoad
{
    [super viewDidLoad];
      tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];

    
    
     ishaTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    ishaTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [ishaTable reloadData];
    
    
    
    UINavigationItem *backItem = [[UINavigationItem alloc] initWithTitle:@"Back"];
    [navBar pushNavigationItem:backItem animated:NO];
    
    UINavigationItem *topItem = [[UINavigationItem alloc] initWithTitle:@"Search Screen"];
    [navBar pushNavigationItem:topItem animated:NO];
    
    [self.view addSubview:navBar];
    //self.view = ishaTable;
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)searchButton:(id)sender {
    [self.view endEditing:YES];
    
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=3trp2fnpcwacm76xp6779uca&q=%@&page=1", [self.makeText.text stringByReplacingOccurrencesOfString:@" " withString:@"+"] ]]];
  
    
    NSLog(@"%@",[NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=3trp2fnpcwacm76xp6779uca&q=%@&page=1", [self.makeText.text stringByReplacingOccurrencesOfString:@" " withString:@"+"] ]);
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item { //if you want to dismiss the controller presented, you can do that here or the method btnBackClicked
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma TableView Section ------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *simpleTableIdentifier = [NSString stringWithFormat:@"ITEM"];//@"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma API Response Section ------------------------------------------------------------------------------


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res =[NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:&myError];
    
    
    res = [res dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"movies"]] ;

    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
        //NSRange range = [valueAsString rangeOfString:@"name = "];
      
        NSMutableArray *characters = [[NSMutableArray alloc] init];
        NSUInteger count = 0, length = [valueAsString length];
        NSRange range = NSMakeRange(0, length);
        while(range.location != NSNotFound)
        {
            range = [valueAsString rangeOfString: @"name = " options:0 range:range];
            if(range.location != NSNotFound)
            {
                
                [characters addObject:[valueAsString stringByReplacingCharactersInRange:range withString:valueAsString] ];
                 
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count++;
               
            }
        }
        
        
        
        NSString *characterName = [[valueAsString substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    // extract specific value...
    //res = [res ob]
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
    
}



@end
