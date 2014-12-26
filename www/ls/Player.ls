class ig.Player
  (@parentElement) ->
    self = @
    @element = @parentElement.append \div
      ..attr \class "player paused"
      ..attr \preload \auto
    @playBtn = @element.append \div
      ..attr \class "button play"
      ..html "▶"
      ..on \click @~onPlay
    @pauseBtn = @element.append \div
      ..attr \class "button pause"
      ..html "▌▌"
      ..on \click @~onPause

    @loadingBtn = @element.append \div
      ..attr \class "button loading"
      ..html "◌"
    @progress = @element.append \div
      ..attr \class \progress
      ..on \click ->
        return unless self.duration
        offset = ig.utils.offset @
        left = d3.event.x - offset.left
        perc = left / @offsetWidth
        self.onTimeRequested perc * self.duration
      ..on \mousedown -> d3.event.preventDefault!
      ..append \div
        ..attr \class \line
    @progressPoint = @progress.append \div
      ..attr \class \point
      ..style \left \0px
    @element.append \div
      ..attr \class \error-message
      ..html "Nahrávka projevu bohužel není k dispozici"
    @duration = null
    @timeLimit = null
    @setListeners!
    @audioElement = document.createElement \audio
      ..addEventListener \canplay ~>
        @element.attr \class "player paused"
        @updateProgress 0
      ..addEventListener \loadeddata ~>
        @element.attr \class "player paused"
        @updateProgress 0
      ..addEventListener \playing ~>
        @element.attr \class "player playing"
      ..addEventListener \durationchange (evt) ~>
        @duration = @audioElement.duration
      ..addEventListener \timeupdate ~>
        if @timeLimit and @audioElement.currentTime > @timeLimit
          @timeLimit = null
          @onPause!
        @updateProgress @audioElement.currentTime
      ..addEventListener \waiting ~>
        @element.attr \class "player loading"
      ..addEventListener \loadstart ~>
        @element.attr \class "player loading"
      ..addEventListener \error ~>
        @element.attr \class "player error"

  updateProgress: (time) ->
    return if not @duration
    @progressPoint.style \left "#{100 * time / @duration}%"

  onTimeRequested: (time) ->
    @timeLimit = null
    @audioElement.currentTime = time

  onPlay: ->
    @audioElement.play!
    @element.attr \class "player playing"

  onPause: ->
    @audioElement.pause!
    @element.attr \class "player paused"

  setSrc: (src) ->
    @audioElement.src = src
    @element.attr \class "player loading"
    <~ setInterval _, 1000
    if @audioElement.readyState <= 1
      @setIpad!

  setIpad: ->
    return if @ipad
    return if null is navigator.userAgent.match /(ipad|iphone)/i
    @ipad = yes
    @element.node!insertBefore @audioElement, @playBtn.node!
    @audioElement.controls = yes


  setListeners: ->
    document.addEventListener "click" ({target}:evt) ~>
      start = target.getAttribute "data-play-start"
      end = target.getAttribute "data-play-end"
      if start isnt null and end isnt null
        evt.preventDefault!
        [startSeconds, startMinutes] = start.split ":" .reverse!map parseFloat
        [endSeconds, endMinutes] = end.split ":" .reverse!map parseFloat
        startMinutes = startMinutes || 0
        endMinutes = endMinutes || 0
        @onTimeRequested startSeconds + startMinutes * 60
        @onPlay!
        @timeLimit = endSeconds + endMinutes * 60
        # console.log "Start", startMinutes, startSeconds,  startSeconds + startMinutes * 60
        # console.log "End", endMinutes, endSeconds,  endSeconds + endMinutes * 60

  pauseOtherAudios: ->
    audios = document.querySelectorAll "audio"
    for audio in audios
      if not audio.paused
        audio.pause!
        if audio.parentElement?className == "playing"
          audio.parentElement.className = "paused"
