init = ->
  currentProjevIndex = null
  firstLoad = yes
  data = ig.getData!
  body = d3.select \body
    ..insert \div, '#wrapper'
      ..attr \id \bg-row
  container = d3.select '#wrapper-inner'
    ..html ''
  projevSelector = new ig.ProjevSelector container, data
  projevContainer = container.append \div
    .attr \class \projev

  showNextProjev = ->
    return if currentProjevIndex == data.length - 1
    projevSelector.setActive data[currentProjevIndex + 1]

  showPrevProjev = ->
    return if currentProjevIndex == 0
    projevSelector.setActive data[currentProjevIndex - 1]

  window.addEventListener \keydown ({keyCode}) ->
    switch keyCode
    | 37 => showPrevProjev!
    | 39 => showNextProjev!

  leftArrow = projevContainer.append \span
    ..attr \title "Předchozí projev"
    ..attr \class "arrow left"
    ..html "‹"
    ..on \click showPrevProjev

  rightArrow = projevContainer.append \span
    ..attr \title "Další projev"
    ..attr \class "arrow right"
    ..html "›"
    ..on \click showNextProjev
  projevHeader = projevContainer.append \div
    .attr \class \projev-header
  medailon = projevContainer.append \img
    ..attr \class \medailon
    ..attr \src "./img/zapotocky.png"

  content = projevContainer.append \div
    .attr \class \projev-content

  makeLinkFb = (projev, paragraphId) ->
    window.location + '%23' + projev.year + '-' + (paragraphId + 1)
  makeLinkTw = (projev, paragraphId) ->
    link = window.location + '%23' + projev.year + '-' + (paragraphId + 1)
    link + " " + projev.paragraphs[paragraphId]
  showProjev = (projev) ->
    currentProjevIndex := data.indexOf projev
    leftArrow.classed \disabled currentProjevIndex == 0
    rightArrow.classed \disabled currentProjevIndex == data.length - 1
    projevHeader.html "<h1>#{projev.year}: #{projev.president.name}</h1>
      <h2>&bdquo;#{projev.title}&ldquo;</h2>"
    medailon.attr \src "./img/#{projev.president.id}.png"
    content.selectAll \p .remove!
    content.selectAll \p .data projev.paragraphs .enter!append \p
      ..html -> it
      ..attr \id (d, i) ~> "para-#{i + 1}"
      ..append \a
        ..append \img
          ..attr \src 'https://samizdat.cz/tools/icons/facebook-bg.svg'
        ..attr \class "share facebook"
        ..attr \href (d, i) ~> "https://www.facebook.com/sharer/sharer.php?u=#{makeLinkFb projev, i}"
        ..attr \target \_blank
      ..append \a
        ..append \img
          ..attr \src 'https://samizdat.cz/tools/icons/twitter-bg.svg'
        ..attr \class "share twitter"
        ..attr \href (d, i) ~> "https://twitter.com/home?status=#{makeLinkTw projev, i}"
        ..attr \target \_blank

    [_, highlightedParagraph] = window.location.hash.split "-"
    highlightedParagraph = parseInt highlightedParagraph
    if highlightedParagraph
      highlightedElement = content.select "p:nth-child(#highlightedParagraph)"
        ..attr \class \highlighted
      {top} = ig.utils.offset highlightedElement.node!
      top -= window.innerHeight / 2
      top = 0 if top < 0
      document.body.scrollTop = top
    else
      document.body.scrollTop = 0
    projevContainer.classed \fading no

  projevSelector.on \selected (projev) ~>
    projevContainer.classed \fading yes
    player.setSrc "../audio/1990-Havel.mp3"
    if firstLoad
      showProjev projev
      firstLoad := no
    else
      <~ setTimeout _, 300
      if projev.year.toString! != window.location.hash.substr 1, 4
        window.location.hash = projev.year
      showProjev projev

  player = new ig.Player projevContainer

  showHash = (hash) ->
    [year, paragraph] = hash.split "-"
    year = parseInt year
    [projev] = data.filter -> it.year == year
    return unless projev
    projevSelector.setActive projev

  if window.location.hash
    showHash window.location.hash.substr 1
  else
    showHash "1990"

  new ig.ScrollWatch projevSelector, leftArrow, rightArrow, player

  window.onhashchange = -> showHash window.location.hash.substr 1
if d3?
  init!
else
  $ window .bind \load ->
    if d3?
      init!
