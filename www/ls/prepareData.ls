class President
  (@name, @color) ->
    r = parseInt (@color.substr 1, 2), 16
    g = parseInt (@color.substr 3, 2), 16
    b = parseInt (@color.substr 5, 2), 16
    gs = Math.round (r + g + b) / 3
    @gsColor = "rgb(#gs,#gs,#gs)"
presidents =
  Gottwald: new President "Klement Gottwald", '#67000d'
  Zapotocky: new President "Antonín Zápotocký", '#ef3b2c'
  Novotny: new President "Antonín Novotný", '#fcbba1'
  Svoboda: new President "Ludvík Svoboda", '#a50f15'
  Husak: new President "Gustáv Husák", '#fb6a4a'
  Havel: new President "Václav Havel", '#4daf4a'
  Klaus: new President "Václav Klaus", '#377eb8'
  Zeman: new President "Miloš Zeman", '#f781bf'
  Uhde: new President "Milan Uhde", '#984ea3'

ig.getData = ->
  rs = String.fromCharCode 30
  us = String.fromCharCode 31

  projevy = ig.data.projevy.split rs
  projevy.map (raw) ->
    [source, text] = raw.split us
    [year, presId] = source.split "-"
    president = presidents[presId]
    year = parseInt year, 10
    paragraphs = text.split "\r\n\r\n"
    {text, paragraphs, president, presId, year}
