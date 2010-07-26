//
//  BlogSettingsViewController.m
//  WordPress
//
//  Created by Chris Boyd on 7/25/10.
//  Copyright 2010 WordPress. All rights reserved.
//

#import "BlogSettingsViewController.h"

@implementation BlogSettingsViewController
@synthesize tableView, recentItems, actionSheet, isSaving, buttonText;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	appDelegate = (WordPressAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	recentItems = [[NSArray alloc] initWithObjects:
				   @"10 Recent Items", 
				   @"25 Recent Items", 
				   @"50 Recent Items", 
				   @"100 Recent Items", 
				   nil];
	buttonText = @"Save";

	self.navigationItem.title = @"Settings";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSLog(@"Editing settings for currentBlog: %@", [appDelegate.currentBlog objectForKey:@"url"]);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	int result = 0;
	
	switch (section) {
		case 0:
			result = 3;
			break;
		case 1:
			result = 3;
			break;
		case 2:
			result = 1;
			break;
		default:
			break;
	}
	
	return result;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: Double-check for performance drain later
    static NSString *normalCellIdentifier = @"Cell";
    static NSString *switchCellIdentifier = @"SwitchCell";
    static NSString *activityCellIdentifier = @"ActivityCell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:normalCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCellIdentifier] autorelease];
    }
	
	UITableViewActivityCell *activityCell = (UITableViewActivityCell *)[self.tableView dequeueReusableCellWithIdentifier:activityCellIdentifier];
	UITableViewSwitchCell *switchCell = (UITableViewSwitchCell *)[self.tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
	if(switchCell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UITableViewSwitchCell" owner:nil options:nil];
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[UITableViewSwitchCell class]])
			{
				switchCell = (UITableViewSwitchCell *)currentObject;
				break;
			}
		}
	}
	
	if(activityCell == nil) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UITableViewActivityCell" owner:nil options:nil];
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[UITableViewActivityCell class]])
			{
				activityCell = (UITableViewActivityCell *)currentObject;
				break;
			}
		}
	}
    
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					switchCell.textLabel.text = @"Resize Photos";
					switchCell.cellSwitch.on = [[appDelegate.currentBlog objectForKey:kResizePhotoSetting] boolValue];
					cell = switchCell;
					cell.tag = 0;
					break;
				case 1:
					switchCell.textLabel.text = @"Geotagging";
					NSString *oldGeotaggingSettingName = [NSString stringWithFormat:@"%@-Geotagging", [appDelegate.currentBlog valueForKey:kBlogId]];
					if([appDelegate.currentBlog objectForKey:kGeolocationSetting] != nil)
						switchCell.cellSwitch.on = [[appDelegate.currentBlog objectForKey:kGeolocationSetting] boolValue];
					else if(![[NSUserDefaults standardUserDefaults] boolForKey:oldGeotaggingSettingName])
						switchCell.cellSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:oldGeotaggingSettingName];
					cell = switchCell;
					cell.tag = 1;
					break;
				case 2:
					cell.textLabel.text = @"Recent Items";
					if([appDelegate.currentBlog valueForKey:kPostsDownloadCount] != nil)
						cell.detailTextLabel.text = [appDelegate.currentBlog valueForKey:kPostsDownloadCount];
					else {
						cell.detailTextLabel.text = [recentItems objectAtIndex:0];
					}
					cell.tag = 2;
					break;
				default:
					break;
			}
			break;
		case 1:
			switch (indexPath.row) {
				case 0:
					switchCell.textLabel.text = @"Authentication";
					switchCell.cellSwitch.on = [[appDelegate.currentBlog objectForKey:@"authEnabled"] boolValue];
					cell = switchCell;
					cell.tag = 3;
					break;

				case 1:
					cell.textLabel.text = @"Username";
					cell.tag = 4;
					break;
				case 2:
					cell.textLabel.text = @"Password";
					cell.tag = 5;
					break;
				default:
					break;
			}
			break;
		case 2:
			if(isSaving)
				[activityCell.spinner startAnimating];
			else
				[activityCell.spinner stopAnimating];
			
			activityCell.textLabel.text = buttonText;
			cell = activityCell;
			cell.tag = 5;
			break;

		default:
			break;
	}
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *result = @"";
	
	switch (section) {
		case 1:
			result = @"HTTP";
			break;
		default:
			break;
	}
	
	return result;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 2:
					[self showPicker:self];
					break;
				default:
					break;
			}
			break;
		case 2:
			// Save Settings
			buttonText = @"Saving...";
			isSaving = YES;
			[self processRowValues];
			[self.tableView reloadData];
			[self.navigationController popViewControllerAnimated:YES];
			break;
		default:
			break;
	}
	[tv deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UIPickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [recentItems count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [recentItems objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[appDelegate.currentBlog setValue:[recentItems objectAtIndex:row] forKey:kPostsDownloadCount];
}

#pragma mark -
#pragma mark Custom methods

- (IBAction)showPicker:(id)sender {
	[self processRowValues];
	actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	
	CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	pickerView.showsSelectionIndicator = YES;
	pickerView.delegate = self;
	pickerView.dataSource = self;
	[pickerView selectRow:[self selectedRecentItemsIndex] inComponent:0 animated:YES];
	[actionSheet addSubview:pickerView];
	
	UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
	closeButton.momentary = YES; 
	closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
	closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
	closeButton.tintColor = [UIColor blackColor];
	[closeButton addTarget:self action:@selector(hidePicker:) forControlEvents:UIControlEventValueChanged];
	[actionSheet addSubview:closeButton];
	[closeButton release];
	
	[actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
	
	[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (IBAction)hidePicker:(id)sender {
	[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	[self.tableView reloadData];
}

- (int)selectedRecentItemsIndex {
	int result = 0;
	int index = 0;
	for(NSString *item in recentItems) {
		if([item isEqualToString:[appDelegate.currentBlog valueForKey:kPostsDownloadCount]]) {
			result = index;
			break;
		}
		index++;
	}
   return result;
}

- (void)processRowValues {
	NSInteger numSections = [self numberOfSectionsInTableView:self.tableView];
	for (NSInteger s = 0; s < numSections; s++) { 
		NSInteger numRowsInSection = [self tableView:self.tableView numberOfRowsInSection:s]; 
		for(NSInteger r = 0; r < numRowsInSection; r++) {
			UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:s]]; 
			for(UIView *subview in cell.contentView.subviews) {
				if([subview isKindOfClass:[UISwitch class]]) {
					UISwitch *cellSwitch = (UISwitch *)subview;
					switch (s) {
						case 0:
							switch (r) {
								case 0:
									[appDelegate.currentBlog setObject:[self transformedValue:cellSwitch.on] forKey:kResizePhotoSetting];
									break;
								case 1:
									[appDelegate.currentBlog setObject:[self transformedValue:cellSwitch.on] forKey:kGeolocationSetting];
									break;
								default:
									break;
							}
							break;
						case 1:
							switch (r) {
								case 0:
									[appDelegate.currentBlog setValue:[self transformedValue:cellSwitch.on] forKey:@"authEnabled"];
									break;
								default:
									break;
							}
							break;
						default:
							break;
					}
				}
				if([subview isKindOfClass:[UITextField class]]) {
					UITextField *cellText = (UITextField *)subview;
					switch (s) {
						case 1:
							switch (r) {
								case 1:
									[appDelegate.currentBlog setObject:cellText.text forKey:@"authUsername"];
									break;
								case 2:
									[appDelegate.currentBlog setObject:cellText.text forKey:@"authPassword"];
									break;
								default:
									break;
							}
							break;
						default:
							break;
					}
				}
			}
		} 
	}
}

- (NSString *)transformedValue:(BOOL)value {
    if(value)
		return @"YES";
	else
		return @"NO";
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
	[buttonText release];
	[actionSheet release];
	[tableView release];
	[recentItems release];
    [super dealloc];
}


@end

