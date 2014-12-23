require! {
  fs
  async
}
years_ass = {}
presidents =
  "Husáka": "husak"
  "Novotného": "novotny"
  "Zápotockého": "zapotocky"
  "Gottwalda": "gottwald"
  "Svobody": "svoboda"
  "Havla": "havel"
  "Klause": "klaus"
  "Beneše": "benes"
  "Háchy": "hacha"
  "Masaryka": "masaryk"
  "Zemana": "zeman"
(err, files) <~ fs.readdir "#__dirname/../audio/unsorted/"
<~ async.eachLimit files, 5, (file, cb) ->

  [year] = file.match /[0-9]{4}/
  year = parseInt year
  if -1 != file.indexOf ".12."
    year++
  name = null
  for inFile, presName of presidents
    if -1 != file.indexOf inFile
      name = presName
      break

  # console.log year, file
  years_ass[year] ?= []
  years_ass[year].push file
  # <~ fs.rename do
  #   "#__dirname/../audio/unsorted/#file"
  #   "#__dirname/../audio/unsorted/#year-#name"
  <~ fs.rename do
    "#__dirname/../audio/unsorted/#file"
    "#__dirname/../audio/uuu/#{file[0].toUpperCase!}#{file.substr 1}"
  cb!



# for year, y of years_ass
#   if y.length > 1
#     console.log y
