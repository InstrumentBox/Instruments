# Extensions

A list of extensions *Instruments* library introduces.


## Array batching

```swift
let batched = [1, 2, 3, 4, 5, 6, 7, 8].batch(by: 3)
// Returns [[1, 2, 3], [4, 5, 6], [7, 8]]
```

## DateFormatter

```swift
let f: DateFormatter = .iso8601
// Creates formatter with "yyyy-MM-dd'T'HH:mm:ssZZ" format and uses Gregorian 
// calendar with en_US_POSIX locale
```

## String

```swift
let base64 = "hello world".base64Encoded()
// Returns "aGVsbG8gd29ybGQ="
```

```swift
let string = "aGVsbG8gd29ybGQ=".base64Decoded()
// Returns "hello world" 
```

```swift
let string = "a1b2c3".removingCharacters(in: .decimalDigits)
// Returns "abc"
```

```swift
var string = "a1b2c3"
string.removeCharacters(in: .decimalDigits)
// string is "abc"
```

```swift
let string = "foo_bar_baz".removingPrefix("foo_")
// Returns "bar_baz"
```

```swift
var string = "foo_bar_baz"
string.removePrefix("foo_")
// string is "bar_baz"
```

## Task

```swift
Task.retrying(retriesCount: 42) {
   try await someOperationThatCanFail()
}
```

## Data

```swift
let hex = Data([0xAB, 0xCD]).hexString()
// Returns "abcd"
```

## JSONDecoder.DataDecodingStrategy

```swift
let decoder = JSONDecoder()
decoder.dataDecodingStrategy = .hexString
```
