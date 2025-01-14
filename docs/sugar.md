# 语法糖

## Before

```dart
build() {
  return Padding(
      padding: EdgeInsets.all(8),
      child: Text("Hello World", style: TextStyle(fontSize: 18),)
  );
}
```

## After

```dart
build(){
  return Text("Hello World").color(Colors.red).padding(8);
}
```