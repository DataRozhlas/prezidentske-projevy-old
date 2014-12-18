init = ->
  data = ig.getData!
  body = d3.select \body
    ..insert \div, '#wrapper'
      ..attr \id \bg-row
  container = d3.select '#wrapper-inner'
  new ig.ProjevSelector container, data
  projev = container.append \div
    .attr \class \projev
  projev.html '<h1>1956: Antonín Zápotocký</h1>
    <h2>&bdquo;V zahajované druhé pětiletce stále kupředu – zpátky ni krok!&ldquo;</h2>'
  content = container.append \div
    ..attr \class \projev-content
  (err, data) <~ d3.text "../data/1956-Zapotocky.txt"
  paragraphs = data.split "\n\r"
  content.selectAll \p .data paragraphs .enter!append \p
    ..html -> it
if d3?
  init!
else
  $ window .bind \load ->
    if d3?
      init!
