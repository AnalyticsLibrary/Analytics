Begin Dialog Menu1 49,10,152,145,"TB-Period", .DisplayIt
  OKButton 10,112,40,15, "OK", .OKButton1
  CancelButton 100,111,40,15, "Cancel", .CancelButton1
  PushButton 10,15,28,14, "File", .PushButton1
  Text 42,15,89,14, "Text", .txtFilename
  Text 11,40,126,54, "This script adds a new database containing the trial balance per period as a summarization. Select the ""...""-database file and press ""OK", .Text1
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

	'First, add extra fields. One per period, and allocate the entry's balance to that period (all entries in period 1 go in the column for period 1 etc). 		
	Call Addper0()	
	Call Addper1()	
	Call addper2()	
	Call addper3()	
	Call addper4()	
	Call addper5()	
	Call addper6()	
	Call addper7()	
	Call addper8()	
	Call addper9()	
	Call addper10()	
	Call addper11()	
	Call addper12()	

	'Add a summarization for each period, so the total entries per period are visible. . 
	Call Summarization()	

	'Add accumulated balances per period end (balance at the end of period 2 = period 0 + period 1 + period 2 and so forth)
	Call AppendField()	
	Call AppendField1()	
	Call AppendField2()	
	Call AppendField3()	
	Call AppendField4()	
	Call AppendField5()	
	Call AppendField6()	
	Call AppendField7()	
	Call AppendField8()	
	Call AppendField9()	
	Call AppendField10()	
	Call AppendField11()	
	Call AppendField12()	
	
	'Add a second summarization, but this time summarize the accumulated balances we just added. 
	Call Summarization2()	
	Client.closeall
	
	'Delete the original summarization. it is not needed anymore. 
	Call DeleteDatabase()	

	'Remove the period allocation fields we added to the original database
	Call RemoveField()	
	Call RemoveField1()	
	Call RemoveField2()	
	Call RemoveField3()	
	Call RemoveField4()	
	Call RemoveField5()	
	Call RemoveField6()	
	Call RemoveField7()	
	Call RemoveField8()	
	Call RemoveField9()	
	Call RemoveField10()	
	Call RemoveField11()	
	Call RemoveField12()	
	Call OpenTB()

	client.refreshfileexplorer


				exitdialog = TRUE


				
			Case 0		'Cancel Button
			
				exitdialog = TRUE
			Case 1		'File select
				Set filebar = CreateObject("ideaex.fileexplorer")
				filebar.displaydialog
				filename = filebar.selectedfile
'				MsgBox filename
				
		End Select
						
	Loop Until exitdialog = TRUE	'End every case with "exitdialog = TRUE"
						
End Function
	
Function DisplayIt(ControlID$, Action%, SuppValue%)
	
	If filename = "" Then
		DlgText "txtFilename", "No file selected"
	Else
		DlgText "txtFilename", "File: " & getFileName(filename, 0)
		Set currentdb = getFileName(filename, 0)
	End If
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


'add balance at period 0
Function Addper0
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER0"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER=0;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

 'add balance at period 1
Function Addper1
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER1"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 1;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

'add balance at period 2
Function Addper2
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER2"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 2;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

'add balance at period 3
Function Addper3
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER3"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 3;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' add balance at period 4
Function Addper4
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER4"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 4;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' add balance at period 5
Function Addper5
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER5"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 5;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' add balance at period 6
Function Addper6
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER6"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 6;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' add balance at period 7
Function Addper7
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER7"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 7;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' add balance at period 8
Function Addper8
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER8"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 8;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' add balance at period 9
Function Addper9
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER9"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 9;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' add balance at period 10
Function Addper10
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER10"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 10;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' add balance at period 11
Function Addper11
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER11"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 11;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' add balance at period 12
Function Addper12
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "PER12"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(PERIODNUMBER = 12;SALDO;0)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function


