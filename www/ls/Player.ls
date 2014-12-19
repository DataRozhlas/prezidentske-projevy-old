class ig.Player
  ->
    document.addEventListener "click" ({target}:evt) ~>
      start = target.getAttribute "data-play-start"
      end = target.getAttribute "data-play-end"
      if start isnt null and end isnt null
        if target.className == "playing"
          target.className = "paused"
          audio = target.querySelector "audio"
          audio.pause!
        else if target.className == "paused"
          target.className = "playing"
          audio = target.querySelector "audio"
          @pauseOtherAudios!
          audio.play!
        else
          target.className = "loading"
          start = parseFloat start
          end = parseFloat end
          audio = document.createElement "audio"
            ..src = "../audio/1990-Havel.mp3"
          audio.currentTime = start
          target.appendChild audio
          audio.addEventListener \canplay ~>
            @pauseOtherAudios!
            target.className = "playing"
            audio.play!
          audio.addEventListener \timeupdate ->
            if audio and audio.currentTime > end
              audio.pause!
              target.className = ""
              target.removeChild audio
              audio := null

  pauseOtherAudios: ->
    audios = document.querySelectorAll "audio"
    for audio in audios
      if not audio.paused
        audio.pause!
        if audio.parentElement?className == "playing"
          audio.parentElement.className = "paused"
