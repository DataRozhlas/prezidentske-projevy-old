popisky =
  "Gottwald"
  "Zápotocký"
  "Novotný"
  "Svoboda"
  "Husák"
  "Havel"
  "Havel"
  "Klaus"
  "Zeman"
  "Delší sloupec značí delší projev"
  "Klaus, Uhde"
  "Masaryk"
  "Beneš"
class ig.ProjevSelector
  (@parentElement, @projevy) ->
    ig.Events @
    @element = @parentElement.append \div
      ..attr \class "projev-selector top"
    years = d3.extent @projevy.map (.year)
      ..0 += 4.6 # posuny
    maxLength = d3.max @projevy.map (.text.length)
    scale = d3.scale.linear!
      ..domain years
      ..range [0 100]
    heightScale = d3.scale.linear!
      ..domain [0 maxLength]
      ..range [7 60]

    @popisky = @element.append \div .attr \class \popisky
      .selectAll \div.popisek .data popisky .enter!append \div
        ..attr \class \popisek
        ..html -> it
    @list = @element.append \ol
    @listItems = @list.selectAll \li .data @projevy .enter!append \li
      ..style \left ~>
        y = it.year
        if y < 1949
          y += 3.2
        if it.year < 1938
          y += 1.2
        if it.year < 1935
          y += 0.2
        "#{scale y}%"
      ..classed \uhde ~> it.presId == "Uhde"
      ..append \div
        ..attr \class "point color"
        ..style \background-color ~> it.president.color
        ..style \height ~> "#{heightScale it.text.length}px"
      ..append \div
        ..attr \class "point gs"
        ..style \background-color ~> it.president.gsColor
        ..style \height ~> "#{heightScale it.text.length}px"
      ..append \span
        ..attr \class "item-popisek"
        ..append \span
          ..attr \class \president
          ..html ~> it.president.name.split " " .pop!
        ..append \span
          ..attr \class \year
          ..html ~> it.year
      ..on \click @~setActive

  setActive: (projev) ->
    @listItems
      .classed \active no
      .filter (d, i) -> d is projev
      .classed \active yes
    @emit \selected projev
