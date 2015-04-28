#tag Window
Begin Window DropBoxAuthorizeWindow
   BackColor       =   &cFFFFFF00
   Backdrop        =   0
   CloseButton     =   True
   Compatibility   =   ""
   Composite       =   True
   Frame           =   11
   FullScreen      =   False
   FullScreenButton=   False
   HasBackColor    =   False
   Height          =   323
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   323
   MaximizeButton  =   False
   MaxWidth        =   582
   MenuBar         =   706190868
   MenuBarVisible  =   True
   MinHeight       =   323
   MinimizeButton  =   False
   MinWidth        =   562
   Placement       =   0
   Resizeable      =   True
   Title           =   "Dropbox Account Authorization"
   Visible         =   True
   Width           =   562
   Begin HTMLViewer HTMLViewer1
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   323
      HelpTag         =   ""
      Index           =   -2147483648
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Renderer        =   0
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   0
      Visible         =   False
      Width           =   562
      Begin Canvas AuthCompleteCanvas
         AcceptFocus     =   False
         AcceptTabs      =   False
         AutoDeactivate  =   True
         Backdrop        =   0
         DoubleBuffer    =   False
         Enabled         =   True
         EraseBackground =   True
         Height          =   323
         HelpTag         =   ""
         Index           =   -2147483648
         InitialParent   =   "HTMLViewer1"
         Left            =   0
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         Top             =   0
         Transparent     =   True
         UseFocusRing    =   True
         Visible         =   False
         Width           =   562
      End
   End
   Begin Separator Separator1
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   4
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   -25
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   322
      Visible         =   True
      Width           =   587
   End
   Begin ChartOpenCircle ChartOpenCircle1
      AcceptFocus     =   False
      AcceptTabs      =   True
      AnimationInterval=   20
      AutoDeactivate  =   True
      BackColor       =   &cFFFFFF00
      Backdrop        =   0
      ChartColor      =   &c00000000
      Enabled         =   True
      EraseBackground =   False
      HasBackColor    =   False
      Height          =   122
      HelpTag         =   ""
      InitialParent   =   ""
      Left            =   216
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      PercentValue    =   0
      Scope           =   0
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      TextColor       =   &c00000000
      Top             =   94
      Transparent     =   True
      UseFocusRing    =   False
      Visible         =   True
      Width           =   130
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Close()
		  // SEND ACCESS CODE CALL TO RETRIEVE TOKEN INFO VIA HTTPS TLS SOCKET
		  DropboxOAUTHSocket.API_Call_GetToken()
		  
		  // ENABLE MAIN WINDOW BUTTONS FOR DEMO
		  DemoWindow.UpdateDemoWindow()
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  // INSTANTIATE DROPBOX API CLASS
		  DropboxOAUTHSocket = New Dropbox_oAuth_Socket
		  
		  // SET DASH CONTROL WHEEL VALUES
		  // SPEED OF CONTROL IN MS - LOWER VALUE IS FASTER
		  ChartOpenCircle1.AnimationInterval = 20
		  ChartOpenCircle1.PercentValue = 100.9
		  ChartOpenCircle1.Animate
		  
		  HTMLViewer1.Visible = False
		  HTMLViewer1.Enabled = False
		  
		  // BUILD AUTHORIZATION URL BASED ON PARAMETERS PASSED INTO COMMON_MODULE PROPERTIES
		  Dim DropBox_Authorization_Base_URL as String = "https://www.dropbox.com/1/oauth2/authorize?"
		  Dim ClientID as String = "&client_id="+Common_Module.Dropbox_Client_ID
		  Dim ResponseType as String = "&response_type=code"
		  Dim RedirectURI as String = "&redirect_uri="+Dropbox_Redirect_URI
		  
		  Dim Dropbox_Auth_URL as String = DropBox_Authorization_Base_URL + ClientID + ResponseType + RedirectURI
		  HTMLViewer1.LoadURL(Dropbox_Auth_URL)
		  //google RedirectURI doesn't work anymore, use https://www.facebook.com instead
		  //"https://www.dropbox.com/1/oauth2/authorize?client_id=1l8g9qrlnuxynio&response_type=code&redirect_uri=https://www.google.com")
		  
		  
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  // FORCE WHITE BACKGROUND
		  g.ForeColor = &cFFFFFF
		  g.FillRect(0,0,me.Width,me.Height)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub ParseCode(PageContent as String)
		  Try
		    Self.ChartOpenCircle1.Visible = False
		    Self.ChartOpenCircle1.Enabled = False
		  Catch
		  End Try
		  // PARSE CODE
		  Dim Parse_AccessCode_RegEx as RegEx
		  Dim Parse_AccessCode_RegExMatch as RegExMatch
		  Dim Parse_AccessCode_HitText as String
		  Parse_AccessCode_RegEx = New RegEx
		  Parse_AccessCode_RegEx.Options.CaseSensitive = False
		  Parse_AccessCode_RegEx.Options.Greedy = True
		  Parse_AccessCode_RegEx.Options.StringBeginIsLineBegin = True
		  Parse_AccessCode_RegEx.Options.StringEndIsLineEnd = True
		  Parse_AccessCode_RegEx.Options.MatchEmpty = True
		  Parse_AccessCode_RegEx.Options.TreatTargetAsOneLine = False
		  Parse_AccessCode_RegEx.SearchPattern = "(?<=\?code=).+"
		  
		  Parse_AccessCode_RegExMatch = Parse_AccessCode_RegEx.Search(PageContent)
		  if Parse_AccessCode_RegExMatch <> nil then
		    Parse_AccessCode_HitText = Trim(Parse_AccessCode_RegExMatch.SubExpressionString(0))
		    Common_Module.DropboxOAUTHSocket.Dropbox_Access_Code = Parse_AccessCode_HitText
		  end if
		  
		  HTMLViewer1.Enabled = True
		  HTMLViewer1.Visible = True
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CancelLoadURL As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Results As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private siteCounter As Integer
	#tag EndProperty


