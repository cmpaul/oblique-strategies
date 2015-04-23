ObliqueStrategiesView = require './oblique-strategies-view'
{CompositeDisposable} = require 'atom'

module.exports = ObliqueStrategies =
  obliqueStrategiesView: null
  modalPanel: null
  subscriptions: null
  autoHideSeconds: 2 # FIXME: Might want to increase - 10?
  showAfterInactivitySeconds: 5 # FIXME: Might want to increase - 60?
  hideTimeout: null
  showTimeout: null

  activate: (state) ->
    @obliqueStrategiesView = new ObliqueStrategiesView(state.obliqueStrategiesViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @obliqueStrategiesView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'oblique-strategies:toggle': => @toggle()

    # Listen for keypress events to know when to display
    atom.workspaceView.eachEditorView (editorView) =>
      editorView.on 'keyup', (event) =>
        @hide()
      editorView.on 'mouseup', (event) =>
        @hide()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @obliqueStrategiesView.destroy()

  serialize: ->
    obliqueStrategiesViewState: @obliqueStrategiesView.serialize()

  clearTimeouts: ->
    clearTimeout @showTimeout
    clearTimeout @hideTimeout
    @showTimeout = null
    @hideTimeout = null

  show: ->
    @modalPanel.show()
    @clearTimeouts()
    @hideTimeout = setTimeout =>
      console.log 'hideTimeout ran out, hiding strategy'
      @hide()
    , @autoHideSeconds * 1000

  hide: ->
    @modalPanel.hide()
    @clearTimeouts()
    # Set a new timeout to display a strategy
    @showTimeout = setTimeout =>
      console.log 'showTimeout ran out, displaying strategy'
      @show()
    , @showAfterInactivitySeconds * 1000

  toggle: ->
    console.log 'ObliqueStrategies was toggled!'

    if @modalPanel.isVisible()
      @hide()
    else
      @show()
