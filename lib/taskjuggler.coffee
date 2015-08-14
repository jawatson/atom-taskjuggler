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
    atom.commands.add 'atom-workspace', "taskjuggler:checkSyntax", => @checkSyntax()
    @consoleView = new ConsoleView(state.consoleViewState)

  runtj: ->
    # This assumes the active pane item is an editor
    # editor = atom.workspace.getActivePaneItem()
    @consoleView.destroy()

    editor = atom.workspace.getActivePaneItem()
    editor?.save() # todo popup a window to confirm
    file = editor?.buffer.file
    filePath = file?.path
    dirPath = path.dirname(filePath)
    @consoleView.initUI()
    @tj = spawn("tj3", ['--silent', '-o', dirPath, filePath])
    @tj.stdout.on('data', (data) => @consoleView.logStdout(data.toString('utf8')))
    @tj.stderr.on('data', (data) => @consoleView.logStderr(data.toString('utf8')))
    @tj.on('exit', (code) => @consoleView.logStdout(@returnCodeMsg(code)))

  returnCodeMsg: (code) ->
    if code==0
      msg = "Complete.  No errors."
    else
      msg = "Complete (with errors)"
    return msg

  checkSyntax: ->
    # This assumes the active pane item is an editor
    # editor = atom.workspace.getActivePaneItem()
    @consoleView.destroy()

    editor = atom.workspace.getActivePaneItem()
    editor?.save() # todo popup a window to confirm
    file = editor?.buffer.file
    filePath = file?.path
    @consoleView.initUI()
    @tj = spawn("tj3", ['--silent', '--check-syntax', filePath])
    @tj.stdout.on('data', (data) => @consoleView.logStdout(data.toString('utf8')))
    @tj.stderr.on('data', (data) => @consoleView.logStderr(data.toString('utf8')))
    @tj.on('exit', (code) => @consoleView.logStdout(@returnCodeMsg(code)))
