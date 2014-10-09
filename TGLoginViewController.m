
#import "TGSideMenuViewController.h"
#import "TGMenuViewController.h"
#import "TGLoginViewController.h"
#import "Comms.h"

@interface TGLoginViewController () <CommsDelegate>

@end

@implementation TGLoginViewController
@synthesize facebookBtn;
@synthesize usernameText;
@synthesize passwordText;
@synthesize submitBtn;
@synthesize indicatorView;

-(void) commsDidLogin:(BOOL)loggedIn{
  
    [facebookBtn setEnabled:YES];
    [indicatorView stopAnimating];
    if (loggedIn) {
        TGMenuViewController *main = [[TGMenuViewController alloc]init];
        
        [self.sideMenuViewController openMenuAnimated:YES completion:nil];
      [main viewDidAppear:YES];
    }
    else {
        //alert::failed to log in
        [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"Facebook Login failed. Please try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    usernameText.delegate = self;
    passwordText.delegate = self;

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == usernameText) {
        [textField resignFirstResponder];
        [passwordText becomeFirstResponder];
    }
    else if (textField == passwordText) {
        [self loggedIn];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loggedIn {
    [indicatorView startAnimating];
    [PFUser logInWithUsernameInBackground:usernameText.text password:passwordText.text block:^(PFUser *user, NSError *error) {
        if (!error) {
            NSLog(@"Login user!");
          //instead of  [self dismissViewControllerAnimated:YES completion:nil];
            [self.sideMenuViewController openMenuAnimated:YES completion:nil];
            passwordText.text = nil;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ooops!" message:@"Sorry we had a problem logging you in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            usernameText.text = nil;
            passwordText.text = nil;
            [usernameText becomeFirstResponder];
        }
    }];
}

#pragma mark - UIActions

- (IBAction)fbLogin:(id)sender {
    [facebookBtn setEnabled:NO];
    [indicatorView startAnimating];
    // Do the login
    [Comms login:self];
}

- (IBAction)login:(id)sender {
    [self loggedIn];
}
@end
