# TipCalculator

This is a Tip Calculator application for iOS submitted as the [pre-assignment](https://gist.github.com/timothy1ee/7747214) requirement for CodePath.

Time spent: 25 hours

Completed:

* [x] Required: User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Required: Settings page to change the default tip percentage.
* [x] Optional: UI animations
* [x] Optional: Remembering the bill amount across app restarts (if <10mins)
* [x] Optional: Using locale-specific currency and currency thousands separators.
* [x] Optional: Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

Additional features:

* Text field replacement: Blank text fields will display a cursor, but any subsequent input will be interpolated into a center-justified, locale-specific currency format.
* Tip slider: The tip amount is determined via a UISlider (discrete to a tenth point), rather than the less granular and clumsy UISegmentedControl.
* Colored indicators: The slider button, text cues, tip percentage, and total amount discretely change color across the spectrum between red, yellow, and green (and for text cues, between the respective color and light gray). Color is arithmetically determined based on location of slider in relation to text cues.
* Full-screen popover: The bill text field is pushed on the main view by clicking the bill amount, and can be popped off by touch *or* swipe.
* Color modes: A light theme can be toggled in settings and is persistent to NSU1/serDefaults.
* Default tip picker: The default tip percentage can be selected via an in-view UIPicker view.

Notes:

* This code is rudimentary, but has undergone significant refactoring, cleanup, and abstraction.
* The blur popover effect can be achieved in earlier versions of iOS, but for the purposes of this exercise, this app utilizes UIBlurEffect and therefore targets iOS 8+.
* All UI elements are added and manipulated programmatically; IB elements had issues with initialization from within the app delegate.
* Most of the frame drawing is intended to account for varying screen sizes and modern iOS versions. View elements are clipped to all four bounds, rather than offset from the top-left. Subsequently, this app does **not** require auto-layout in order to display across dimensions/versions.
* There are no image assets in this app; everything (including the slider button) is drawn programmatically in context using CoreGraphics.

*Core functionality*

![Default implementation](https://github.com/zeantsoi/RYG/blob/master/ryg_1.gif)

*Theme and default configuration*

![Theme and default configuration](https://github.com/zeantsoi/RYG/blob/master/ryg_2.gif)

*Locale specific configuration*

![Locale specific configuration](https://github.com/zeantsoi/RYG/blob/master/ryg_3.gif)

Last updated: 1/20/2016

##License##

Copyright (c) 2016 Zean Tsoi

No permission is granted to **republish** this software and associated files – whether in part, whole, or modified form – without the express, written consent of the author.

Otherwise, so long as the author is held non-liable in any event or outcome of its usage: Do whatever you like with it.
