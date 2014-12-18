class ig.ProjevSelector
  (@parentElement, @projevy) ->
    @element = @parentElement.append \div
      ..attr \class \projev-selector
    years = d3.extent @projevy.map (.year)
    scale = d3.scale.linear!
      ..domain years
      ..range [0 100]

    @list = @element.append \ol
      ..selectAll \li .data @projevy .enter!append \li
        ..style \left ~> "#{scale it.year}%"
        ..style \top ~>
          if it.presId == "Uhde" then "0px" else "14px"
        ..append \div
          ..attr \class \point
          ..style \background-color ~> it.president.color
        ..append \div
          ..attr \class "point gs"
          ..style \background-color ~> it.president.gsColor
