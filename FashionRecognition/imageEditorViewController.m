#import "imageEditorViewController.h"
#import "Pocket_Closet-Swift.h"

#import <AdobeCreativeSDKLabs/AdobeLabsUXMagicSelectionView.h>
#import <AdobeCreativeSDKCore/AdobeUXAuthManager.h>

#define CC_CLIENT_ID                @"9f756b4516444a9d8d20ea4f2cc58f60"
#define CC_CLIENT_SECRET            @"184a1df5-bf27-4be5-af5f-4d3a1732506e"

#define BUTTON_X_MARGIN             0
#define BUTTON_Y_MARGIN             20
#define BUTTON_Y_OFFSET             0
#define BUTTON_WIDTH                120
#define BUTTON_HEIGHT               60
#define VIEW_Y_OFFSET               (BUTTON_Y_MARGIN + (2*(BUTTON_Y_OFFSET+BUTTON_HEIGHT)))
#define BUTTON_TITLE_FOREGROUND     @"SELECT ITEM AREA"
#define BUTTON_TITLE_BACKGROUND     @"Mark Background"
#define BUTTON_TITLE_MIXED          @"Mark Mixed"
#define BUTTON_TITLE_CLEAR          @"REDO"
#define BUTTON_TITLE_SHOW_RESULTS   @"SHOW EDITED ITEM"
#define BUTTON_TITLE_LOAD_PUPPY     @"画像読込"
#define BUTTON_TITLE_LOGOUT         @"Logout"
#define PUPPY_IMAGE_NAME            @"puppy.jpg"

@interface imageEditorViewController()

@end

