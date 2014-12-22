predlozky = <[bez beze blízko během cestou coby dle do dík díky k ke kol kolem krom kromě ku kvůli mezi mimo místo na nad nade naproti navzdory o ob od ode ohledně okolo oproti po poblíž pod pode podle podlevá podlivá podél pomocí pro prostřednictvím proti před přede přes přese při s skrz skrze stran u u uprostřed v ve vedle vinou vně vstříc vz včetně vůkol vůči z za ze zkraje zpod a v i]>

class President
  (@name, @color, @id) ->
    r = parseInt (@color.substr 1, 2), 16
    g = parseInt (@color.substr 3, 2), 16
    b = parseInt (@color.substr 5, 2), 16
    gs = Math.round (r + g + b) / 3
    @gsColor = "rgb(#gs,#gs,#gs)"
presidents =
  Gottwald: new President "Klement Gottwald", '#67000d', \gottwald
  Zapotocky: new President "Antonín Zápotocký", '#ef3b2c', \zapotocky
  Novotny: new President "Antonín Novotný", '#fcbba1', \novotny
  Svoboda: new President "Ludvík Svoboda", '#a50f15', \svoboda
  Husak: new President "Gustáv Husák", '#fb6a4a', \husak
  Havel: new President "Václav Havel", '#4daf4a', \havel
  Klaus: new President "Václav Klaus", '#377eb8', \klaus
  Zeman: new President "Miloš Zeman", '#f781bf', \zeman
  Uhde: new President "Milan Uhde", '#984ea3', \uhde

ig.getData = ->
  rs = String.fromCharCode 30
  us = String.fromCharCode 31

  projevy = ig.data.projevy.split rs
  projevy.map (raw) ->
    [source, text] = raw.split us
    [year, presId] = source.split "-"
    president = presidents[presId]
    year = parseInt year, 10
    text = improveTypography text
    [title, ...paragraphs] = text.split /(\n\n)|(\n\r\n\r)|(\r\n\r\n)/
      .filter -> it and it.0 not in ["\n" "\r"]
    {text, title, paragraphs, president, presId, year}

improveTypography = (text) ->
  nbsp = String.fromCharCode 160
  console.log "(\\s(#{predlozky.join '|'})) "
  predlozkyRegex = new RegExp "(\\s(#{predlozky.join '|'})) " "g"
  text
    .replace predlozkyRegex, '$1' + nbsp
    # .replace /([\.\s])"/g "$1„"
    # .replace /"([\.\s])/g "$1“"
    .replace /(\s)-(\s)/g "#{nbsp}–#{nbsp}"
    .replace /(\s)--(\s)/g "#{nbsp}—#{nbsp}"
