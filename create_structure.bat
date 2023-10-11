@echo off
color 0E
echo ^+-------------------------------------------------^+
echo ^|------ AUTO CREATE PROJECT STRUCTURE TSK ------- ^|
echo ^|--------------- Make by NTD -------------------- ^|
echo ^|                                                 ^|
echo ^|                                                 ^|
echo ^|     " _____             ____        _          "^|
echo ^|     "|_   _|_ _ _ __   |  _ \  __ _| |_        "^|
echo ^|     "  | |/ _` | '_ \  | | | |/ _` | __|       "^|
echo ^|     "  | | (_| | | | | | |_| | (_| | |_        "^|
echo ^|     "  |_|\__,_|_| |_| |____/ \__,_|\__|       "^|
echo ^|                                                 ^|
echo ^|                                                 ^|
echo ^| Current Path :                                  ^|
echo ^| C:\Users\tandat\Desktop\TSK_cmd                 ^|
echo ^|                                                 ^|
echo ^+-------------------------------------------------^+
echo.

:checkfolder
set /p userInput=Please enter your project name you need create structure: 
echo.

REM Set the local directory where you want to clone the repository
set localDirectory=C:\Users\tandat\Desktop\TSK

REM Combine the local directory with user input to create a full path
set fullPath=%localDirectory%\%userInput%
echo "%fullPath%"

echo Create Stucture project ( Controller Folder , DAL Folder , Model Folder , Interface File , View Folder)
rem Search for the folder
for /d /r "%fullPath%" %%d in (*) do (
    if "%%~nd"=="%userInput%" (
        set folderPath="%%d"
    )
)

if exist %folderPath%\Class1.cs (
	del %folderPath%\Class1.cs
)

if not exist "%folderPath%\Controller\" (
	mkdir %folderPath%\Controller\
)
if not exist "%folderPath%\DAL\" (
	mkdir %folderPath%\DAL
)
if not exist "%folderPath%\Model" (
	mkdir %folderPath%\Model
)
if not exist "%folderPath%\View\" (
	mkdir %folderPath%\View\
)

rem Generate the Interface.cs file content
(
    echo using %userInput%.Model;
    echo namespace %userInput%
    echo {
    echo     public interface I%userInput%
    echo     {
    echo         void SetController^(^%userInput%Controller controller^)^;
    echo         void BindingToGrid^(^List^<%userInput%GridModel^>? lst^)^;
    echo     }
    echo }
) > %folderPath%\View\I%userInput%.cs
echo Created Interface

rem Generate the Controller.cs file content
(
    echo using %userInput%.Model;
    echo.
    echo namespace %userInput%
    echo {
    echo     public class %userInput%Controller
    echo     {
    echo         %userInput%DAL _dal = new^(^);
    echo.
    echo         I%userInput% _view;
    echo.
    echo         public %userInput%Controller^(I%userInput% view^)
    echo         {
    echo             this._view = view;
    echo.
    echo             view.SetController^(this^);
    echo         }
    echo.
    echo         public String SearchStringByCode^(string code, string typeNum^)
    echo         {
    echo             return _dal.SearchStringByCode^(code, typeNum^);
    echo         }
    echo.
    echo         public void SearchDataDetail^(%userInput%SearchModel searchCondition^)
    echo         {
    echo             List^<%userInput%GridModel^>? data = _dal.SearchData^(searchCondition^);
    echo             this._view.BindingToGrid^(data^);
    echo         }
    echo     }
    echo }
) > %folderPath%\Controller\%userInput%Controller.cs
echo Created Controller 

