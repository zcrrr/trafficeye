//
//  MCAudioServiceDummy.h
//  Connected
//
//  Created by Andreas Streuber on 09.12.11.
//  Copyright (c) 2011 BMW Group. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class MCAudioServiceDummy
 @abstract Helper class that provides IDAudioServiceDelegate callbacks in the HMI simulation.
 @discussion This class is used to be able to test some audio functionality in the HMI simulator. It will emulate the HMI simulation and provide callbacks to the IDAudioServiceDelegate. At the time of this writing the HMI simulation does not call IDAudioSystemDelegate methods. The MCAudioManager will automatically use an instance of this class when run in den iOS simulator. TODO: Instead of using this class the IDAudioManagerDelegate callbacks should be implemented in the HMI simulation. As soon as the HMI simulation provides this functionality this class schould be deleted. Don't forget to remove references to this class from MCAudioManager.
 */
@interface MCAudioServiceDummy : IDAudioService

@end
