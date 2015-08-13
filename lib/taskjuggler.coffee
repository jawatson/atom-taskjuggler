#TaskjugglerView = require './taskjuggler-view'
{CompositeDisposable} = require 'atom'
spawn = require('child_process').spawn
path = require 'path'
ConsoleView = require './console-view'

# https://github.com/AtomLinter/linter-eslint/blob/master/lib/linter-eslint.coffee

module.exports =
  consoleView: null

  activate: (state)->
    atom.commands.add 'atom-workspace', "taskjuggler:runtj", => @runtj()
    @consoleView = new ConsoleView(state.consoleViewState)
    console.log ("Activate.....")

  runtj: ->
    # This assumes the active pane item is an editor
    # editor = atom.workspace.getActivePaneItem()
    console.log("Running Taskjuggler")
    #if @consoleView?
    console.log ("destroy")
    @consoleView.destroy()

    editor = atom.workspace.getActivePaneItem()
    editor?.save() # todo popup a window to confirm
    file = editor?.buffer.file
    filePath = file?.path
    console.log("Path: "+filePath)
    dirPath = path.dirname(filePath)
    console.log("Dir: "+dirPath)
    @consoleView.initUI()
    @tj = spawn("tj3", ['--silent', '-o', dirPath, filePath])
    @tj.stdout.on('data', (data) => @consoleView.logStdout(data.toString('utf8')))
    @tj.stderr.on('data', (data) => @consoleView.logStderr(data.toString('utf8')))
    console.log("Done")

  runSyntax: ->
    console.log ("Checking syntax")  