#tag EndWindowCode

#tag Events HTMLViewer1
	#tag Event
		Sub DocumentComplete(URL as String)
		  //// PARSE ACCESS CODE INFO FROM REDIRECT URL
		  if siteCounter >= 1 Then
		    ParseCode(URL)
		  end if
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub Open()
		  if me.IsAvailable then
		    dim agent as string = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_8; en-us) AppleWebKit/533.16 (KHTML, like Gecko) Version/5.0 Safari/533.16"
		    me.UserAgent = agent
		  end if
		End Sub
	#tag EndEvent
	#tag Event
		Sub TitleChanged(newTitle as String)
		  // WORK AROUND DUE TO HTMLVIEWER NOT ABLE TO RETURN THE CORRECT REDIRECTED URL
		  // IT WILL HOWEVER RETURN THE CORRECT REDIRECTED URL BUT ONLY AFTER THE FOLLOWING JS PAGE RELOAD
		  // THEN THE DOCUMENTCOMPLETE EVENT'S URL SEES THE CORRECT REDIRECT URL
		  Static mTitle as String 
  
  		if siteCounter >=1  and mTitle <> newTitle Then
    
    		Me.ExecuteJavaScript("location.reload();")
    		//THIS IS A WORKAROUND TO LOAD THE CONFIRMATION PAGE WHEN YOU ACCESS THE FIRST TIME
    		//WITH YOUR DROPBOX APP. USE FACEBOOK.COM IS MANDATORY IN THIS CASE BECAUSE IS OUR 
    		//CALLBACK URL
    		if instr(0,newTitle,"Facebook") > 0  then
      			Me.ExecuteJavaScript("location.reload();")
      			AuthCompleteCanvas.Visible = True
    		end if
    
 		Else
    		siteCounter = siteCounter + 1
  		end if
  
  
  
  mTitle = newTitle
		  
		  
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events AuthCompleteCanvas
	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  #IF TargetMacOS Then
		    Declare Sub CGContextSaveGState Lib "Cocoa" ( context As Integer )
		    Declare Sub CGContextSetInterpolationQuality Lib "Cocoa" ( context As Integer, quality As Integer )
		    Declare Sub CGContextRestoreGState Lib "Cocoa" ( context As Integer )
		    Dim CGContextRef As Integer = g.handle( g.HandleTypeCGContextRef )
		    CGContextSaveGState CGContextRef
		    CGContextSetInterpolationQuality CGContextRef, 3
		  #ENDIF
		  
		  
		  // FILL WITH A WHITE BACKGROUND
		  g.ForeColor = &cFFFFFF
		  g.FillRect(0,0,me.Width,me.Height)
		  
		  // SET DRAWSTRING CHARACTERISTICS
		  g.ForeColor = &c0280E4
		  g.TextFont = "system"
		  g.TextSize = 18
		  
		  // WRITE THE FIRST LINE CONFIRMING TO THE USER THAT WE HAVE BEEN SUCCESSFUL
		  Dim ourAppName as String = Common_Module.Dropbox_AppName
		  Dim theString as String = "Dropbox link with the " + ourAppName + " successful."
		  Dim theStringWidth as Double = g.StringWidth(theString)
		  Dim theStringHeight as Integer = g.StringHeight(theString, 500)
		  Dim theString_xPos as Integer = (me.Width/2)-(theStringWidth/2)
		  Dim theString_yPos as Integer =  (Me.Height/2)-(theStringHeight/2)
		  g.DrawString(theString, theString_xPos, theString_yPos)
		  
		  // WRITE THE SECOND LINE CONFIRMING TO THE USER THAT WE HAVE BEEN SUCCESSFUL
		  Dim theString2 as String = "Please close this window to continue."
		  Dim theStringWidth2 as Double = g.StringWidth(theString2)
		  Dim theStringHeight2 as Integer = g.StringHeight(theString2, 500)
		  Dim theString2_xPos as Integer = (me.Width/2)-(theStringWidth2/2)
		  Dim theString2_yPos as Integer =  ((Me.Height/2)-(theStringHeight2/2)) + theStringHeight+6
		  g.DrawString(theString2, theString2_xPos, theString2_yPos)
		  
		  // DRAW YOUR APP LOGO - COMMENT IF YOU DON'T WANT TO USE
		  Dim myLogo as Picture = AristaSquared72x72
		  Dim myLogo_xPos as Integer = (me.Width/2)-(myLogo.Width/2)
		  Dim myLogo_yPos as Integer = 25
		  g.DrawPicture(myLogo,myLogo_xPos,myLogo_yPos, myLogo.Width,myLogo.Height)
		  
		  #IF TargetMacOS Then
		    CGContextRestoreGState CGContextRef
		  #ENDIF
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="BackColor"
		Visible=true
		Group="Appearance"
		InitialValue="&hFFFFFF"
		Type="Color"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Appearance"
		Type="Picture"
		EditorType="Picture"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CancelLoadURL"
		Group="Behavior"
		Type="string"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="CloseButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Frame"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"10 - Drawer Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreenButton"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackColor"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Position"
		InitialValue="400"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="LiveResize"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=true
		Group="Appearance"
		InitialValue="0"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxHeight"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaxWidth"
		Visible=true
		Group="Position"
		InitialValue="32000"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Appearance"
		Type="MenuBar"
		EditorType="MenuBar"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinHeight"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimizeButton"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinWidth"
		Visible=true
		Group="Position"
		InitialValue="64"
		Type="Integer"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Placement"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		Type="String"
		EditorType="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Appearance"
		InitialValue="Untitled"
		Type="String"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType="Boolean"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Position"
		InitialValue="600"
		Type="Integer"
	#tag EndViewProperty
#tag EndViewBehavior
