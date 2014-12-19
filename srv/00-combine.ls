require! {
  fs
  async
}
(err, files) <~ fs.readdir "#__dirname/../data/"
files .= filter -> it.0 in <[1 2]>
us = String.fromCharCode 31
(err, contents) <~ async.mapLimit files, 10, (filename, cb) ->
  (err, data) <~ fs.readFile "#__dirname/../data/#filename"
  data .= toString!
  header = filename.split "." .0
  data = header + us + data
  cb null data

sep = String.fromCharCode 30
fs.writeFile "#__dirname/../data/all.txt", contents.join sep
