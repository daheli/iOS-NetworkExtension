//
//  AddEditConfiguration.m
//  ExperimentVPN
//
//  Created by lidahe on 15/10/9.
//  Copyright © 2015年 lidahe. All rights reserved.
//

#import "AddEditConfiguration.h"
#import <NetworkExtension/NetworkExtension.h>
#import <UIKit/UIKit.h>
#import "GMKeyChain.h"


@interface AddEditConfiguration()

@property (nonatomic) NEVPNManager *manager;

@end


@implementation AddEditConfiguration

+ (AddEditConfiguration *) sharedInstance
{
    __strong static AddEditConfiguration * global = nil;
    
    if (global != nil) {
        return global;
    }
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        global = [[AddEditConfiguration alloc] init];
    });
    
    return global;
}

//Load vpn profile
-(void)loadProfile {
    NEVPNManager *manager = [NEVPNManager sharedManager];
    manager.enabled = true;
    [manager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Load VPN preferences fail : %@", error);
        } else {
            //Check if vpn profile installed or not
            NEVPNStatus status = [[manager connection] status];
            NSLog(@"loadFromPreferencesWithCompletionHandler");
            if (status == NEVPNStatusInvalid) {
                NSLog(@"VPN Not Configured!");
//                GMAlertCenter *center = [GMAlertCenter sharedAlertCenter];
//                [center alert:center
//       showVpnCertificateNote:@"首次开启需要安装安全证书，安装证书过程中可能需要输入您的锁屏密码。"
//                       target:self];
            } else {
                NSLog(@"Configuration loaded!");
                //            [self updateVPNConfigureWithIp:[self VPNServer] stop:NO];
//                [[NSNotificationCenter defaultCenter] postNotificationName:GMVPNConfigurationDidLoad
//                                                                    object:self
//                                                                  userInfo:@{
//                                                                             GMVPNConfigurationStatusName:@YES
//                                                                             }];
            }
        }
    }];
}

-(void) remove {
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"will remove : %@", error);
        }
        [[NEVPNManager sharedManager] removeFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Remove VPN preferences fail, %@", error);
            } else {
                NSLog(@"Remove VPN preferences success.");
            }
        }];
    }];
}

/// Save the configuration to the Network Extension preferences.
-(void) save {
    
    self.manager = [[NETunnelProviderManager alloc] init];
//    self.manager = [NEVPNManager sharedManager];
    //Setup IKEv2 protocol
    NEVPNProtocolIKEv2 *ikev2 = [[NEVPNProtocolIKEv2 alloc] init];
    
    ikev2.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
    
    ikev2.username = GMVPNIKEv2UserName;
    ikev2.passwordReference = [GMKeyChain getVpnCredentialFromKeychainWithKey:GMVPNIKEv2PasswordName];
    if (ikev2.passwordReference == nil) {
        [GMKeyChain putVpnCredentialToKeychainWithKey:GMVPNIKEv2PasswordName password:GMVPNIKEv2Password];
        ikev2.passwordReference = [GMKeyChain getVpnCredentialFromKeychainWithKey:GMVPNIKEv2PasswordName];
    }
    
    ikev2.sharedSecretReference = [GMKeyChain getVpnCredentialFromKeychainWithKey:GMVPNIKEv2ShareKeyName];
    if (ikev2.sharedSecretReference == nil) {
        [GMKeyChain putVpnCredentialToKeychainWithKey:GMVPNIKEv2ShareKeyName password:GMVPNIKEv2ShareKey];
        ikev2.sharedSecretReference = [GMKeyChain getVpnCredentialFromKeychainWithKey:GMVPNIKEv2ShareKeyName];
    }
    
    ikev2.serverAddress = VPNServerIP;
    
    ikev2.localIdentifier = [self localIndentifier];
    ikev2.remoteIdentifier = @"game.wsdashi.com";
    
    ikev2.useExtendedAuthentication = YES;
    ikev2.disconnectOnSleep = NO;
    ikev2.deadPeerDetectionRate = NEVPNIKEv2DeadPeerDetectionRateHigh;
    
    NETunnelProviderProtocol *protocol = [[NETunnelProviderProtocol alloc] init];
//    protocol.providerConfiguration = @{ @"some parameter" : @"some value" };
    protocol.providerBundleIdentifier = @"com.example.vpn.vpntunnel";
    protocol.serverAddress = VPNServerIP;

    
    [self.manager setProtocolConfiguration:protocol];
    [self.manager setProtocol:protocol];
    
    [self.manager setEnabled:YES];
    
    [self.manager setLocalizedDescription:@"极速手游加速器安全证书tunnel"];
    
    //Save vpn configuration
    [self.manager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"will save : %@", error);
        }
        self.manager.enabled = true;
        [self.manager saveToPreferencesWithCompletionHandler:^(NSError *error){
            if (error) {
                NSLog(@"Save VPN preferences fail, %@", error);
            } else {
                NSLog(@"Save VPN preferences success");
            }
            //Notify that vpn profile save finished
    //        [[NSNotificationCenter defaultCenter] postNotificationName:GMVPNConfigurationDidSave
    //                                                            object:self
    //                                                          userInfo:@{
    //                                                                     GMVPNConfigurationStatusName:error == nil ? @YES : @NO
    //                                                                     }];
        }];
    }];
    
    
    
}

-(void)start {
    NSLog(@"Do start");
    //    [self setAction:VPNActionNone];
    NSError *error = nil;
    BOOL ok = [[self.manager connection] startVPNTunnelAndReturnError:&error];
    if (!ok || error != nil) {
        NSLog(@"Start vpn error: %@", error);
    } else {
        NSLog(@"Start VPN success!");
    }
}

-(void)stop {
    NSLog(@"Stop VPN.");
    [[[NEVPNManager sharedManager] connection] stopVPNTunnel];
}

-(void)check {
    NSLog(@"Check VPN.");
    NEVPNStatus status = [[[NEVPNManager sharedManager] connection] status];
    NSLog(@"NEVPNStatus : %@", @(status));
}

- (NSString *)localIndentifier {
    //Use vendor identifier as VPN local indentifier
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
    
@end
