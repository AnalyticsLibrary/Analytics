Begin Dialog Menu1 50,50,150,150,"Menu", .NieuwDialoogvenster
  OKButton 14,117,40,14, "OK", .OKButton1
  CancelButton 93,116,40,14, "Cancel", .CancelButton1
  Text 13,10,98,13, "Enter XAF Prefix", .Text1
  TextBox 12,30,103,14, .TextBox1
  OptionGroup .OptionButtonGroup1
  OptionButton 18,80,40,14, "English", .OptionButton1
  OptionButton 18,92,40,14, "Dutch", .OptionButton2
  GroupBox 14,68,116,39, "Language table names", .GroupBox1
End Dialog

Option explicit

	Dim dlg As Menu1
	Dim button As Integer
	Dim radioButton As Integer
	Dim result As Long
	Dim prefix As String
	Dim exitdialog As Boolean
	Dim db As Object
	Dim task As task
	Dim dbname As String
	Dim field As String
	Dim eqn As String
	Dim projectmanagement As String
	
Sub main

Call Menu() 	

End Sub

Function Menu()

	
Do 'Start Loop
	

	Result = Dialog(dlg)
	
	If result = 0 Then
	Exit Sub
	End If
		

Set prefix = dlg.Textbox1

If prefix = "" Then
MsgBox "Please enter prefix"
Else
MsgBox "prefix is " &prefix

Dim choice As Integer
Choice = dlg.OptionButtonGroup1

'display the selection
Select Case choice
	Case 0						'Case 0 = English database names"
		MsgBox "Preparing " & prefix &" English"
	Client.closeall	
	Call JoinDatabaseENG()	'Transactions.IMD
	Call JoinDatabase1ENG()	'Comb GL.IMD
	Call Saldo
	Call TRPer
	Call Acctnm
	Call ExportDatabaseXLSX ()	'Database
	
	exitdialog = TRUE
		
	Case 1						'Case 1 = Dutch database names. Same as English, but first calls Rename database where all database names are translated to English"
		MsgBox "Preparing " & prefix &" Dutch"

	Client.closeall
	Call RenameDatabase		
	Call JoinDatabaseENG()	'Transactions.IMD
	Call JoinDatabase1ENG()	'Comb GL.IMD
	Call Saldo
	Call Acctnm
	Call ExportDatabaseXLSX ()	'Database		
	
	exitdialog = TRUE	
				
End Select
End If 

Loop Until exitdialog = TRUE	'ends loop when exitdialog = true

End Function
	
			


' File: Combine Transactions with GL Schedule
Function JoinDatabaseENG
	Set db = Client.OpenDatabase("Exact-Transactions.IMD")
	Set task = db.JoinDatabase
	task.FileToJoin "Exact-General Ledger.IMD"
	task.AddPFieldToInc "JRNID"
	task.AddPFieldToInc "DESC"
	task.AddPFieldToInc "JRNTP"
	task.AddPFieldToInc "OFFSETACCID"
	task.AddPFieldToInc "NR"
	task.AddPFieldToInc "PERIODNUMBER"
	task.AddPFieldToInc "TRDT"
	task.AddPFieldToInc "SOURCEID"
	task.AddPFieldToInc "NR1"
	task.AddPFieldToInc "ACCID"
	task.AddPFieldToInc "DOCREF"
	task.AddPFieldToInc "EFFDATE"
	task.AddPFieldToInc "AMNT"
	task.AddPFieldToInc "AMNTTP"
	task.AddPFieldToInc "DESC1"
	task.AddPFieldToInc "CUSTSUPID"
	task.AddPFieldToInc "VATID"
	task.AddPFieldToInc "VATPERC"
	task.AddPFieldToInc "VATAMNT"
	task.AddPFieldToInc "VATAMNTTP"
	task.AddPFieldToInc "INVREF"
	task.AddPFieldToInc "QNTITY"
	task.AddPFieldToInc "DESC2"
	task.AddPFieldToInc "BANKACCNR"
	task.AddPFieldToInc "SBTYPE"
	task.AddPFieldToInc "SBDESC"
	task.AddPFieldToInc "NR2"
	task.AddPFieldToInc "JRNID1"
	task.AddPFieldToInc "TRNR"
	task.AddPFieldToInc "TRLINENR"
	task.AddPFieldToInc "DESC3"
	task.AddPFieldToInc "AMNT1"
	task.AddPFieldToInc "AMNTTP1"
	task.AddPFieldToInc "DOCREF1"
	task.AddPFieldToInc "CUSTSUPID1"
	task.AddPFieldToInc "INVREF1"
	task.AddPFieldToInc "INVPURSALTP"
	task.AddPFieldToInc "INVTP"
	task.AddPFieldToInc "INVDT"
	task.AddPFieldToInc "MUTTP"
	task.AddPFieldToInc "INVDUEDT"
	task.AddSFieldToInc "ACCDESC"
	task.AddSFieldToInc "ACCTP"
	task.AddSFieldToInc "LEADCODE"
	task.AddSFieldToInc "LEADDESCRIPTION"
	task.AddSFieldToInc "LEADREFERENCE"
	task.AddMatchKey "ACCID", "ACCID", "A"
	task.Criteria = "EFFDATE <> ""00000000"""
	task.CreateVirtualDatabase = False
	dbName = prefix & "-Comb GL.IMD"
	task.PerformTask dbName, "", WI_JOIN_ALL_IN_PRIM
	Set task = Nothing
	Set db = Nothing
	Client.OpenDatabase (dbName)
