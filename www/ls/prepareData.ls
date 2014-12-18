class President
  (@name, @color) ->
presidents =
  Gottwald: new President "Klement Gottwald", '#67000d'
  Zapotocky: new President "Antonín Zápotocký", '#a50f15'
  Novotny: new President "Antonín Novotný", '#cb181d'
  Svoboda: new President "Ludvík Svoboda", '#ef3b2c'
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
    {text, president, year}
