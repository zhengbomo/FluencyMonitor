# FluencyMonitor

iOS 卡顿监控


```swift
// 开启监控
FluencyMonitor.shared.start()

// 关闭监控
FluencyMonitor.shared.stop()
```

出现卡顿时输出

```txt
0   libsystem_c.dylib                   0x00007fff51aed510 usleep + 53
1   Demo                                0x000000010fab7479 Demo.ViewController.tableView(_: __C.UITableView, cellForRowAt: Foundation.IndexPath) -> __C.UITableViewCell + 1193
2   Demo                                0x000000010fab7545 @objc Demo.ViewController.tableView(_: __C.UITableView, cellForRowAt: Foundation.IndexPath) -> __C.UITableViewCell + 165
3   UIKitCore                           0x00007fff48ea3f1a -[UITableView _createPreparedCellForGlobalRow:withIndexPath:willDisplay:] + 867
4   UIKitCore                           0x00007fff48e6d5a6 -[UITableView _updateVisibleCellsNow:] + 3010
5   UIKitCore                           0x00007fff48e8d2d2 -[UITableView layoutSubviews] + 194
6   UIKitCore                           0x00007fff49193678 -[UIView(CALayerDelegate) layoutSublayersOfLayer:] + 2478
7   QuartzCore                          0x00007fff2b4c6398 -[CALayer layoutSublayers] + 255
8   QuartzCore                          0x00007fff2b4cc523 _ZN2CA5Layer16layout_if_neededEPNS_11TransactionE + 523
9   QuartzCore                          0x00007fff2b4d7bba _ZN2CA5Layer28layout_and_display_if_neededEPNS_11TransactionE + 80
10  QuartzCore                          0x00007fff2b420c04 _ZN2CA7Context18commit_transactionEPNS_11TransactionEd + 324
11  QuartzCore                          0x00007fff2b4545ef _ZN2CA11Transaction6commitEv + 649
12  QuartzCore                          0x00007fff2b381645 _ZN2CA7Display11DisplayLink14dispatch_itemsEyyy + 921
13  QuartzCore                          0x00007fff2b4588f0 _ZL22display_timer_callbackP12__CFMachPortPvlS1_ + 299
14  CoreFoundation                      0x00007fff23d6187d __CFMachPortPerform + 157
15  CoreFoundation                      0x00007fff23da14e9 __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__ + 41
16  CoreFoundation                      0x00007fff23da0ae8 __CFRunLoopDoSource1 + 472
17  CoreFoundation                      0x00007fff23d9b514 __CFRunLoopRun + 2228
18  CoreFoundation                      0x00007fff23d9a944 CFRunLoopRunSpecific + 404
19  GraphicsServices                    0x00007fff38ba6c1a GSEventRunModal + 139
20  UIKitCore                           0x00007fff48c8b9ec UIApplicationMain + 1605
21  Demo                                0x000000010fabaf4b main + 75
22  libdyld.dylib                       0x00007fff51a231fd start + 1

```
