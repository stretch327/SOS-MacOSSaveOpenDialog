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
		    Self.Constructor("NSSavePanel")
		    
		    Declare Function savePanel Lib "Foundation" Selector "savePanel" ( cls As ptr ) As Ptr
		    
		    mptr = savePanel(ClassObj)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(superclass as string)
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    
		    ClassObj = NSClassFromString(superclass)
		    
		    mClassName = superclass
		  #EndIf
		End Sub
	#tag EndMethod

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
		      If MacOSVersion.MajorVersion <= 12 Then
		        addStringObject_(arr, value(i).UTI)
		      Else
		        Dim t As ptr = exportedTypeWithIdentifier_(UTType, value(i).UTI)
		        If t = Nil Then
		          t = importedTypeWithIdentifier_(UTType, value(i).UTI)
		        End If
		        addObject_(arr, t)
		      End If
		    Next i
		    
		    If MacOSVersion.MajorVersion <= 12 Then
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

	#tag Method, Flags = &h21
		Private Sub Response(value as integer)
		  #If TargetMacOS
		    Dim items() As FolderItem
		    If value = 0 Then
		      RaiseEvent ItemsSelected(items)
		    End If
		    
		    Declare Function getAbsoluteString Lib "Foundation" Selector "absoluteString" (obj As ptr) As CFStringRef
		    
		    If Self IsA NSOpenPanelGTO And NSOpenPanelGTO(Self).AllowMultipleSelection Then
		      // @property(readonly, copy) NSArray<NSURL *> *URLs;
		      Declare Function getURLs Lib "Foundation" Selector "URLs" (obj As ptr) As Ptr
		      
		      Dim urlArray As ptr = getURLs(mPtr)
		      If urlArray <> Nil Then
		        // @property(readonly) NSUInteger count;
		        Declare Function getCount Lib "Foundation" Selector "count" (obj As ptr) As Integer
		        // - (ObjectType)objectAtIndex:(NSUInteger)index;
		        Declare Function objectAtIndex_ Lib "Foundation" Selector "objectAtIndex:" ( obj As ptr , index As Integer ) As Ptr
		        Dim c As Integer = getCount(urlArray)
		        
		        For i As Integer = 0 To c-1
		          items.Add New FolderItem(getAbsoluteString(objectAtIndex_(urlArray, i)), FolderItem.PathModes.URL, False)
		        Next i
		        
		        RaiseEvent ItemsSelected(items)
		        
		        Return
		      End If
		    End If
		    
		    // @property(nullable, readonly, copy) NSURL *URL;
		    Declare Function getURL Lib "Foundation" Selector "URL" (obj As ptr) As Ptr
		    
		    Dim url As ptr = getURL(mPtr)
		    
		    If url<>Nil Then
		      // @property(nullable, readonly, copy) NSString *absoluteString;
		      
		      Dim f As New FolderItem(getAbsoluteString(url), folderitem.PathModes.URL)
		      RaiseEvent ItemsSelected(Array(f))
		      Return
		    End If
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Show()
		  #If TargetMacOS
		    Dim bl As New ObjCBlock(AddressOf Response)
		    
		    Declare Sub beginWithCompletionHandler Lib "Foundation" Selector "beginWithCompletionHandler:" ( obj As ptr, blk As ptr )
		    
		    beginWithCompletionHandler(mptr, bl.Handle)
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowWithin(parent as Object)
		  #If TargetMacOS
		    Dim handle As Integer
		    #If XojoVersion >= 2021.03
		      Dim h As OSHandle
		      If parent IsA DesktopWindow Then
		        h = DesktopWindow(parent).Handle
		      ElseIf parent IsA Window Then
		        h = Window(parent).Handle
		      End If
		      handle = h
		    #Else
		      If parent IsA Window Then
		        handle = Window(parent).Handle
		      End If
		    #EndIf
		    
		    If handle = 0 Then
		      Raise New UnsupportedOperationException("This class only works with Windows and DesktopWindows")
		      Return
		    End If
		    
		    Dim bl As New ObjCBlock(AddressOf Response)
		    Declare Sub beginSheetModalForWindow_completionHandler Lib "Foundation" Selector "beginSheetModalForWindow:completionHandler:" ( obj As ptr , Window As Integer, callback As ptr )
		    beginSheetModalForWindow_completionHandler(mPtr, Handle, bl.Handle)
		  #EndIf
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event ItemsSelected(items() as FolderItem)
	#tag EndHook


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
	#tag EndViewBehavior
End Class
#tag EndClass
