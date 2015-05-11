
Rd2Dash = function(rddir,                           # Path of the folder with .Rd files
                   docSetdir,                       # Path of the output .docset file
                   DocName = "CustomizeDoc",        # Name of the documentation
                   CFBundleName = "CustomizeDoc",   # Name of the CFBundle
                   DocSetPlatformFamily = "R"){     # I guess it would be "R" : )

  ## preload
  require(tools)
  require(RSQLite)
  
  PackageOrFunction = function(filename){
    res = rep("Function",length(filename))
    idx.package  = grep("package", filename)
    if (length(idx.package)  > 0) res[idx.package]  = "Package"
    res
  }
  
  ## folder
  dir.create(path = paste0(docSetdir,"/",DocName,".docset/"))
  dir.create(path = paste0(docSetdir,"/",DocName,".docset/Contents"))
  dir.create(path = paste0(docSetdir,"/",DocName,".docset/Contents/Resources"))
  dir.create(path = paste0(docSetdir,"/",
                           DocName,".docset/Contents/Resources/Documents"))
  
  setwd(paste0(docSetdir,"/",DocName,".docset/"))
  
  ## rd to HTML
  Rdlist = list_files_with_exts(dir = rddir,exts = "Rd")
  Rdnames = unlist(lapply(strsplit(Rdlist,"/"),function(x) x[length(x)]))
  outlist = paste0(docSetdir,"/",DocName,".docset/Contents/Resources/Documents/",
                   Rdnames,".html")
  for(i in 1:length(Rdlist)){
    Rd2HTML(Rdlist[i], out = outlist[i], package = "")
  } 
  
  ## entry info
  info.path = paste0(list.files(paste0(docSetdir,"/",DocName,".docset//Contents//Resources//Documents")))
  info.filename = unlist(strsplit(list.files(paste0(docSetdir,"/",DocName,
                                                    ".docset//Contents//Resources//Documents"))
                                  ,split=".Rd.html"))
  info.type = PackageOrFunction(info.filename)
  
  df.info = data.frame(name = info.filename, 
                       type = info.type,
                       path = info.path,
                       stringsAsFactors = F)
  
  # plist
  plist = file("Contents/Info.plist","w")
  cat("<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n",file=plist)
  cat("  <!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" 
      \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"> \n"
      ,append=TRUE,file=plist)
  cat("  <plist version=\"1.0\"> \n",append=TRUE,file=plist)
  cat("  <dict> \n",append=TRUE,file=plist)
  cat("  \t <key>CFBundleIdentifier</key> \n",append=TRUE,file=plist)
  cat("  \t\t <string>",CFBundleName,"</string> \n",append=TRUE,file=plist,sep="")
  cat("  \t <key>CFBundleName</key> \n",append=TRUE,file=plist)
  cat("  \t\t <string>",CFBundleName,"</string> \n",append=TRUE,file=plist,sep="")
  cat("  \t <key>DocSetPlatformFamily</key> \n",append=TRUE,file=plist)
  cat("  \t\t <string>",DocSetPlatformFamily,"</string> \n",append=TRUE,file=plist,sep="")
  cat("  \t <key>isDashDocset</key> \n",append=TRUE,file=plist)
  cat("  \t\t <true/> \n",append=TRUE,file=plist)
  cat("  </dict> \n",append=TRUE,file=plist)
  cat("  </plist> \n",append=TRUE,file=plist)
  
  close(plist)
  
  ## SQLite
  
  setwd(paste0(docSetdir,"/",DocName,".docset/Contents/Resources"))
  sqlite    <- dbDriver("SQLite")  
  exampledb <- dbConnect(sqlite,"docSet.dsidx")
  dbSendQuery(exampledb,"CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT)")
  dbSendQuery(exampledb,"CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path)")
  dbListTables(exampledb)
  for (i in 1:nrow(df.info)){
    rec.info = df.info[i,]
    dbSendQuery(exampledb,paste0("INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('",
                                 rec.info[1],"', '",rec.info[2],"', '",rec.info[3],"')"))
  }
  dbGetQuery(exampledb, "select * from searchIndex")
  
  dbDisconnect(exampledb)

}
