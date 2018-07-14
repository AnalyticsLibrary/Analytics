Begin Dialog Menu1 49,10,152,145,"GL-Journal Matrix", .DisplayIt
  OKButton 10,112,40,15, "OK", .OKButton1
  CancelButton 96,112,40,15, "Cancel", .CancelButton1
  PushButton 10,15,28,14, "File", .PushButton1
  Text 42,15,89,14, "Text", .txtFilename
  Text 10,41,123,47, "This script adds a GL-Journal matrix as a pivot table result. Select the ""...""-database file and press OK. ", .Text1
End Dialog
Option Explicit

	Dim button As Integer	
	Dim result As Long
	Dim map As String	
	Dim field As Object
	Dim radioButton As Integer
	Dim filename As String
	Dim working_directory As String
	Dim Qtr As String
	Dim db As Object
	Dim task As task
	Dim currentdb As String	
	Dim dbname As String
	Dim exitdialog As Boolean
			
Sub main
	working_directory = Client.WorkingDirectory
	Call Menu() 'Starts the dialog

End Sub

Function Menu()

	Dim dlg As Menu1 'Menu1 = Menu name
	Dim filebar As Object 'object for file explorer
	Dim exitDialog As Boolean 'flag to indicate to exit dialog
	Dim source As Object 'object to hold database
	Dim table As Object
		
		
	Do
		button = Dialog(dlg) 'display the dialog and return the button selected

		Select Case button
			Case -1 		'OK Button

				exitdialog = TRUE
			Call DBGB

				
			Case 0		'Cancel Button
			
				exitdialog = TRUE
			Case 1		'File select
				Set filebar = CreateObject("ideaex.fileexplorer")
				filebar.displaydialog
				filename = filebar.selectedfile
'				MsgBox filename
				
		End Select
						
	Loop Until exitdialog = TRUE	'End every script with "exitdialog = TRUE"

			
						
End Function
	
Function DisplayIt(ControlID$, Action%, SuppValue%)
	
	If filename = "" Then
		DlgText "txtFilename", "No file selected"
	Else
		DlgText "txtFilename", "File: " & getFileName(filename, 0)
		Set currentdb = getFileName(filename, 0)
	End If
End Function

Function DBGB	'Create pivot GL / journal matrix

	Set db = Client.OpenDatabase(filename)
	Set task = db.PivotTable
	task.ResultName = "DB-GB1"
	task.AddRowField "ACCTNM"
	task.AddColumnField "DESC"
	task.AddDataField "SALDO", "Som: SALDO", 1
	task.ExportToIDEA False
	task.PerformTask
	Set task = Nothing
	Set db = Nothing

End Function



Function getFileName(temp_filename As String, temp_type As Boolean) '1 if get the name with any folder info, 0 if only the name
	Dim temp_length As Integer
	Dim temp_len_wd As Integer
	Dim temp_difference As Integer
	Dim temp_char As String
	Dim tempfilename As String
	
	If temp_type Then
		temp_len_wd  = Len(working_directory )  + 1'get the lenght of the working directory
		temp_length = Len(temp_filename) 'get the lenght of the file along with the working directory
		temp_difference = temp_length - temp_len_wd  + 1'get the lenght of just the filename
		getFileName = Mid(temp_filename, temp_len_wd, temp_difference)	
	Else
		temp_length  = Len(temp_filename )
		Do 
			temp_char = Mid(temp_filename, temp_length , 1)
			temp_length = temp_length  - 1 
			If temp_char <> "\" Then
				tempfilename = temp_char & tempfilename
			End If
		Loop Until temp_char = "\" Or temp_length = 0
		getFileName = tempfilename
	End If
End Function

