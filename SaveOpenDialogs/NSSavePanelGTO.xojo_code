#tag Class
Protected Class NSSavePanelGTO
	#tag Method, Flags = &h0
		Sub AccessoryView(assigns value as object)
		  #If TargetMacOS
		    Dim handle As Integer
		    #If XojoVersion >= 2021.03
		      Dim h As OSHandle
		      If value IsA DesktopContainer Then
		        h = DesktopContainer(value).Handle
		      ElseIf value IsA ContainerControl Then
		        h = ContainerControl(value).Handle
		      End If
		      handle = h
		    #Else
		      If value IsA ContainerControl Then
		        handle = ContainerControl(value).Handle
		      End If
		    #EndIf
		    
		    If handle = 0 Then
		      Raise New UnsupportedOperationException("AccessoryView only accepts DesktopContainers or ContainerControls")
		    End If
		    
		    Declare Sub setAccessoryView Lib "Foundation" Selector "setAccessoryView:" (obj As ptr, value As Integer)
		    
		    setAccessoryView(mPtr, handle)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  #If TargetMacOS
		    
		    Declare Sub orderOut_ Lib "Foundation" Selector "orderOut:" ( obj As ptr , sender As Ptr )
		    
		    orderOut_(mPtr, Nil)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    Declare Function savePanel Lib "Foundation" Selector "savePanel" ( cls As ptr ) As Ptr
		    
		    mptr = savePanel(NSClassFromString("NSSavePanel"))
		    
		    Self.Constructor("NSSavePanel")
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(superclass as string)
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    
		    ClassObj = NSClassFromString(superclass)
		    
		    mClassName = superclass
		    
		    // initialize the duplicate event info
		    zLastDirectoryChange = "":0
		    zLastEnableURL = Nil:Nil
		    zLastUserEnteredFilename = Nil : Nil
		    zLastValidateURLError = Nil : Nil
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  ' #If TargetMacOS
		  ' If mDelegateCache.HasKey(mPtr) Then
		  ' mDelegateCache.Remove(mPtr)
		  ' End If
		  ' #EndIf
		  
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub DirectoryChangedDelegate(sender as NSSavePanelGTO, f as FolderItem)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Sub Filter(assigns value() as FileType)
		  #If TargetMacOS
		    Declare Sub setAllowedContentTypes Lib "Foundation" Selector "setAllowedContentTypes:" (obj As ptr, value As Ptr)
		    
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    // + (instancetype)arrayWithCapacity:(NSUInteger)numItems;
		    Declare Function arrayWithCapacity_ Lib "Foundation" Selector "arrayWithCapacity:" ( cls As ptr , numItems As Integer ) As Ptr
		    // - (void)addObject:(ObjectType)anObject;
		    Declare Sub addObject_ Lib "Foundation" Selector "addObject:" ( obj As ptr , anObject As Ptr )
		    Declare Sub addStringObject_ Lib "Foundation" Selector "addObject:" ( obj As ptr , anObject As CFStringRef )
		    
		    // + (UTType *)exportedTypeWithIdentifier:(NSString *)identifier;
		    Declare Function exportedTypeWithIdentifier_ Lib "Foundation" Selector "exportedTypeWithIdentifier:" ( cls As ptr , identifier As CFStringRef ) As Ptr
		    // + (UTType *)importedTypeWithIdentifier:(NSString *)identifier;
		    Declare Function importedTypeWithIdentifier_ Lib "Foundation" Selector "importedTypeWithIdentifier:" (cls As ptr, identifier As CFStringRef) As Ptr
		    // @property(copy) NSArray<NSString *> *allowedFileTypes;
		    Declare Sub setAllowedFileTypes Lib "Foundation" Selector "setAllowedFileTypes:" (obj As ptr, value As Ptr)
		    
		    Dim arr As ptr = arrayWithCapacity_(NSClassFromString("NSMutableArray"), UBound(value)+1)
		    Dim UTType As ptr = NSClassFromString("UTType")
		    For i As Integer = 0 To UBound(value)
		      If MacOSVersion.MajorVersion <= 10 Then
		        addStringObject_(arr, value(i).UTI)
		      Else
		        Dim t As ptr = exportedTypeWithIdentifier_(UTType, value(i).UTI)
		        If t = Nil Then
		          t = importedTypeWithIdentifier_(UTType, value(i).UTI)
		        End If
		        addObject_(arr, t)
		      End If
		    Next i
		    
		    If MacOSVersion.MajorVersion <= 10 Then
		      setAllowedFileTypes(mPtr, arr)
		    Else
		      setAllowedContentTypes(mPtr, arr)
		    End If
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Filter(paramarray values as FileType)
		  #If TargetMacOS
		    filter = values
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function Folderitem2NSURL(f as FolderItem) As ptr
		  #If TargetMacOS
		    // + (instancetype)URLWithString:(NSString *)URLString;
		    Declare Function URLWithString_ Lib "Foundation" Selector "URLWithString:" (cls As ptr, URLString As CFStringRef) As Ptr
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    
		    Return URLWithString_(NSClassFromString("NSURL"), f.URLPath)
		  #endif
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub ItemsSelectedDelegate(sender as NSSavePanelGTO, items() as FolderItem)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h1
		Protected Shared Function NSURL2Folderitem(nsurl as ptr) As FolderItem
		  #If TargetMacOS
		    Declare Function getAbsoluteString Lib "Foundation" Selector "absoluteString" (obj As ptr) As CFStringRef
		    Dim f As New FolderItem(getAbsoluteString(nsurl), FolderItem.PathModes.URL)
		    
		    Return f
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Response(value as integer)
		  #If TargetMacOS
		    If mDelegateCache.HasKey(mPtr) Then
		      mDelegateCache.Remove(mPtr)
		    End If
		    
		    If Callback_ItemsSelected = Nil Then
		      Return
		    End If
		    
		    Dim items() As FolderItem
		    If value = 0 Then
		      Callback_ItemsSelected.Invoke(Self, items)
		      Return
		    End If
		    
		    Declare Function getAbsoluteString Lib "Foundation" Selector "absoluteString" (obj As ptr) As CFStringRef
		    
		    If Self IsA NSOpenPanelGTO And NSOpenPanelGTO(Self).AllowMultipleSelection Then
		      Callback_ItemsSelected.Invoke(Self, NSOpenPanelGTO(Self).SelectedFiles)
		      Return
		    End If
		    
		    Dim f As FolderItem = SelectedFile
		    If f<>Nil Then
		      Callback_ItemsSelected.Invoke(Self, Array(f))
		    End If
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub SelectionChangedDelegate(sender as NSSavePanelGTO)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h21
		Private Sub SetupDelegate()
		  // check to make sure the user has defined the delegate for getting
		  If Callback_ItemsSelected = Nil Then
		    Raise New UnsupportedOperationException("You must assign a method to the ItemsSelected callback delegate")
		  End If
		  
		  // create a delegate class so that we can satisfy the NSOpenSavePanelDelegate protocol
		  mDelegateObj = New ObjC.ObjCClass("panelDelegate" + Str(Ticks), "NSObject")
		  mDelegateObj.AddProtocol("NSOpenSavePanelDelegate")
		  
		  If Callback_UserEnteredFilename <> Nil Then
		    mDelegateObj.AddMethod( "panel:userEnteredFilename:confirmed:", AddressOf zUserEnteredFilename, "@@:@@B")
		  End If
		  
		  If Callback_SelectionChanged <> Nil Then
		    mDelegateObj.AddMethod( "panelSelectionDidChange:", AddressOf zPanelSelectionDidChange, "v@:@")
		  End If
		  
		  If Callback_DirectoryChanged <> Nil Then
		    mDelegateObj.AddMethod( "panel:didChangeToDirectoryURL:", AddressOf zDidChangeToDirectoryURL, "v@:@@")
		  End If
		  
		  If Callback_WillExpand <> Nil Then
		    mDelegateObj.AddMethod( "panel:willExpand:", AddressOf zWillExpand, "v@:@B")
		  End If
		  
		  If Callback_ShouldEnableItem <> Nil Then
		    mDelegateObj.AddMethod( "panel:shouldEnableURL:", AddressOf zShouldEnableURL, "B@:@@")
		  End If
		  
		  If Callback_ValidateItem <> Nil Then
		    mDelegateObj.AddMethod( "panel:validateURL:error:", AddressOf zValidateURLError, "B@:@@@")
		  End If
		  
		  // if no methods were added, don't add the delegate
		  If mDelegateObj.HasMethods = False Then
		    Return
		  End If
		  
		  mDelegateObj.Register
		  
		  Declare Sub setDelegate Lib "Foundation" Selector "setDelegate:" (obj As ptr, value As Ptr)
		  setDelegate(mPtr, mDelegateObj.Handle)
		  
		  If mDelegateCache = Nil Then
		    mDelegateCache = New Dictionary
		  End If
		  
		  mDelegateCache.Value(mPtr) = Self
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function ShouldEnableItemDelegate(sender as NSSavePanelGTO, f as FolderItem) As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Sub Show()
		  #If TargetMacOS
		    SetupDelegate
		    
		    Dim bl As New ObjCBlock(AddressOf Response)
		    
		    Declare Sub beginWithCompletionHandler Lib "Foundation" Selector "beginWithCompletionHandler:" ( obj As ptr, blk As ptr )
		    
		    beginWithCompletionHandler(mptr, bl.Handle)
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowModal()
		  #If TargetMacOS
		    SetupDelegate
		    
		    Declare Function runModal Lib "Foundation" Selector "runModal" ( obj As ptr ) As Integer
		    
		    Var iResponse As Integer = runModal( mptr )
		    
		    Response( iResponse )
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowWithin(parent as DesktopWindow)
		  #If TargetMacOS
		    SetupDelegate
		    
		    Dim bl As New ObjCBlock(AddressOf Response)
		    Declare Sub beginSheetModalForWindow_completionHandler Lib "Foundation" Selector "beginSheetModalForWindow:completionHandler:" ( obj As ptr , Window As Ptr, callback As ptr )
		    beginSheetModalForWindow_completionHandler(mPtr, parent.Handle, bl.Handle)
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowWithin(parent as Window)
		  #If TargetMacOS
		    SetupDelegate
		    
		    Dim bl As New ObjCBlock(AddressOf Response)
		    Declare Sub beginSheetModalForWindow_completionHandler Lib "Foundation" Selector "beginSheetModalForWindow:completionHandler:" ( obj As ptr , Window As Integer, callback As ptr )
		    beginSheetModalForWindow_completionHandler(mPtr, parent.Handle, bl.Handle)
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function UserEnteredFilenameDelegate(sender as NSSavePanelGTO, filename as string, confirmed as Boolean) As Boolean
	#tag EndDelegateDeclaration

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function ValidateItemDelegate(sender as NSSavePanelGTO, f as FolderItem) As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Sub ValidateVisibleColumns()
		  #If TargetMacOS
		    // - (void)validateVisibleColumns;
		    Declare Sub validateVisibleColumns Lib "Foundation" Selector "validateVisibleColumns" (obj As ptr)
		    
		    validateVisibleColumns(mPtr)
		  #endif
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub WillExpandDelegate(sender as NSSavePanelGTO, expanding as Boolean)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h21
		Private Shared Sub zDidChangeToDirectoryURL(obj as ptr, sel as ptr, sender as ptr, url as ptr)
		  #If TargetMacOS
		    // get the matching object
		    Dim panel As NSSavePanelGTO = mDelegateCache.Lookup(sender, Nil)
		    If panel = Nil Then
		      Return
		    End If
		    // call the callback method
		    panel.zDidChangeToDirectoryURL_Callback(url)
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub zDidChangeToDirectoryURL_Callback(url as ptr)
		  #If TargetMacOS
		    If Callback_DirectoryChanged = Nil Then
		      Return
		    End If
		    
		    Declare Function getAbsoluteString Lib "Foundation" Selector "absoluteString" (obj As ptr) As CFStringRef
		    Dim s As String = getAbsoluteString(url)
		    
		    If SuppressDuplicateEvents And s = zLastDirectoryChange.Left And (Ticks - zlastdirectorychange.Right) <= 7 Then
		      Return
		    End If
		    
		    Dim f As New FolderItem(s, FolderItem.PathModes.URL)
		    
		    zLastDirectoryChange = s : ticks
		    
		    Callback_DirectoryChanged.Invoke(self, f)
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub zPanelSelectionDidChange(obj as ptr, sel as ptr, sender as ptr)
		  #If TargetMacOS
		    // get the matching object
		    Dim panel As NSSavePanelGTO = mDelegateCache.Lookup(sender, Nil)
		    If panel = Nil Then
		      Return
		    End If
		    // call the callback method
		    panel.zPanelSelectionDidChange_Callback
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub zPanelSelectionDidChange_Callback()
		  If Callback_SelectionChanged = Nil Then
		    Return
		  End If
		  
		  Dim ct As Double = Ticks
		  If ct - zLastSelectionChanged < 7 Then
		    Return
		  End If
		  
		  zLastSelectionChanged = ct
		  
		  Callback_SelectionChanged.Invoke(self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function zShouldEnableURL(obj as ptr, sel as ptr, sender as ptr, url as ptr) As Boolean
		  #If TargetMacOS
		    // get the matching object
		    Dim panel As NSSavePanelGTO = mDelegateCache.Lookup(sender, Nil)
		    If panel = Nil Then
		      Return True
		    End If
		    // call the callback method
		    Return panel.zShouldEnableURL_Callback(url)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function zShouldEnableURL_Callback(url as ptr) As Boolean
		  If Callback_ShouldEnableItem = Nil Then
		    Return True
		  End If
		  
		  Dim f As FolderItem = NSURL2Folderitem(url)
		  If SuppressDuplicateEvents And f.URLPath = zLastEnableURL.Left Then
		    Return zLastEnableURL.Right
		  End If
		  
		  Dim rv As Boolean = Callback_ShouldEnableItem.Invoke(self, f)
		  
		  zLastEnableURL = f.URLPath : rv
		  
		  Return rv
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function zUserEnteredFilename(obj as ptr, sel as ptr, sender as ptr, filename as CFStringRef, confirmed as Boolean) As CFStringRef
		  #If TargetMacOS
		    // get the matching object
		    Dim panel As NSSavePanelGTO = mDelegateCache.Lookup(sender, Nil)
		    If panel = Nil Then
		      Return filename
		    End If
		    // call the callback method
		    return panel.zUserEnteredFilename_Callback(filename, confirmed)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function zUserEnteredFilename_Callback(filename as CFStringRef, confirmed as Boolean) As CFStringRef
		  If Callback_UserEnteredFilename = Nil Then
		    Return filename
		  End If
		  
		  If Callback_UserEnteredFilename.Invoke(Self, filename, confirmed) Then
		    Return filename
		  End If
		  
		  Return Nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function zValidateURLError(obj as ptr, sel as ptr, sender as ptr, url as ptr, error as ptr) As Boolean
		  #If TargetMacOS
		    // get the matching object
		    Dim panel As NSSavePanelGTO = mDelegateCache.Lookup(sender, Nil)
		    If panel = Nil Then
		      Return False
		    End If
		    // call the callback method
		    Return panel.zValidateURLError_Callback(url, error)
		  #EndIf
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function zValidateURLError_Callback(url as ptr, error as ptr) As Boolean
		  If Callback_ValidateItem = Nil Then
		    Return True
		  End If
		  
		  Dim f As FolderItem = NSURL2Folderitem(url)
		  
		  Return Callback_ValidateItem.Invoke(Self, f)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub zWillExpand(obj as ptr, sel as ptr, sender as ptr, expanding as Boolean)
		  #If TargetMacOS
		    // get the matching object
		    Dim panel As NSSavePanelGTO = mDelegateCache.Lookup(sender, Nil)
		    If panel = Nil Then
		      Return
		    End If
		    // call the callback method
		    panel.zWillExpand_Callback(expanding)
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub zWillExpand_Callback(expanding as Boolean)
		  If Callback_WillExpand = Nil Then
		    Return
		  End If
		  
		  If SuppressDuplicateEvents Then
		    Dim currentMS As Integer = Ticks / 6 // 10ths of a second
		    If zLastWillExpand = CurrentMS Then
		      Return
		    End If
		    zLastWillExpand = currentMS
		  End If
		  
		  Callback_WillExpand.Invoke(Self, expanding)
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property(copy) NSString *prompt;
			    Declare Function getPrompt Lib "Foundation" Selector "prompt" (obj As ptr) As CFStringRef
			    
			    Return getPrompt(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setPrompt Lib "Foundation" Selector "setPrompt:" (obj As ptr, value As CFStringRef)
			    setPrompt(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		ActionButtonCaption As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property BOOL allowsOtherFileTypes;
			    Declare Function getAllowsOtherFileTypes Lib "Foundation" Selector "allowsOtherFileTypes" (obj As ptr) As Boolean
			    
			    Return getAllowsOtherFileTypes(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setAllowsOtherFileTypes Lib "Foundation" Selector "setAllowsOtherFileTypes:" (obj As ptr, value As Boolean)
			    setAllowsOtherFileTypes(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		AllowsOtherFileTypes As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Callback_DirectoryChanged As DirectoryChangedDelegate
	#tag EndProperty

	#tag Property, Flags = &h0
		Callback_ItemsSelected As ItemsSelectedDelegate
	#tag EndProperty

	#tag Property, Flags = &h0
		Callback_SelectionChanged As SelectionChangedDelegate
	#tag EndProperty

	#tag Property, Flags = &h0
		Callback_ShouldEnableItem As ShouldEnableItemDelegate
	#tag EndProperty

	#tag Property, Flags = &h0
		Callback_UserEnteredFilename As UserEnteredFilenameDelegate
	#tag EndProperty

	#tag Property, Flags = &h0
		Callback_ValidateItem As ValidateItemDelegate
	#tag EndProperty

	#tag Property, Flags = &h0
		Callback_WillExpand As WillExpandDelegate
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property BOOL canCreateDirectories;
			    Declare Function getCanCreateDirectories Lib "Foundation" Selector "canCreateDirectories" (obj As ptr) As Boolean
			    Return getCanCreateDirectories(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setCanCreateDirectories Lib "Foundation" Selector "setCanCreateDirectories:" (obj As ptr, value As Boolean)
			    
			    setCanCreateDirectories(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		CanCreateDirectories As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property BOOL canSelectHiddenExtension;
			    Declare Function getCanSelectHiddenExtension Lib "Foundation" Selector "canSelectHiddenExtension" (obj As ptr) As Boolean
			    Return getCanSelectHiddenExtension(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setCanSelectHiddenExtension Lib "Foundation" Selector "setCanSelectHiddenExtension:" (obj As ptr, value As Boolean)
			    
			    setCanSelectHiddenExtension(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		CanSelectHiddenExtension As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected ClassObj As Ptr
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property(copy) NSURL *directoryURL;
			    Declare Function getDirectoryURL Lib "Foundation" Selector "directoryURL" (obj As ptr) As Ptr
			    
			    Return NSURL2Folderitem(getDirectoryURL(mPtr))
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setDirectoryURL Lib "Foundation" Selector "setDirectoryURL:" (obj As ptr, value As Ptr)
			    
			    setDirectoryURL(mPtr, Folderitem2NSURL(value))
			  #endif
			End Set
		#tag EndSetter
		Directory As FolderItem
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property(getter=isExtensionHidden) BOOL extensionHidden;
			    Declare Function isExtensionHidden Lib "Foundation" Selector "isExtensionHidden" (obj As ptr) As Boolean
			    Return isExtensionHidden(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setExtensionHidden Lib "Foundation" Selector "setExtensionHidden:" (obj As ptr, value As Boolean)
			    setExtensionHidden(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		ExtensionHidden As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property(copy) NSURL *directoryURL;
			    Declare Function getDirectoryURL Lib "Foundation" Selector "directoryURL" (obj As ptr) As Ptr
			  #EndIf
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setDirectoryURL Lib "Foundation" Selector "setDirectoryURL:" (obj As ptr, value As Ptr)
			    // + (instancetype)URLWithString:(NSString *)URLString;
			    Declare Function URLWithString Lib "Foundation" Selector "URLWithString:" ( cls As ptr , URLString As CFStringRef ) As Ptr
			    
			    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
			    
			    If value = Nil Then
			      setDirectoryURL(mPtr, Nil)
			    Else
			      setDirectoryURL(mPtr, URLWithString(NSClassFromString("NSURL"), value.URLPath))
			    End If
			  #endif
			End Set
		#tag EndSetter
		InitialFolder As FolderItem
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property(getter=isExpanded, readonly) BOOL expanded;
			    Declare Function isExpanded Lib "Foundation" Selector "isExpanded" (obj As ptr) As Boolean
			    Return isExpanded(mPtr)
			  #endif
			End Get
		#tag EndGetter
		IsExpanded As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mClassName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mDelegateCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDelegateObj As ObjC.ObjCClass
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mPtr As Ptr
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property(copy) NSString *nameFieldLabel;
			    Declare Function getNameFieldLabel Lib "Foundation" Selector "nameFieldLabel" (obj As ptr) As CFStringRef
			    
			    Return getNameFieldLabel(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setNameFieldLabel Lib "Foundation" Selector "setNameFieldLabel:" (obj As ptr, value As CFStringRef)
			    setNameFieldLabel(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		NameFieldLabel As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property(copy) NSString *message;
			    Declare Function getMessage Lib "Foundation" Selector "message" (obj As ptr) As CFStringRef
			    Return getMessage(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setMessage Lib "Foundation" Selector "setMessage:" (obj As ptr, value As CFStringRef)
			    setMessage(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		PromptText As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property(nullable, readonly, copy) NSURL *URL;
			    Declare Function getURL Lib "Foundation" Selector "URL" (obj As ptr) As Ptr
			    
			    Dim url As ptr = getURL(mPtr)
			    
			    If url = Nil Then
			      Return Nil
			    End If
			    
			    Return NSURL2Folderitem(url)
			  #endif
			End Get
		#tag EndGetter
		SelectedFile As FolderItem
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property BOOL showsHiddenFiles;
			    Declare Function getShowsHiddenFiles Lib "Foundation" Selector "showsHiddenFiles" (obj As ptr) As Boolean
			    Return getShowsHiddenFiles(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setShowsHiddenFiles Lib "Foundation" Selector "setShowsHiddenFiles:" (obj As ptr, value As Boolean)
			    setShowsHiddenFiles(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		ShowsHiddenFiles As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property BOOL showsTagField;
			    Declare Function getShowsTagField Lib "Foundation" Selector "showsTagField" (obj As ptr) As Boolean
			    
			    Return getShowsTagField(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setShowsTagField Lib "Foundation" Selector "setShowsTagField:" (obj As ptr, value As Boolean)
			    setShowsTagField(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		ShowsTagField As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property(copy) NSString *nameFieldStringValue;
			    Declare Function getNameFieldStringValue Lib "Foundation" Selector "nameFieldStringValue" (obj As ptr) As CFStringRef
			    
			    Return getNameFieldStringValue(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setNameFieldStringValue Lib "Foundation" Selector "setNameFieldStringValue:" (obj As ptr, value As CFStringRef)
			    
			    setNameFieldStringValue(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		SuggestedFileName As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		SuppressDuplicateEvents As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property(copy) NSString *title;
			    Declare Function getTitle Lib "Foundation" Selector "title" (obj As ptr) As CFStringRef
			    
			    Return getTitle(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setTitle Lib "Foundation" Selector "setTitle:" (obj As ptr, value As CFStringRef)
			    
			    setTitle(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		Title As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #If TargetMacOS
			    // @property BOOL treatsFilePackagesAsDirectories;
			    Declare Function getTreatsFilePackagesAsDirectories Lib "Foundation" Selector "treatsFilePackagesAsDirectories" (obj As ptr) As Boolean
			    Return getTreatsFilePackagesAsDirectories(mPtr)
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #If TargetMacOS
			    Declare Sub setTreatsFilePackagesAsDirectories Lib "Foundation" Selector "setTreatsFilePackagesAsDirectories:" (obj As ptr, value As Boolean)
			    setTreatsFilePackagesAsDirectories(mPtr, value)
			  #endif
			End Set
		#tag EndSetter
		TreatsPackagesAsFolders As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private zLastDirectoryChange As Pair
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zLastEnableURL As Pair
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zLastSelectedItems() As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zLastSelectionChanged As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zLastUserEnteredFilename As Pair
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zLastValidateURLError As Pair
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zLastWillExpand As Integer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ActionButtonCaption"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PromptText"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NameFieldLabel"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SuggestedFileName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowsTagField"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanCreateDirectories"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanSelectHiddenExtension"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowsHiddenFiles"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ExtensionHidden"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsExpanded"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TreatsPackagesAsFolders"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowsOtherFileTypes"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SuppressDuplicateEvents"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
