//
//  CDVCoreDataHandler.h
//  CoredataPlugin
//
//  Created by Alugaddala, Ashish Kumar [GCB-OT] on 8/25/17.
//
//

#import <Cordova/CDV.h>

@interface CDVCoreDataHandler : CDVPlugin
    
- (void) valuesFromWeb:(CDVInvokedUrlCommand*)command;
- (void) fetchValuesFromCoredata:(CDVInvokedUrlCommand *)command;
@end
