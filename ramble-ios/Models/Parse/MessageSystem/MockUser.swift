//
// MockUser.Swift
//  ramble-ios
//
//  Created by Hexio Zhang Ramble Tecnology Inc. on 2018-08-28.
//  Copyright © 2020 Ramble Technologies Inc. All rights reserved.
//

import Foundation
import MessageKit
import Parse

struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
