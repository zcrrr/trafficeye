//
//  Connected
//
//  Created by Wolfram Manthey on 10.08.11.
//  Copyright 2011 BMW Group. All rights reserved.
//

#import "MCDefaultFeatureController.h"
#import "MCAudioServiceDummy.h"


@interface IDCountingCondition : NSObject
- (id)initWithCount:(NSUInteger)count;
- (void)increment;
- (void)decrement;
- (void)waitForZero;
@end

@interface MCDefaultFeatureController () <IDApplicationDelegate, IDApplicationDataSource>

@property (retain, readwrite) MCAudioServiceDummy *audioServiceDummy;

- (NSArray *)databasesUsingMatch:(NSString *)match;

@end

#pragma mark -

@implementation MCDefaultFeatureController

@synthesize application = _application;
@synthesize featureConfiguration = _featureConfiguration;
@synthesize audioServiceDummy = _audioServiceDummy;

- (id)initWithApplication:(IDApplication*)application featureConfiguration:(MCFeatureConfiguration *)configuration;
{
    if (self = [super init])
    {
        _application = [application retain];
		_featureConfiguration = [configuration retain];
    }
    return self;
}

- (void)dealloc
{
	[_application release];
    [_featureConfiguration release];
    [_audioServiceDummy release];

    [super dealloc];
}

- (BOOL)isEqual:(id)anObject
{
    return ([[anObject class] isEqual:[self class]] && [[self featureConfiguration] isEqual:[anObject featureConfiguration]]);
}

-(NSUInteger)hash
{
    return [self.featureIdentifier hash];
}

#pragma mark - MCFeatureController protocol methods

- (MCFeatureIdentifier *)featureIdentifier
{
    return self.featureConfiguration.identifier;
}

- (IDVersionInfo *)featureVersion
{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ MUST be overridden in feature controller subclass %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])] userInfo:nil];
}

- (BOOL)featureRequiresNBT
{
    return self.featureConfiguration.requiresNBT;
}

- (BOOL)featureUsesRemoteHMI
{
	return ([self hmiDescriptionForApplication:self.application] != nil);
}

- (BOOL)featureRequiresConnectionToVehicle
{
    return [self featureUsesRemoteHMI];
}

- (IDHmiService *)hmiService
{
	return self.application.hmiService;
}

- (IDCdsService *)cdsService
{
	return self.application.cdsService;
}

- (IDAudioService *)audioService
{
    if(TARGET_IPHONE_SIMULATOR)
    {
        if (!self.audioServiceDummy) {
            self.audioServiceDummy = [[[MCAudioServiceDummy alloc] init] autorelease];
        }
        return self.audioServiceDummy;
    }

	return self.application.audioService;
}

- (BOOL)featureDoesHandleURL:(NSURL*)url
{
    //everybody who overwrites this needs to call [super featureDoesHandleURL] at the end of the overwritten method.
    MCLog(IDLogLevelWarn, @"featuredoeshandleurl entered");
    NSDictionary *plistDictionary = [self manifestForApplication:self.application];
    NSURL *manifestUrl = [NSURL URLWithString:[[[plistDictionary objectForKey:@"IDApplicationManifest"] objectForKey:@"IDAppModel"] objectForKey:@"url"]];
    if (plistDictionary != nil) {
        if ([url.scheme isEqualToString:manifestUrl.scheme]) {
            MCLog(IDLogLevelDebug, @"%s - The feature %@ DOES handle the switcher URL %@ (URL from manifest: %@)", __PRETTY_FUNCTION__, [[self featureIdentifier] name], url.scheme, manifestUrl);
            return YES;
        } else {
            MCLog(IDLogLevelDebug, @"%s - The feature %@ does NOT handle the switcher URL %@ (URL from manifest: %@)", __PRETTY_FUNCTION__, [[self featureIdentifier] name], url.scheme, manifestUrl);
        }
    } else {
        MCLog(IDLogLevelError, @"%s - plistData was nil for feature name: %@", __PRETTY_FUNCTION__, [[self featureIdentifier] name]);
    }

	return NO;
}

- (BOOL)isConnected {
    return [[self application] isConnected];
}

