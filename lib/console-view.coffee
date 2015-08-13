# This file is based on the work presented in the Tidal package

module.exports =
class ConsoleView
  constructor: (serializeState) ->

  initUI: ->
    @tjConsole = document.createElement('div')
    @tjConsole.classList.add('taskjuggler', 'console')

    @log = document.createElement('div')
    @tjConsole.appendChild(@log)

    atom.workspace.addBottomPanel({item: @tjConsole, visible: true})
    console.log("done init")

  serialize: ->

  destroy: ->
    #@tjConsole.remove()

  logStdout: (text)->
    @logText(text)

  logStderr: (text)->
    @logText(text)

  logText: (text) ->
    @tjConsole.scrollTop = @tjConsole.scrollHeight;
    textNode = document.createElement("span");
    textNode.innerHTML = text.replace('\n', '</br>')
    @log.appendChild(textNode)
