class ig.ProjevSelector
  (@parentElement, @projevy) ->
    @element = @parentElement.append \div
      ..attr \class \projev-selector
    years = d3.extent @projevy.map (.year)
    maxLength = d3.max @projevy.map (.text.length)
    scale = d3.scale.linear!
      ..domain years
      ..range [0 100]
    heightScale = d3.scale.linear!
      ..domain [0 maxLength]
      ..range [7 60]

    @list = @element.append \ol
      ..selectAll \li .data @projevy .enter!append \li
        ..style \left ~> "#{scale it.year}%"
        ..classed \uhde ~> it.presId == "Uhde"
        ..append \div
          ..attr \class \hover-point
          ..style \background-color ~> it.president.color
        ..append \div
          ..attr \class "point color"
          ..style \background-color ~> it.president.color
          ..style \height ~> "#{heightScale it.text.length}px"
        ..append \div
          ..attr \class "point gs"
          ..style \background-color ~> it.president.gsColor