rem Generate the Controller.cs file content
(
    echo using CommonDataType;
    echo using CommonMethod;
    echo using MySql.Data.MySqlClient;
    echo using %userInput%.Model;
    echo using System.Data;
    echo using System.Text;
    echo.
    echo namespace %userInput%
    echo {
    echo     public class %userInput%DAL
    echo     {
    echo         DBHelper? _conn;
    echo.
    echo         private String _xmlFile = "%userInput%_Query.xml";
    echo.
    echo         ^private int _rowMaxLenght = 10000^;
    echo.
    echo         public String SearchStringByCode^(string code, string sqlTypeNumber^)
    echo         {
    echo             _conn = new DBHelper^(^);
    echo             try
    echo             {
    echo                 _conn.Open^(^);
    echo                 DataSet dataSet = new^(^);
    echo                 StringBuilder stringBuilder = new^(^);
    echo                 string unit = string.Empty;
    echo.
    echo                 // get Path File XML
    echo                 string? pathXMLFile = CommonDirectory.CommonDirectory.GetPathFile^(_xmlFile^);
    echo.
    echo                 if ^(pathXMLFile != null ^&^& !string.IsNullOrEmpty^(code^)^)
    echo                 {
    echo                     string? querySql = _conn.GetQueryFromXMLFile^(pathXMLFile, "%userInput%S_00" + sqlTypeNumber^);
    echo.
    echo                     if ^(string.IsNullOrEmpty^(querySql^)^) return string.Empty;
    echo.
    echo                     string sql = string.Format^(querySql, code^);
    echo.
    echo                     var reader = _conn.ExecuteReaderSingle^(sql^);
    echo.
    echo                     if ^(reader != null^)
    echo                     {
    echo                         while ^(reader.Read^(^)^)
    echo                         {
    echo                             if ^(!reader.IsDBNull(0^)^)
    echo                             {
    echo                                 unit = reader.GetString^(0^);
    echo                             }
    echo                             else
    echo                             {
    echo                                 break;
    echo                             }
    echo                         }
    echo                     }
    echo                 }
    echo.
    echo                 return unit;
    echo             }
    echo             catch ^(Exception ex^)
    echo             {
    echo                 MessageBox.Show^(ex.Message^);
    echo                 WriteLog.Log^(ex^);
    echo                 return "";
    echo             }
    echo             finally
    echo             {
    echo                 _conn.Close^(^);
    echo             }
    echo         }
    echo.
    echo         /// ^<summary^>
    echo         /// データの検索
    echo         /// ^</summary^>
    echo         /// ^<param name="searchCondition"^>^</param^>
    echo         public List^<%userInput%GridModel^>? SearchData^(%userInput%SearchModel searchCondition^)
    echo         {
    echo             _conn = new^(^);
    echo             string? pathXMLFile = CommonDirectory.CommonDirectory.GetPathFile^(_xmlFile^);
    echo.
    echo             if ^(pathXMLFile == null^) return null;
    echo             try
    echo             {
    echo                 _conn.Open^(^);
    echo                 DataSet ds = new^(^);
    echo                 string? sql = string.Empty;
    echo.
    echo                 #region "Param Query"
    echo                 List^<MySqlParameter^> param = new List^<MySqlParameter^>^(^);
    echo                 #endregion
    echo.
    echo                 if ^(string.IsNullOrEmpty^(sql^)^) return null;
    echo.
    echo                 ds = _conn.ExecuteDataSet^(sql, param^);
    echo                 List^<%userInput%GridModel^> lstResult = new^(^);
    echo                 if ^(ds != null ^&^& ds.Tables.Count ^>^ _rowMaxLenght^)
    echo                 {
    echo                     string[] prms = new string[3];
    echo                     prms[0] = "10000";
    echo.
    echo                     CommonMgs.CommonMgs.ShowMsg^("CMNW_0002", "大豊資材工業(株) 基幹システム", prms^);
    echo                     return null;
    echo                 }
    echo                 else if ^(ds != null ^&^& ds.Tables.Count ^>^ 0^)
    echo                 {
    echo                     lstResult = ConvertData.ConvertToDataTable^<%userInput%GridModel^>^(ds.Tables[0]^);
    echo                 }
    echo.
    echo                 if ^(lstResult.Count == 0^)
    echo                 {
    echo                     CommonMgs.CommonMgs.ShowMsg^("CMNE_0001", "大豊資材工業(株) 基幹システム"^);
    echo                     return null;
    echo                 }
    echo.
    echo                 return lstResult;
    echo             }
    echo             catch ^(Exception ex^)
    echo             {
    echo                 Console.WriteLine^(ex.Message^);
    echo                 return null;
    echo             }
    echo             finally
    echo             {
    echo                 _conn.Close^(^);
    echo             }
    echo         }
    echo     }
    echo }
) > %folderPath%\DAL\%userInput%DAL.cs
echo Created DAL 

rem Create the file with the specified content
(
    echo using Model;
    echo.
    echo namespace %userInput%.Model
    echo {
    echo     public class %userInput%SearchModel : BaseModel
    echo     {
    echo.
    echo     }
    echo.
    echo     public class %userInput%GridModel : BaseModel
    echo     {
    echo         public %userInput%GridModel^(^) { }
    echo     }
    echo }
) > %folderPath%\Model\%userInput%Model.cs
echo Created Model

pause



