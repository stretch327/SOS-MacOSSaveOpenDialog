#tag Class
Protected Class NSOpenPanel
Inherits NSSavePanel
	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.Constructor("NSOpenPanel")
		  
		  // + (NSOpenPanel *)openPanel;
		  Declare Function openPanel Lib "Foundation" Selector "openPanel" ( cls As ptr ) As Ptr
		  
		  mPtr = openPanel(ClassObj)
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // @property(getter=isAccessoryViewDisclosed) BOOL accessoryViewDisclosed;
			  Declare Function isAccessoryViewDisclosed Lib "Foundation" Selector "isAccessoryViewDisclosed" (obj As ptr) As Boolean
			  return isAccessoryViewDisclosed(mPtr)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Declare Sub setAccessoryViewDisclosed Lib "Foundation" Selector "setAccessoryViewDisclosed:" (obj As ptr, value As Boolean)
			  setAccessoryViewDisclosed(mPtr, value)
			End Set
		#tag EndSetter
		AccessoryViewVisible As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // @property BOOL allowsMultipleSelection;
			  Declare Function getAllowsMultipleSelection Lib "Foundation" Selector "allowsMultipleSelection" (obj As ptr) As Boolean
			  Return getAllowsMultipleSelection(mPtr)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Declare Sub setAllowsMultipleSelection Lib "Foundation" Selector "setAllowsMultipleSelection:" (obj As ptr, value As Boolean)
			  setAllowsMultipleSelection(mPtr, value)
			End Set
		#tag EndSetter
		AllowMultipleSelection As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // @property BOOL canChooseDirectories;
			  Declare Function getCanChooseDirectories Lib "Foundation" Selector "canChooseDirectories" (obj As ptr) As Boolean
			  Return getCanChooseDirectories(mPtr)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Declare Sub setCanChooseDirectories Lib "Foundation" Selector "setCanChooseDirectories:" (obj As ptr, value As Boolean)
			  setCanChooseDirectories(mPtr, value)
			End Set
		#tag EndSetter
		CanChooseDirectories As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // @property BOOL canChooseFiles;
			  Declare Function getCanChooseFiles Lib "Foundation" Selector "canChooseFiles" (obj As ptr) As Boolean
			  return getCanChooseFiles(mPtr)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Declare Sub setCanChooseFiles Lib "Foundation" Selector "setCanChooseFiles:" (obj As ptr, value As Boolean)
			  setCanChooseFiles(mPtr, value)
			End Set
		#tag EndSetter
		CanChooseFiles As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // @property BOOL canDownloadUbiquitousContents;
			  Declare Function getCanDownloadUbiquitousContents Lib "Foundation" Selector "canDownloadUbiquitousContents" (obj As ptr) As Boolean
			  
			  return getCanDownloadUbiquitousContents(mPtr)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Declare Sub setCanDownloadUbiquitousContents Lib "Foundation" Selector "setCanDownloadUbiquitousContents:" (obj As ptr, value As Boolean)
			  setCanDownloadUbiquitousContents(mPtr, value)
			End Set
		#tag EndSetter
		CanDownloadUbiquitousContents As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // @property BOOL canResolveUbiquitousConflicts;
			  Declare Function getCanResolveUbiquitousConflicts Lib "Foundation" Selector "canResolveUbiquitousConflicts" (obj As ptr) As Boolean
			  
			  return getCanResolveUbiquitousConflicts(mPtr)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Declare Sub setCanResolveUbiquitousConflicts Lib "Foundation" Selector "setCanResolveUbiquitousConflicts:" (obj As ptr, value As Boolean)
			  setCanResolveUbiquitousConflicts(mPtr, value)
			End Set
		#tag EndSetter
		CanResolveUbiquitousConflicts As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // @property BOOL resolvesAliases;
			  Declare Function getResolvesAliases Lib "Foundation" Selector "resolvesAliases" (obj As ptr) As Boolean
			  return getResolvesAliases(mPtr)
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Declare Sub setResolvesAliases Lib "Foundation" Selector "setResolvesAliases:" (obj As ptr, value As Boolean)
			  setResolvesAliases(mPtr, value)
			End Set
		#tag EndSetter
		ResolvesAliases As Boolean
	#tag EndComputedProperty


	#tag ViewBehavior
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
			Name="CanChooseFiles"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanChooseDirectories"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ResolvesAliases"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowMultipleSelection"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AccessoryViewVisible"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanDownloadUbiquitousContents"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanResolveUbiquitousConflicts"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
