Sub Main
	Call DirectExtraction()	'AFAS-Database.IMD
	Call ExportDatabaseXLSX()	'Memoriaalboekingen.IMD
End Sub


' Gegevens: Directe Selectie
Function DirectExtraction
	Set db = Client.OpenDatabase("AFAS-Database.IMD")
	Set task = db.Extraction
	task.IncludeAllFields
	dbName = "Memoriaalboekingen.IMD"
	task.AddExtraction dbName, "", "JRNTP == ""M"""
	task.CreateVirtualDatabase = False
	task.PerformTask 1, db.Count
	Set task = Nothing
	Set db = Nothing
	Client.OpenDatabase (dbName)
End Function

' Bestand - Database Exporteren: XLSX
Function ExportDatabaseXLSX
	Set db = Client.OpenDatabase("Memoriaalboekingen.IMD")
	Set task = db.ExportDatabase
	task.IncludeAllFields
	eqn = ""
	task.PerformTask "C:\Users\ralar\Documents\Klanten\Analysio\Exports.ILB\Memoriaalboekingen.XLSX", "Database", "XLSX", 1, db.Count, eqn
	Set db = Nothing
	Set task = Nothing
End Function