'Summarization all entries per period
Function Summarization
	Set db = Client.OpenDatabase(filename)
	Set task = db.Summarization
	task.AddFieldToSummarize "ACCTNM"
	task.AddFieldToTotal "PER0"
	task.AddFieldToTotal "PER1"
	task.AddFieldToTotal "PER2"
	task.AddFieldToTotal "PER3"
	task.AddFieldToTotal "PER4"
	task.AddFieldToTotal "PER5"
	task.AddFieldToTotal "PER6"
	task.AddFieldToTotal "PER7"
	task.AddFieldToTotal "PER8"
	task.AddFieldToTotal "PER9"
	task.AddFieldToTotal "PER10"
	task.AddFieldToTotal "PER11"
	task.AddFieldToTotal "PER12"
	dbName = "TBPeriod.IMD"
	task.OutputDBName = dbName
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Client.OpenDatabase (dbName)
End Function

' Add accumulated balance period 0
Function AppendField
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P0"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 1
Function AppendField1
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P01"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

'Add accumulated balance period 2
Function AppendField2
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P02"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 3
Function AppendField3
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P03"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM+PER3_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 4
Function AppendField4
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P04"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM+PER3_SOM+PER4_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 5
Function AppendField5
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P05"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM+PER3_SOM+PER4_SOM+PER5_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 6
Function AppendField6
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P06"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM+PER3_SOM+PER4_SOM+PER5_SOM+PER7_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 7
Function AppendField7
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P07"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM+PER3_SOM+PER4_SOM+PER5_SOM+PER6_SOM+PER7_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 8
Function AppendField8
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P08"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM+PER3_SOM+PER4_SOM+PER5_SOM+PER6_SOM+PER7_SOM+PER8_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 9
Function AppendField9
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P09"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM+PER3_SOM+PER4_SOM+PER5_SOM+PER6_SOM+PER7_SOM+PER8_SOM+PER9_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 10
Function AppendField10
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P10"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM+PER3_SOM+PER4_SOM+PER5_SOM+PER6_SOM+PER7_SOM+PER8_SOM+PER9_SOM+PER10_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 11
Function AppendField11
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P11"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM+PER3_SOM+PER4_SOM+PER5_SOM+PER6_SOM+PER7_SOM+PER8_SOM+PER9_SOM+PER10_SOM+PER11_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

' Add accumulated balance period 12
Function AppendField12
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "P12"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "PER0_SOM+PER1_SOM+PER2_SOM+PER3_SOM+PER4_SOM+PER5_SOM+PER6_SOM+PER7_SOM+PER8_SOM+PER9_SOM+PER10_SOM+PER11_SOM+PER12_SOM"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function

Function Summarization2
	Set db = Client.OpenDatabase("TBPeriod.IMD")
	Set task = db.Summarization
	task.AddFieldToSummarize "ACCTNM"
	task.AddFieldToTotal "P0"
	task.AddFieldToTotal "P01"
	task.AddFieldToTotal "P02"
	task.AddFieldToTotal "P03"
	task.AddFieldToTotal "P04"
	task.AddFieldToTotal "P05"
	task.AddFieldToTotal "P06"
	task.AddFieldToTotal "P07"
	task.AddFieldToTotal "P08"
	task.AddFieldToTotal "P09"
	task.AddFieldToTotal "P10"
	task.AddFieldToTotal "P11"
	task.AddFieldToTotal "P12"
	dbName = "TB per period.IMD"
	task.OutputDBName = dbName
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Client.OpenDatabase (dbName)
End Function


Function DeleteDatabase
	Client.DeleteDatabase "TBPeriod.IMD"
End Function


Function RemoveField
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER0"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField1
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER1"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField2
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER2"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField3
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER3"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField4
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER4"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField5
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER5"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField6
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER6"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField7
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER7"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function

Function RemoveField8
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER8"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField9
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER9"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField10
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER10"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField11
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER11"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function


Function RemoveField12
	Set db = Client.OpenDatabase(filename)
	Set task = db.TableManagement
	task.RemoveField "PER12"
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
End Function

Function OpenTB
	Set db = Client.OpenDatabase("TB per period.IMD")
End Function
