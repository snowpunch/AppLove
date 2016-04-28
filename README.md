![alt tag](https://github.com/snowpunch/AppLove/blob/master/apploveicon.png?raw=true) 
# App Love

[Download from the App store](https://itunes.apple.com/us/app/app-love/id1099336831?mt=8)

### Features
- **Utility App** that shows **ALL iOS Customer Reviews** for any app, across **ALL territories**.
- You can config which territories to download from.
- Language **translations** possible.

### What is this really?

- A utility app that **I always wanted**.
- I have a few years of Objective-C and wanted to **take Swift out for a spin.**

### What parts of Swift did I get to explore?
- **Multi-threaded review downloader** with **NSOperations** using dependancies.
- **Territory based** multi-part **progress bar** that visually animates where the **4 active threads** are via CALayers.
- **SpriteKit Animations** for text within **Help** and **About** pages.
- **JSON** and **XML.**
- **Data Models** cached with **NSCache.**
- Both Storyboards and also Xibs were used (for a wider swath of **swift exploration**).
- **Closures** and UI Themes.
- **Normal stuff:** delegates, notifications, singletons, tableviews, action sheets, etc.

## What do I now think of Swift?
- Swift rocks!!

## The App's main Challenge
- **Huge data:**  155 territories, with each up to 10 pages of JSON and/or XML data. 
- So a **long download** if you select lots of territories and/or the app is popular.
- Needs an **interesting and informative progress bar** to deal with apps that have either too much data or not much at all.
- Servers tend to block if too much activity, so first download in JSON and if block - then show red flash on download bar then continue with XML.

## The App Solution
- **Show each territory** as it's own little loader bar. **Color coded** to reflect errors, and quantity of downloads.
- **Blue** means 1-49 reviews **(1 page)** - helps show up better for apps with less reviews.
- **Black** means 50-500 reviews **(2 - 10 pages)** - scales up for the more successful apps.
- You need to download reviews for a really popular app (ie:Twitter) to get a full sense of the capabilities.
 
## Cocoapods used
- AlmoFire
- SwiftyJSON
- SDWebImage
- **SwiftyGlyphs** [Awesome CocoaPod!](https://github.com/snowpunch/SwiftyGlyphs)

## Installation

- Open terminal and navigate to directory with 'podfile'.
- Run **'pod install'**
- Then **open app via xcworkspace** (not xcodeproj) - as per normal cocoaPod using apps.

## Author & licence

- Woodie Dovich,  woodiewebsafe@gmail.com
- App Love is available under the MIT license. See the LICENSE file for more info.
