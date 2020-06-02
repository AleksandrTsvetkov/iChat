//
//  WaitingChatsNavigation.swift
//  iChat
//
//  Created by Александр Цветков on 01.06.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

protocol WaitingChatsNavigation: class {
    func removeWaitingChat(_ chat: ChatModel)
    func changeToActive(_ chat: ChatModel)
}
