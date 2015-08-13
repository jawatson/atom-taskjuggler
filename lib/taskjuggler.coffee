TaskjugglerView = require './taskjuggler-view'
{CompositeDisposable} = require 'atom'
spawn = require('child_process').spawn
path = require 'path'

# https://github.com/AtomLinter/linter-eslint/blob/master/lib/linter-eslint.coffee

module.exports =
  #consoleView: null

  activate: ->
    atom.commands.add 'atom-workspace', "taskjuggler:runtj", => @runtj()

  runtj: ->
    #@consoleView = new ConsoleView(state.consoleViewState)
    #sync = require('tj3').spawnSync
    # This assumes the active pane item is an editor
    editor = atom.workspace.getActivePaneItem()
    console.log("Running Taskjuggler")

    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer.file
    filePath = file?.path
    console.log("Path: "+filePath)
    dirPath = path.dirname(filePath)
    console.log("Dir: "+dirPath)
    sp = spawn("tj3", [filePath], ["-o", dirPath])

    console.log("Done")
