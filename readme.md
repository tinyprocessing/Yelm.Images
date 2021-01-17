## Image Picker 😻 SwiftUI  ![](https://img.shields.io/badge/version-1.0-brightgreen)

1. About
2. Examples
   1. Modal Views
   2. Picker ![](https://img.shields.io/github/issues/Michaelsafir/ImagesPicker)
3. Documentation

## Some screenshots

![](image.png) ![](image2.png)



### About 

This project will help you figure out how to make a custom picture selection from the gallery. You can select one or more pictures and use the camera to take new pictures. This example will save you a lot of time in debugging and in fixing memory errors. 



### Examples

1. Connect **ModalAnchorView** to init view - in this case it will cover all other content

```swift
	ZStack{
      Home()
      ModalAnchorView()
	}
```

2. **Home.swift** onAppear{} load modal view befour you call it - this way it will show in moment after you press button **+**

```swift
.onAppear {
  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
    self.modal.newModal(position: .closed) {
      ModalImages()
        .clipped()
    }
  }
}
```

3. Call view images on **Button Click**

```swift
DispatchQueue.main.asyncAfter(deadline: .now()) {
  [self] in
  self.modal.openModal()
}
```

