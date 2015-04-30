Local $AmIConnected
TestConnection()

RunWait("D:\sync.bat")
FileChangeDir("D:\oh\open_holdem\table_maps\")
FileCopy ( "D:\oh\open_holdem\table_maps\*", "D:\oh\scraper\" , 1)

FileCopy ( "D:\oh\open_holdem\autoit\*", "D:\" , 1)