- (void)registerWithAppSwitcher {
    //register for App Switching if the feature can use it; existing registrations for this feature will be replaced
    NSDictionary *manifestDict = [self manifestForApplication:self.application];
    if (manifestDict && [[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0) {
//        [IDApplication registerApplicationManifestForAppSwitching:manifestDict];
    } else {
        MCLog(IDLogLevelError, @"%s: No manifest available for registering with AppSwitcher!", __PRETTY_FUNCTION__);
    }
    
}

- (void)deregisterFromAppSwitcher {
    NSDictionary *manifestDict = [self manifestForApplication:self.application];
    if (manifestDict) {
//        [IDApplication deregisterApplicationManifestFromAppSwitching:manifestDict];
    } else {
        MCLog(IDLogLevelError, @"%s: No manifest available for deregistering from AppSwitcher!", __PRETTY_FUNCTION__);
    }
    
}


#pragma mark - IDApplicationDataSource implementation

- (NSDictionary *)manifestForApplication:(IDApplication *)application {
    NSURL* url = [[NSBundle mainBundle] URLForResource:[[self featureIdentifier] name] withExtension:@"plist"];
    return [NSDictionary dictionaryWithContentsOfURL:url];
}

- (NSData *)hmiDescriptionForApplication:(IDApplication *)application
{
    NSMutableString* hmiDescriptionName = [[[NSMutableString alloc] initWithString:[[self featureIdentifier] name]] autorelease];
    [hmiDescriptionName appendString:@"_HMI"];
    
    NSString *hmiDescriptionNameStr = [[hmiDescriptionName copy] autorelease];
    NSURL *url = [[NSBundle mainBundle] URLForResource:hmiDescriptionNameStr withExtension:@"xml"];
    return [NSData dataWithContentsOfURL:url];
}

- (NSArray *)textDatabasesForApplication:(IDApplication *)application
{
    switch (self.application.vehicleInfo.brand)
    {
        case IDVehicleBrandBMW:
            if (self.application.vehicleInfo.hmiType == IDVehicleHmiTypeID4PlusPlus) {
                //NBT
                return [NSArray arrayWithObjects:
                        [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_common_Texts" withExtension:@"zip"]],
                        [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_cic_Texts" withExtension:@"zip"]],
                        nil];
                return nil;
            } else {
                //CIC
                return [NSArray arrayWithObjects:
                        [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_common_Texts" withExtension:@"zip"]],
                        [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_cic_Texts" withExtension:@"zip"]],
                        nil];
            }
            break;
        case IDVehicleBrandMINI:
            return [NSArray arrayWithObjects:
                    [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_common_Texts" withExtension:@"zip"]],
                    [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_mini_Texts" withExtension:@"zip"]],
                    nil];
            return nil;
            break;
        default:
//            return [NSArray arrayWithObjects:
//                    [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_common_Texts" withExtension:@"zip"]],
//                    nil];
            return nil;
            break;
    }
}

- (NSArray *)imageDatabasesForApplication:(IDApplication *)application
{
    switch (self.application.vehicleInfo.brand)
    {
        case IDVehicleBrandBMW:
            if (self.application.vehicleInfo.hmiType == IDVehicleHmiTypeID4PlusPlus) {
                //NBT
                return [NSArray arrayWithObjects:
                        [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_common_Images" withExtension:@"zip"]],
                        [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_cic_Images" withExtension:@"zip"]],
                        nil];
                return nil;
            } else {
                //CIC
                return [NSArray arrayWithObjects:
                        [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_common_Images" withExtension:@"zip"]],
                        [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_cic_Images" withExtension:@"zip"]],
                        nil];
            }
            break;
        case IDVehicleBrandMINI:
            return [NSArray arrayWithObjects:
                    [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_common_Images" withExtension:@"zip"]],
                    [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"CenNavi_mini_Images" withExtension:@"zip"]],
                    nil];
            return nil;
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - IDApplicationDelegate protocol methods

- (void)application:(IDApplication *)application didConnectToVehicle:(IDVehicleInfo *)vehicleInfo
{
    if ([self respondsToSelector:@selector(featureDidConnectToVehicle:)]) {
        [self featureDidConnectToVehicle:vehicleInfo];
    }
}

- (void)applicationDidStart:(IDApplication *)application
{
    if ([self respondsToSelector:@selector(featureDidStart)]) {
        [self featureDidStart];
    }
}

- (void)application:(IDApplication *)application didFailToStartWithError:(NSError *)error
{
    if ([self respondsToSelector:@selector(featureDidFailToStartWithError:)]) {
        [self featureDidFailToStartWithError:error];
    }
}

- (void)applicationRestoreMainHmiState:(IDApplication *)application
{
    if ([self respondsToSelector:@selector(featureShouldRestoreHmiWithComponents:)]) {
        [self featureShouldRestoreHmiWithComponents:nil];
    }
}

- (void)applicationDidStop:(IDApplication *)application
{
    if ([self respondsToSelector:@selector(featureDidStop)]) {
        [self featureDidStop];
    }
}

#pragma mark - helper methods

- (NSArray *)databasesUsingMatch:(NSString *)match
{
    NSMutableArray* result = nil;
    NSArray* urls = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"zip" subdirectory:nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"lastPathComponent like %@", match];
    NSArray* filteredUrls = [urls filteredArrayUsingPredicate:predicate];
        if ([filteredUrls count]) {
            result = [NSMutableArray arrayWithCapacity:[filteredUrls count]];
            for (NSURL *currentURL in filteredUrls) {
                [result addObject:[NSData dataWithContentsOfURL:currentURL]];
            }
        }
    return result;
}



@end
