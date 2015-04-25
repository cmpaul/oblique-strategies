{CompositeDisposable} = require 'atom'

module.exports = ObliqueStrategies =

  # Exported configuration settings
  config:
    showAfterInactivitySeconds:
      title: 'Inactivity Trigger'
      description: 'Number of seconds of inactivity before a strategy is displayed.'
      type: 'integer'
      default: 10
      minimum: 1

  subscriptions: null

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
    inactiveSec = atom.config.get('oblique-strategies.showAfterInactivitySeconds')
    console.log 'inactive sec', inactiveSec
    @showTimeout = setTimeout =>
      console.log 'showTimeout ran out, displaying strategy'
      @show()
    , inactiveSec * 1000
