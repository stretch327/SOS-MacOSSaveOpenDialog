#tag Module
Protected Module ObjC
	#tag Method, Flags = &h21
		Private Function ConvertTypeEncoding(XojoType as string) As String
		  If XojoType = "" Then
		    Return ""
		  End If
		  
		  Dim isArray As Boolean = WrappedIn(XojoType, "[", "]")
		  Dim isStructure As Boolean = WrappedIn(XojoType, "{","}")
		  Dim isUnion As Boolean = WrappedIn(XojoType, "(",")")
		  
		  Select Case XojoType
		  Case "char"
		    Return "c"
		    
		  Case "int"
		    Return "i"
		    
		  Case "short", "int16"
		    Return "s"
		    
		  Case "long", "Int32"
		    Return "l"
		    
		  Case "long long", "Integer", "Int64"
		    Return "q"
		    
		  Case "unsigned char"
		    Return "C"
		    
		  Case "unsigned int"
		    Return "I"
		    
		  Case "unsigned short", "UInt16"
		    Return "S"
		    
		  Case "unsigned long", "UInt32"
		    Return "L"
		    
		  Case "unsigned long long", "UInt64"
		    Return "Q"
		    
		  Case "float"
		    Return "f"
		    
		  Case "double"
		    Return "d"
		    
		  Case "bool", "boolean"
		    Return "B"
		    
		  Case "void"
		    Return "v"
		    
		  Case "CString"
		    Return "*"
		    
		  Case "object"
		    Return "@"
		    
		  Case "Class"
		    Return "#"
		    
		  Case "Selector"
		    Return ":"
		    
		  Case "Unknown"
		    Return "?"
		    
		  Case "const"
		    Return "r"
		    
		  Case "in"
		    Return "n"
		    
		  Case "inout"
		    Return "N"
		    
		  Case "out"
		    Return "o"
		    
		  Case "bycopy"
		    Return "O"
		    
		  Case "byref"
		    Return "R"
		    
		  Case "oneway"
		    return "V"
		  End Select
		  
		  // otherwise we'll assume the caller gave is a type from the list
		  Return XojoType
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MakeTypeEncoding(returnType as string, params() as string) As String
		  Dim rv As String
		  
		  rv = ConvertTypeEncoding(returnType)
		  
		  rv = rv + "@:"
		  
		  For i As Integer = 0 To UBound(params)
		    rv = rv + ConvertTypeEncoding(params(i))
		  Next i
		  
		  return rv
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function WrappedIn(ByRef value as string, leftchar as string, rightchar as string) As Boolean
		  If Left(value,1) = leftchar And Right(value,1) = rightchar Then
		    value = Mid(value,2,Len(value)-2)
		    Return True
		  End If
		  
		  Return False
		End Function
	#tag EndMethod


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
End Module
#tag EndModule
