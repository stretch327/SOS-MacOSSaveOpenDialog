#tag Class
Protected Class ObjCClass
	#tag Method, Flags = &h0
		Sub AddMethod(selectorName as string, handle as ptr, signature as string)
		  #If TargetMacOS
		    CheckRegistered
		    
		    // SEL NSSelectorFromString(NSString *aSelectorName);
		    Declare Function NSSelectorFromString Lib "Foundation" ( aSelectorName As CFStringRef ) As Ptr
		    Declare Function class_addMethod Lib "Foundation"(cls As Ptr, name As Ptr, imp As Ptr, types As CString) As Boolean
		    
		    Dim SEL As ptr = NSSelectorFromString(selectorName)
		    Dim IMP As ptr = handle
		    Dim types As CString = signature
		    
		    If Not class_addMethod(mObj, SEL, IMP, types) Then
		      Raise New ObjCException("The method """ + selectorName + """ could not be added to """ + Introspection.GetType(Self).name + """")
		    End If
		  #EndIf
		  
		  // The docs for signature can be found at:
		  
		  // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100
		  
		  // Signature is the return type followed by @: (which refer to self and _cmd) followed by a series of characters indicating types. 
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddMethod(selectorName as string, handle as ptr, returnType as string, paramArray paramTypes as string)
		  #If TargetMacOS
		    CheckRegistered
		    
		    // SEL NSSelectorFromString(NSString *aSelectorName);
		    Declare Function NSSelectorFromString Lib "Foundation" ( aSelectorName As CFStringRef ) As Ptr
		    Declare Function class_addMethod Lib "Foundation"(cls As Ptr, name As Ptr, imp As Ptr, types As CString) As Boolean
		    
		    Dim SEL As ptr = NSSelectorFromString(selectorName)
		    Dim IMP As ptr = handle
		    Dim types As CString = MakeTypeEncoding(returnType, paramTypes)
		    
		    If Not class_addMethod(mObj, SEL, IMP, types) Then
		      Raise New ObjCException("The method """ + selectorName + """ could not be added to """ + Introspection.GetType(Self).name + """")
		    End If
		  #EndIf
		  
		  // The docs for signature can be found at:
		  
		  // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100
		  
		  // Signature is the return type followed by @: (which refer to self and _cmd) followed by a series of characters indicating types. 
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddProtocol(name as string)
		  #If TargetMacOS
		    CheckRegistered
		    
		    Declare Function objc_getProtocol Lib "Foundation"(name As CString) As Ptr
		    Declare Function class_addProtocol Lib "Foundation"(Cls As Ptr, protocol As Ptr) As Boolean
		    
		    If Not class_addProtocol(mObj, objc_getProtocol(name)) Then
		      Raise New ObjCException("The protocol """ + name + """ could not be added to """ + Introspection.GetType(Self).name + """")
		    End If
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CheckRegistered()
		  If mIsRegistered Then
		    Raise New ObjCException("The class """ + introspection.getType(Self).Name + """ is already registered and cannot accept new items.")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(className as string, superClassName as string = "NSObject", extraytes as integer = 0)
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    Declare Function objc_allocateClassPair Lib "Foundation"(superclass As Ptr, name As CString, extraBytes As Integer) As Ptr
		    
		    mobj = objc_allocateClassPair(NSClassFromString(superClassName), className, extraytes)
		    
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Handle() As Ptr
		  return mptr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Register()
		  #If TargetMacOS
		    If mIsRegistered Then
		      Raise New ObjCException("This class is already registered!")
		    End If
		    
		    Declare Sub objc_registerClassPair Lib "Foundation"(cls As Ptr)
		    
		    objc_registerClassPair(mObj)
		    
		    mIsRegistered = True
		    
		    // Initialize it
		    Declare Function init Lib "Foundation" Selector "init" (cls As ptr) As ptr
		    mPtr = init(mPtr)
		    
		    Declare Function Retain Lib "Foundation" Selector "retain" (cls As ptr) As Ptr
		    
		    mPtr = Retain(mPtr)
		  #EndIf
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared mCache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsRegistered As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mObj As ptr
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPtr As Ptr
	#tag EndProperty


	#tag Structure, Name = Block_Layout, Flags = &h0, Attributes = \"StructureAlignment \x3D 1"
		isa_ as Ptr
		  flags as int32
		  reserved as int32
		  invoke as ptr
		descriptor as ptr
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