@implementation imageEditorViewController {
    AdobeLabsUXMagicSelectionView * _magicSelectionView;
    UIImageView * _resultsView;
    UIButton * _showHideResultsButton;
    UIButton * _loadPuppyLogoutButton;
    UIButton * _clearSelectionButton;
    UIButton * _registorButton;
    UIButton * _backButton;
    UIImage * foregroundBits;
    EditorViewController *forinside;
    UIButton * touch;
    UIButton * eraser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    forinside = [EditorViewController new];
    [AdobeUXAuthManager.sharedManager setAuthenticationParametersWithClientID: CC_CLIENT_ID
                                                                 clientSecret: CC_CLIENT_SECRET
                                                                 enableSignUp: YES];
    
    if ([forinside.flag isEqual: @"fromMyCloset"]){
    forinside.text = forinside.TOMYCLOSET;
    forinside.imageName = @"back.png";
    forinside.setButton;
    _backButton = forinside.iconButtons[0];
    [_backButton setFrame: CGRectMake(0, 0, 100, 60)];
    _backButton.layer.position = CGPointMake((self.view.bounds.size.width/4)*1,35);
    [_backButton addTarget:self action: @selector(BackMyCloset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    _backButton.hidden = YES;
    }else{
    forinside.text = forinside.REDO;
    forinside.imageName = @"redo.png";
    forinside.setButton;
    _backButton = forinside.iconButtons[0];
    [_backButton setFrame: CGRectMake(0, 0, 100, 60)];
    _backButton.layer.position = CGPointMake((self.view.bounds.size.width/4)*1,35);
    [_backButton addTarget:self action: @selector(Back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    _backButton.hidden = YES;
    }
    
    forinside.text = forinside.SHOW_EDITED_ITEM;
    forinside.imageName = @"edit.png";
    forinside.setButton;
    _showHideResultsButton = forinside.iconButtons[1];
    [_showHideResultsButton setFrame: CGRectMake(0, 0, 100, 60)];
    _showHideResultsButton.layer.position = CGPointMake((self.view.bounds.size.width/4)*3,35);
    [_showHideResultsButton addTarget:self action: @selector(showHideResults) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showHideResultsButton];
    _showHideResultsButton.hidden = YES;
    
    forinside.text = forinside.EDITCLEAR;
    forinside.imageName = @"clear.png";
    forinside.setButton;
    _clearSelectionButton = forinside.iconButtons[2];
    [_clearSelectionButton setFrame: CGRectMake(0, 0, 100, 60)];
    _clearSelectionButton.layer.position = CGPointMake((self.view.bounds.size.width/6)*5,100);
    [_clearSelectionButton addTarget:self action: @selector(clearSelection) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_clearSelectionButton];
    _clearSelectionButton.hidden = YES;
    
    forinside.text = forinside.ITEMTOUCH;
    forinside.imageName = @"touch.png";
    forinside.setButton;
    touch = forinside.iconButtons[3];
    [touch setFrame: CGRectMake(0, 0, 100, 60)];
    touch.layer.position = CGPointMake((self.view.bounds.size.width/6)*1,100);
    [touch addTarget:self action: @selector(Touch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touch];
    touch.hidden = YES;
    
    forinside.text = forinside.ERASER;
    forinside.imageName = @"eraser.png";
    forinside.setButton;
    eraser = forinside.iconButtons[4];
    [eraser setFrame: CGRectMake(0, 0, 100, 60)];
    eraser.layer.position = CGPointMake((self.view.bounds.size.width/6)*3,100);
    [eraser addTarget:self action: @selector(Eraser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eraser];
    eraser.hidden = YES;

    // initialize the views to nil
    _magicSelectionView = nil;
    _resultsView = nil;
    
    // all buttons are hidden by default, show the load puppy button
    [self loadPuppyLogout];
}

-(void)Touch{
    _magicSelectionView.brushMode = AdobeLabsMagicSelectionBrushModeForeground;
}

-(void)Eraser{
    _magicSelectionView.brushMode = AdobeLabsMagicSelectionBrushModeBackground;
}

-(void)BackMyCloset{
    forinside.BackMyCloset;
}

-(void)Back{
    forinside.Back;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)clearSelection {
    [_magicSelectionView clearStrokes];
}

- (void)loadPuppyLogout {
    if (! _magicSelectionView)
    {
        // the magic selection view is not showing.  Create it and load puppy.
        __unsafe_unretained typeof(self) weakSelf = self;
        _magicSelectionView = [[AdobeLabsUXMagicSelectionView alloc] initWithFrame: CGRectMake(0, VIEW_Y_OFFSET, self.view.bounds.size.width, self.view.bounds.size.height-VIEW_Y_OFFSET)];
        
        forinside.analyzingView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        forinside.tempLabel.text = forinside.PREPARE_EDIT;
        forinside.analyzing;
        [self.view addSubview:forinside.analyzingView];
        [_magicSelectionView setBrushSize:50];
        [_magicSelectionView setImage: forinside.forObjectiveCimage
                  withCompletionBlock:^(NSError *error)
         {
             [forinside.analyzingView removeFromSuperview];
             
             if (error)
             {
                 // setImage failed - user failed to log in
                 weakSelf->_magicSelectionView = nil;
             }
             else
             {
                 // success with setImage, add _magicSelectionView as subview and change button states
                 [weakSelf.view addSubview: weakSelf->_magicSelectionView];
                 weakSelf->_showHideResultsButton.hidden   = NO;
                 weakSelf->_clearSelectionButton.hidden    = NO;
                 weakSelf->_backButton.hidden = NO;
                 weakSelf->touch.hidden = NO;
                 weakSelf->eraser.hidden = NO;
                 [weakSelf->_loadPuppyLogoutButton setTitle:BUTTON_TITLE_LOGOUT forState:UIControlStateNormal];
                 forinside.GuideView = self.view;
                 forinside.Guide;
             }
         }
         ];
    }
    else
    {
        // the magic selection view is showing.  Get rid of it and log the user out
        [_magicSelectionView removeFromSuperview];
        _magicSelectionView = nil;
        [AdobeUXAuthManager.sharedManager logout: nil onError: nil];
        
        // hide all of the other buttons and change my label back to load puppy
        _showHideResultsButton.hidden   = YES;
        _clearSelectionButton.hidden    = YES;
        _backButton.hidden = YES;
        touch.hidden = YES;
        eraser.hidden = YES;
        [_loadPuppyLogoutButton setTitle:BUTTON_TITLE_LOAD_PUPPY forState:UIControlStateNormal];
    }
}

- (void)showHideResults {
    if (_resultsView) {
        // results are showing, hide results and show buttons
        _magicSelectionView.brushMode = AdobeLabsMagicSelectionBrushModeForeground;
        _clearSelectionButton.hidden    = NO;
        _loadPuppyLogoutButton.hidden   = NO;
        touch.hidden = NO;
        eraser.hidden = NO;
        [_registorButton removeFromSuperview];
        [_showHideResultsButton setTitle:forinside.SHOW_EDITED_ITEM forState:UIControlStateNormal];
        [_resultsView removeFromSuperview];
        _resultsView = nil;
    }
    else {
        // show the results
        // first create a UIImage of just the foreground bits per the documentation in AdobeLabsUXMagicSelectionView.h
        _magicSelectionView.brushMode = nil;
        
        size_t w = _magicSelectionView.image.size.width;
        size_t h = _magicSelectionView.image.size.height;
        uint8_t *data = (uint8_t *)malloc(4*w*h*sizeof(uint8_t));
        [_magicSelectionView readForegroundAndMatteIntoBuffer:data];
        
        // Paint the non-selected portion of the image black
        for (int i = 0; i < 4*w*h; i += 4)
        {
            float alpha = (float)data[i + 3] / 255;
            if(alpha < 0.5){
            data[i    ] = 255;
            data[i + 1] = 255;
            data[i + 2] = 255;
            }else{
            data[i    ] *= alpha;
            data[i + 1] *= alpha;
            data[i + 2] *= alpha;
            }
        }
    
        CGContextRef ctx = CGBitmapContextCreate(data, w, h, 8, 4*w, CGColorSpaceCreateDeviceRGB(), (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
        CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
        foregroundBits = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        // show the results
        _resultsView = [[UIImageView alloc] initWithFrame: CGRectMake(0, VIEW_Y_OFFSET, self.view.bounds.size.width, self.view.bounds.size.height-VIEW_Y_OFFSET)];
        
        //要修正点
        _resultsView.contentMode = UIViewContentModeScaleAspectFit;
        [_resultsView setImage: foregroundBits];
        [self.view addSubview: _resultsView];
        
        [_showHideResultsButton setTitle:forinside.BUTTON_TITLE_HIDE_RESULTS forState:UIControlStateNormal];
        
        // hide the buttons
        _clearSelectionButton.hidden    = YES;
        _loadPuppyLogoutButton.hidden   = YES;
        touch.hidden = YES;
        eraser.hidden = YES;

        if ([forinside.flag isEqual: @"fromMyCloset"]){
        forinside.text = forinside.UPDATE;
        forinside.imageName = @"register.png";
        forinside.setButton;
        _registorButton = forinside.iconButtons[5];
        [_registorButton setFrame: CGRectMake(0, 0, 100, 60)];
        _registorButton.layer.position = CGPointMake((self.view.bounds.size.width/6)*3,35);
        [_registorButton addTarget:self action: @selector(UpdateC) forControlEvents:UIControlEventTouchUpInside];
            }else{
        forinside.text = forinside.REGISTRATION_ITEM;
        forinside.imageName = @"register.png";
        forinside.setButton;
        _registorButton = forinside.iconButtons[5];
        [_registorButton setFrame: CGRectMake(0, 0, 100, 60)];
        _registorButton.layer.position = CGPointMake((self.view.bounds.size.width/6)*3,35);
        [_registorButton addTarget:self action: @selector(RegistrationC) forControlEvents:UIControlEventTouchUpInside];
            }
        [self.view addSubview:_registorButton];
        _registorButton.hidden = NO;
    }
}

- (void)UpdateC{
    ForObjectiveC *forObjectiveC = [ForObjectiveC new];
    forObjectiveC.ObjectiveCSave = foregroundBits;
    forObjectiveC.UpdateC;
    forObjectiveC.alertTitle = forObjectiveC.UPDATE_SUCCESS;
    forObjectiveC.alert;
    [self presentViewController:forObjectiveC.alertController animated:true completion:nil];
}

- (void)RegistrationC{
    ForObjectiveC *forObjectiveC = [ForObjectiveC new];
    forObjectiveC.ObjectiveCSave = foregroundBits;
    forObjectiveC.RegistrationC;
    forObjectiveC.alertTitle = forObjectiveC.REGISTRATION_SUCCESS;
    forObjectiveC.alert;
    [self presentViewController:forObjectiveC.alertController animated:true completion:nil];
}

@end
