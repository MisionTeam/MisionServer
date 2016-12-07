//
//  tert_mysql.swift
//  MisionServer
//
//  Created by 罗兆峰 on 2016-12-05.
//
//

import Foundation
import MySQL


class MySQLHelper{
    
    
    
    init()
    {
        self.dataMysql=MySQL()
        
    }

    private var dataMysql :MySQL
    
    
    private struct MysqlDB{
        
        
        static let host = "127.0.0.1"
        static let user = "root"
        static let password = ""
        static let dbname = "test"
        
    }
    
    
    
    public func testDBdelete(){
        if delete(host:MysqlDB.host,user:MysqlDB.user,password:MysqlDB.password,db:MysqlDB.dbname){
            print("delete a row")
        }
    }
    
    public func testDBinsert(){
        
        if insert(username:"leo",password:"leo"){
            print("create a row")
        }
    }
    
    public func testDBRead(){
    
        query(host:MysqlDB.host,user:MysqlDB.user,password:MysqlDB.password,db:MysqlDB.dbname)
    
    }


    private func query(host:String,user:String,password:String,db:String){
   

        let connected = dataMysql.connect(host:host,user:user,password:password,db:db)
    
        guard connected else{
            print(dataMysql.errorMessage())
            return
        }
    
        let querySuccess = dataMysql.query(statement: "SELECT * FROM USERS")
    
        guard querySuccess else{
            print(dataMysql.errorMessage())
            return
        }
        
        let results=dataMysql.storeResults()!
    
        var arr=[[String:Any]]()
        
        print(results)

        results.forEachRow{ row in
            let username =  row[0]
            let password =  row[1]
            arr.append([username!:password!])
        }


        defer{
            print("connect and close the databases")
            dataMysql.close()
        }
    

    }
    
    
    
    private func insert(username:String,password:String)->Bool{
    
        let connected = dataMysql.connect(host:MysqlDB.host,user:MysqlDB.user,password:MysqlDB.password,db:MysqlDB.dbname)
        
        guard connected else{
            print(dataMysql.errorMessage())
            return false
        }
        
        
        let stmt1 = MySQLStmt(dataMysql)
        let prepRes =  stmt1.prepare(statement:"insert into USERS values(?,?)")
        
        if !prepRes{
            return prepRes
        }
        stmt1.bindParam(username)
        stmt1.bindParam(password)
        
        let execRes = stmt1.execute()
        
        return execRes
        
        defer{
            print("connect and close the databases")
            stmt1.close()
            dataMysql.close()
        }

    
    }
    
    
    private func delete(host:String,user:String,password:String,db:String)->Bool{
        
        let connected = dataMysql.connect(host:host,user:user,password:password,db:db)
        
        guard connected else{
            print(dataMysql.errorMessage())
            return false
        }
        
        let querySuccess = dataMysql.query(statement: "delete from USERS where username = \"elaine\"")
        
        guard querySuccess else{
            print(dataMysql.errorMessage())
            return false
        }
        
        defer{
            print("connect and close the databases")
            dataMysql.close()
        }
        
        return querySuccess
        
    }
    
    
    
    
    
}






