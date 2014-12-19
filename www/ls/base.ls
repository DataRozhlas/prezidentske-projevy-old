init = ->
  currentProjevIndex = null
  data = ig.getData!
  body = d3.select \body
    ..insert \div, '#wrapper'
      ..attr \id \bg-row
  container = d3.select '#wrapper-inner'
  projevSelector = new ig.ProjevSelector container, data
  projevContainer = container.append \div
    .attr \class \projev
  leftArrow = projevContainer.append \span
    ..attr \title "Předchozí projev"
    ..attr \class "arrow left"
    ..html "‹"
    ..on \click ~>
      return if currentProjevIndex == 0
      projevSelector.setActive data[currentProjevIndex - 1]

  rightArrow = projevContainer.append \span
    ..attr \title "Další projev"
    ..attr \class "arrow right"
    ..html "›"
    ..on \click ~>
      return if currentProjevIndex == data.length - 1
      projevSelector.setActive data[currentProjevIndex + 1]
  projevHeader = projevContainer.append \div
    .attr \class \projev-header
  medailon = projevContainer.append \img
    ..attr \class \medailon
    ..attr \src "./img/zapotocky.png"

  content = projevContainer.append \div
    .attr \class \projev-content
  projevSelector.on \selected (projev) ~>
    projevContainer.classed \fading yes
    <~ setTimeout _, 300
    currentProjevIndex := data.indexOf projev
    leftArrow.classed \disabled currentProjevIndex == 0
    rightArrow.classed \disabled currentProjevIndex == data.length - 1
    projevHeader.html "<h1>#{projev.year}: #{projev.president.name}</h1>
      <h2>&bdquo;V zahajované druhé pětiletce stále kupředu – zpátky ni krok!&ldquo;</h2>"
    medailon.attr \src "./img/#{projev.president.id}.png"
    content.selectAll \p .remove!
    content.selectAll \p .data projev.paragraphs .enter!append \p
      ..html -> it
    document.body.scrollTop = 0
    projevContainer.classed \fading no

  projevSelector.setActive data.2
  new ig.ScrollWatch projevSelector, leftArrow, rightArrow
if d3?
  init!
else
  $ window .bind \load ->
    if d3?
      init!
