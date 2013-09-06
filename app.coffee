express       = require('express')
fs            = require('fs')
mysql         = require('mysql')
_         = require('underscore')
program = require('commander')
Handlebars = require('handlebars')
deferred = require('deferred')

connectionOptions =
    user: 'root'
    database: 'blog'
    password: ''
    #host: program.host  
pool = mysql.createPool(connectionOptions)  

# console.log paramize({name: 'tag%', id: 12}, 'SELECT * FROM tag WHERE id = :id AND name LIKE :name')

###console.time('query')
new BaseEntity().query("SELECT * FROM tag WHERE id = :id AND name LIKE :name", {name: 'tag%', id: 1}).done (rs) ->
  console.log rs
  console.timeEnd('query')
  process.exit()###  
###console.time('query')
new Tag({name: 'My Tag fff', id:3}).update().done (rs)->
  console.log(rs)
  console.timeEnd('query')
  process.exit()###


# When a file is run directly from Node, require.main is set to its module.
if require.main == module
  #syntax: --host  --username --password
  program
    .option('-h, --host <host>', 'hostname', String, 'http://localhost:3306')
    .option('-u, --username <username>', 'username', String, 'root')
    .option('-p, --password <password>', 'password', String, '')
    .option('-d, --database <database>', 'db')
    .parse(process.argv)

  tableInDb = "Tables_in_#{program.database}"

  connectionOptions =
    user: program.username
    database: program.database
    password: program.password
    #host: program.host
  console.log connectionOptions
  con = mysql.createConnection(connectionOptions)
  
  con.query('SHOW TABLES', (err, tables) ->
    _.forEach(tables, (each) ->      
      tableName = each[tableInDb]
      con.query('SHOW COLUMNS FROM ' + tableName, (err, columns)->
        console.log(columns)
      )
    )    
  )

###class Tag extends BaseEntity
  Tag::_tableName = 'tag'###