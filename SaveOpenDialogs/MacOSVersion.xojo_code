#tag Class
Protected Class MacOSVersion
	#tag Method, Flags = &h21
		Private Shared Sub Initialize()
		  #If TargetMacOS
		    If vers.majorVersion > 0 then
		      Return
		    End If
		    
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    
		    // @property(class, readonly, strong) NSProcessInfo *processInfo;
		    Declare Function getProcessInfo Lib "Foundation" Selector "processInfo" (cls As ptr) As Ptr
		    
		    // @property(readonly) NSOperatingSystemVersion operatingSystemVersion;
		    Declare Function getOperatingSystemVersion Lib "Foundation" Selector "operatingSystemVersion" (obj As ptr) As NSOperatingSystemVersion
		    
		    Dim processInfo As ptr = getProcessInfo(NSClassFromString("NSProcessInfo"))
		    
		    vers = getOperatingSystemVersion(processInfo)
		  #EndIf
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Initialize
			  
			  return vers.majorVersion
			End Get
		#tag EndGetter
		Shared MajorVersion As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Initialize
			  
			  return vers.minorVersion
			End Get
		#tag EndGetter
		Shared MinorVersion As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Initialize
			  
			  return vers.patchVersion
			End Get
		#tag EndGetter
		Shared PatchVersion As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Shared vers As NSOperatingSystemVersion
	#tag EndProperty


	#tag Structure, Name = NSOperatingSystemVersion, Flags = &h21
		majorVersion as Integer
		  minorVersion as Integer
		patchVersion as Integer
	#tag EndStructure


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
	#tag EndViewBehavior
End Class
#tag EndClass
