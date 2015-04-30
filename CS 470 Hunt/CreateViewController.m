//
//  CreateViewController.m
//  CS 470 Hunt
//
//  Created by student on 4/27/15.
//  Copyright (c) 2015 PaulRileyJulian. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()


@property (weak, nonatomic) IBOutlet UITextField *huntTitle;
@property (weak, nonatomic) IBOutlet UILabel *stepNum;
@property (weak, nonatomic) IBOutlet UIButton *takePicture;
@property (weak, nonatomic) IBOutlet UIImageView *stepImage;
@property (weak, nonatomic) IBOutlet UITextView *stepDesc;
@property (weak, nonatomic) IBOutlet UIButton *submitStep;
@property (weak, nonatomic) IBOutlet UIButton *finishHunt;

@property (nonatomic) CreateDataSource *dataSource;
@property (nonatomic) ALAssetsLibrary *library;

@property (nonatomic) NSMutableArray * listOfStepDescriptions;
@property (nonatomic) NSMutableArray * listOfStepImages;


@end


@implementation CreateViewController

@synthesize huntTitle;
@synthesize stepDesc;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.huntTitle.delegate = self;
    self.stepDesc.delegate = self;
    self.library = [[ALAssetsLibrary alloc] init];
    
    self.listOfStepDescriptions = [[NSMutableArray alloc]init];
    self.listOfStepImages = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitStepForHunt:(UIButton *)sender
{
    NSLog( @"Submit step" );
    [self.listOfStepDescriptions addObject:self.stepDesc.text];
    
    NSLog([self.listOfStepDescriptions description]);

    [self.listOfStepImages addObject:self.stepImage.image];
    
    stepDesc.text = @"";
}


- (IBAction)submitHunt:(UIButton *)sender
{
    NSLog( @"submit hunt" );
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy"];
    
    NSString *todayDate = [dateFormatter stringFromDate:date];
    
    NSLog( @"Todays Date: %@ Hunt Title: %@", todayDate, self.huntTitle.text);
    
    NSString *huntURLString = [NSString stringWithFormat:@"http://cs.sonoma.edu/~ppfeffer/470/pullData.py?rType='setHuntName=%@---setHuntDate=%@", self.huntTitle.text, todayDate];
    huntURLString = [huntURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    int i=0;
    NSString *tempURL = @"www";
//    NSString *tempURL = @"http://cbsnews2.cbsistatic.com/hub/i/r/2013/02/25/5788bb54-a645-11e2-a3f0-029118418759/thumbnail/620x350/cff879d1606b94fcffbf565dbc556ddf/The-International-Herald-Tribune.jpg";
    //Loop through array of steps Descriptions
    for (NSString *curStep in self.listOfStepDescriptions) {
        i++;
        NSString *stepURLString = [NSString stringWithFormat:@"http://cs.sonoma.edu/~ppfeffer/470/pullData.py?rType=huntName=%@---stepDesc=%@---urlPath=%@---stepNum=%d", self.huntTitle.text, curStep, tempURL,i];
        stepURLString = [stepURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.dataSource = [[CreateDataSource alloc] initWithHuntString:stepURLString];  // Have faith daniel son

    }
    
    self.dataSource = [[CreateDataSource alloc] initWithHuntString:huntURLString];
    
}


- (IBAction)takePictureButtonPressed:(UIButton *)sender
{
    NSLog(@"Open Camera roll");
    
    UIAlertView *chose = [[UIAlertView alloc] initWithTitle:@"Upload Photo" message:@"How would you like to add a photo?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Camera", @"Photo Library", nil];
    [chose show];
    
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0)
        NSLog( @"pressed cancel" );
    else if( buttonIndex == 1 )
    {
        NSLog( @"pressed camera" );
        UIAlertView *cameraAlert = [[UIAlertView alloc] initWithTitle:@"Simulator Error" message:@"Simulator does not allow the camera to be used" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];

        [cameraAlert show];
//        UIImagePickerController *takePhoto = [[UIImagePickerController alloc] init];
//    
//        takePhoto.delegate = self;
//        takePhoto.allowsEditing = YES;
//        takePhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:takePhoto animated:YES completion:nil];
    }
    else if ( buttonIndex == 2 )
    {
        NSLog( @"pressed photo Library" );
        UIImagePickerController *pickImage = [[UIImagePickerController alloc] init];
        pickImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickImage.delegate = self;
        [self presentViewController:pickImage animated:YES completion:nil];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.stepImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    

//    NSLog( @"image desc: %@", self.stepImage.isAnimating );
    NSURL *imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    [self.library assetForURL:imageURL resultBlock:^(ALAsset *asset){
        ALAssetRepresentation *r = [asset defaultRepresentation];
        self.stepImage.image = [UIImage imageWithCGImage: r.fullResolutionImage];
        
    }failureBlock:nil];
    
    
    
    
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog( @"text field did begin editing" );
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSLog( @"text field did end editing" );
    NSLog( @"hunt Title: %@", self.huntTitle.text );
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    NSLog( @"text view did begin editing" );
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    NSLog( @"done editing text view" );
    NSLog( @"step description: %@", self.stepDesc.text );
}






//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//}


@end
