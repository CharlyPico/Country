//
//  DeviceHaptics.swift
//  Country
//
//  Created by Charlie Pico on 02/07/24.
//

import UIKit

//In here I set up the 'UINotificationFeedbackGenerator' and 'UIImpactFeedbackGenerator' to give feedback to the user when tapping buttons or getting alerts.
public func haptic(type:UINotificationFeedbackGenerator.FeedbackType)
{
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

public func impact(style:UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}
