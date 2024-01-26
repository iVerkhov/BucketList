* Adding conformance to Comparable for custom types
* Writing data to the documents directory
* Switching view states with enums
* Integrating MapKit with SwiftUI
* Using Touch ID and Face ID with SwiftUI
* Adding user locations to a map
* Improving our map annotations
* Selecting and editing map annotations
* Downloading data from Wikipedia
* Sorting Wikipedia results
* Introducing MVVM into your SwiftUI project
* Locking our UI behind Face ID

**CHALLENGE:**

1. _Allow the user to switch map modes, between the standard mode and hybrid._
1. _Our app silently fails when errors occur during biometric authentication, so add code to show those errors in an alert._
1. _Create another view model, this time for EditView. What you put in the view model is down to you, but I would recommend leaving dismiss and onSave in the view itself – the former uses the environment, which can only be read by the view, and the latter doesn’t really add anything when moved into the model._

**Tip:** That last challenge will require you to make a State instance in your EditView initializer – remember to use an underscore with the property name!
