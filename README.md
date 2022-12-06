
# ScrollListenerSwift

The purpose of the library is to listen to the scroll and the end of the scroll.

# Getting Started

Clone the repository

```bash
git clone https://github.com/PierreGourgouillon/ScrollListenerSwiftUI.git
```

# ScrollListener Component

 - onScroll: perform an action when the user scrolling the ScrollView
 - onScrollFinish: perform an action when the user stop to scrolling the ScrollView

```swift
ScrollListener(.horizontal, showsIndicators: false, delayToPerformWhenScrollFinish: 1) {

}
.onScroll { value in }
.onScrollFinish { value in }
```
