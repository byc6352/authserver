object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 190
  Width = 251
  object ds1: TDataSource
    DataSet = tbAuth
    Left = 183
    Top = 118
  end
  object ss1: TServerSocket
    Active = True
    Port = 8888
    ServerType = stNonBlocking
    OnClientRead = ss1ClientRead
    OnClientError = ss1ClientError
    Left = 112
    Top = 80
  end
  object conn: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Password="";Data Source=D:\work' +
      's\delphi\authserver\Win32\Debug\database\author.mdb;Persist Secu' +
      'rity Info=True'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 16
    Top = 8
  end
  object tbAuth: TADOTable
    Connection = conn
    CursorType = ctStatic
    TableName = #25480#26435#34920
    Left = 72
    Top = 8
  end
  object Q1: TADOQuery
    Connection = conn
    Parameters = <>
    Left = 144
    Top = 8
  end
end