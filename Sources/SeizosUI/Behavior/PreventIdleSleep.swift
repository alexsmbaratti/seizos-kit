//
//  PreventIdleSleep.swift
//  SeizosKit
//
//  Created by Alex Baratti on 1/8/26.
//

import SwiftUI

/// Disables the system idle timer while this view is visible, preventing the screen from dimming or locking.
///
/// Use this modifier for views that require continuous user visibility.
///
/// The idle timer is disabled when the view appears and automatically re-enabled
/// when the view disappears.
///
/// - Parameter disabled: A Boolean value that indicates whether the idle timer
///   should be disabled. Defaults to `true`.
///
/// - Important: This modifier affects a global application-level setting.
///   If multiple views manage the idle timer, ensure their behavior does not
///   conflict.
public extension View {
    func idleTimerDisabled(_ disabled: Bool = true) -> some View {
        onAppear {
            UIApplication.shared.isIdleTimerDisabled = disabled
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}