End Function


' File: Combine with Customers-Suppliers (only essential data that is in most tables)
Function JoinDatabase1ENG
	Set db = Client.OpenDatabase(prefix & "-Comb GL.IMD")
	Set task = db.JoinDatabase
	task.FileToJoin prefix &"-Customers Suppliers.IMD"
	task.IncludeAllPFields
	task.IncludeAllPFields
	task.IncludeAllSFields
	task.AddMatchKey "CUSTSUPID", "CUSTSUPID", "A"
	task.CreateVirtualDatabase = False
	dbName = prefix & "-Database.IMD"
	task.PerformTask dbName, "", WI_JOIN_ALL_IN_PRIM
	Set task = Nothing
	Set db = Nothing
	Client.OpenDatabase (dbName)
End Function

Function Saldo	'Add an entry balance to the database

	Set db = Client.OpenDatabase(prefix &"-Database.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "SALDO"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(AMNTTP=""D"";AMNT;-AMNT)"
	field.Decimals = 2
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
Client.refreshfileexplorer

End Function

Function Acctnm	'Add account name to database

	Set db = Client.OpenDatabase(prefix &"-Database.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "ACCTNM"
	field.Description = ""
	field.Type = WI_CHAR_FIELD
	field.Equation = "ACCID+"" - ""+ ACCDESC"
	field.Length = 100
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
Client.refreshfileexplorer
End Function



' Export database to XLS

Function ExportDatabaseXLSX
	Set db = Client.OpenDatabase(prefix & "-Database.IMD")
	Set task = db.ExportDatabase
	task.IncludeAllFields
	eqn = ""
	task.PerformTask client.workingdirectory & "Exports.ILB\" & prefix &"-Database.XLSX", "Database", "XLSX", 1, db.Count, eqn
	Set db = Nothing
	Set task = Nothing

MsgBox "Database exported to"&client.workingdirectory & "Exports.ILB"

End Function

Function RenameDatabase
	Set ProjectManagement = client.ProjectManagement
	ProjectManagement.RenameDatabase prefix & "-Grootboek.IMD", prefix & "-General Ledger"
	ProjectManagement.RenameDatabase prefix & "-Klanten Leveranciers.IMD", prefix & "-Customers Suppliers"
	ProjectManagement.RenameDatabase prefix & "-Transacties.IMD", prefix & "-Transactions"


	Set ProjectManagement = Nothing
End Function

Function TRPer
	Set db = Client.OpenDatabase(prefix &"-Database.IMD")
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "TRPER"
	field.Description = ""
	field.Type = WI_VIRT_NUM
	field.Equation = "@Month(TRDT)"
	field.Decimals = 0
	task.AppendField field
	task.PerformTask
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
End Function


