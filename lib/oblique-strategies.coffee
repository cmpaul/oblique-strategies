ObliqueStrategiesView = require './oblique-strategies-view'
{CompositeDisposable} = require 'atom'

module.exports = ObliqueStrategies =
  # obliqueStrategiesView: null
  subscriptions: null
  showAfterInactivitySeconds: 10 # TODO: Maybe a min/max, with random timer?
  showTimeout: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'oblique-strategies:toggle': => @startShowTimeout()

    # Listen for keypress events to know when to display
    atom.workspaceView.eachEditorView (editorView) =>
      editorView.on 'keyup', (event) =>
        @startShowTimeout()

  deactivate: ->
    @subscriptions.dispose()

  show: ->
    console.log 'showing!'
    # TODO: Cycle through random strategies
    atom.notifications.addInfo("Breathe more deeply");
    @startShowTimeout()

  startShowTimeout: ->
    clearTimeout @showTimeout
    @showTimeout = setTimeout =>
      console.log 'showTimeout ran out, displaying strategy'
      @show()
    , @showAfterInactivitySeconds * 1000
