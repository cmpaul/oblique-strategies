# I can't take credit for the prompts! Kevin Lawler compiled
# these here: http://kevinlawler.com/prompts
#
# I highly recommend reading these to get more information on
# each strategy.
#
# Enjoy!

{CompositeDisposable} = require 'atom'

module.exports = ObliqueStrategies =

  # Properties
  subscriptions: null
  showTimeout: null
  enabled: false
  strategiesList: []
  recentStrategiesList: []

  # Exported configuration settings
  config:
    enableOnLoad:
      title: 'Enable on load',
      description: 'Should this package start enabled?'
      type: 'boolean'
      default: false
    areStrategiesSticky:
      title: 'Sticky Strategies',
      description: 'Should strategies automatically disappear?'
      type: 'boolean'
      default: false
    showAfterInactivitySeconds:
      title: 'Inactivity Trigger'
      description: 'Number of seconds of inactivity before a strategy is displayed.'
      type: 'integer'
      default: 30
      minimum: 5
    strategiesList:
      title: 'Strategies List'
      description: 'A comma-separated list of strategies that will be displayed at random for inspiration after a period of inactivity.'
      type: 'array'
      items:
        type: 'string'
      default: [
        # The following are oblique strategies for programmers
        # by Kevin Lawler, http://kevinlawler.com/prompts
        'Look for a hack.',
        'Look for a good enough approximation.',
        'Have faith in sound-looking abstractions.',
        'Forget about optimizing your code.',
        'Solve the problem directly.',
        'Feats are fragile.',
        'Build the theory of the problem.',
        'Shear off a layer.',
        'Get red and green right before mixing yellow.',
        'A blink lasts 300 milliseconds.',
        'Zoom in.',
        'Add constraints.',
        'Mark it: WONTFIX',
        'Verify your fears, explicitly.',
        'Keep calm.',
        'Take a closer look.',
        'Is it the bug you think it is?',
        'Is it a typo?',
        'Stop and think.',
        'If you lack motivation, find the most interesting thing in the project, start on that, and branch from there.',
        'Work append-only.',
        'Run through the thornbushes.',
        'Change your mind.',
        'Power through.',
        'Look for ways to chain tools.',
        'Backtrack.',
        'Flip the problem around.',
        'Work forward from where the unfinished part of the code suggests you should.',
        'List dependencies to determine order of completion.',
        'Try the naïve method first.',
        'Do it both ways.',
        'Verify that your assumptions are correct.',
        'Every bug hunt is at worst a log time search through the code base.',
        'Write down everything you know about the problem.',
        'This process usually converges: If you\'re stuck, finish some remaining piece. Then go back and check to see what new possibilities opened up. Repeat.',
        'Form hypothesis, test hypothesis, repeat.',
        'Have opinions.',
        'Have goals and subdivide them.',
        'Do it the wrong way.',
        'Do something.',
        'Put the problem aside and work on something else.',
        'Take a walk.',
        # The following are selected oblique strategies
        # Oblique Strategies © 1975, 1978, and 1979 Brian Eno/Peter Schmidt
        'A line has two sides.',
        'Allow an easement (an easement is the abandonment of a stricture).',
        'Always, first steps.',
        'Ask your body.',
        'Breathe deeply.',
        'Cascades.',
        'Consider changing nothing, continue with immaculate consistency.',
        'Cluster analysis.',
        'Consult other sources.',
        'Courage!',
        'Cut a vital connection.',
        'Decorate, decorate.',
        "Define an area as 'safe' and use it as an anchor.",
        'Discard an axiom.',
        'Disconnect from desire.',
        "Don't be afraid of things because they're easy to do.",
        "Don't be frightened of cliches.",
        "Don't break the silence.",
        'Do some clean up.',
        'Do the names need changing?',
        'Emphasize differences.',
        'Emphasize repetition.',
        'Emphasize the flaws.',
        'Look to the left and the right. Stretch your neck.',
        'Give way to your worst impulse.',
        'Honor the error as a hidden intention.',
        'How would you have done it?',
        'Infinitesimal gradations.',
        'Is it finished?',
        'Is there something missing?',
        'Keep going.',
        'Look at a very small object, look at its center.',
        'Look at the order in which you are doing things.',
        'Make an exhaustive list of everything you could do. Do the last thing on the list.',
        'Make a sudden, destructive unpredictable action; incorporate.',
        'Remove ambiguities and convert to specifics.',
        'Remove specifics and convert to ambiguities.',
        'Repetition is a form of change.',
        'Go the other direction.',
        'Take a break.',
        'Stand up.',
        'Look away for a while.',
        'Tidy up.',
        'Twist the spine.',
        'Use an old idea.',
        'Water.',
        'What were you really thinking about just now? Incorporate.',
        'What mistakes did you make last time?',
        'What would someone you admire do?',
        'What wouldn\'t you do?',
        'Work at a different speed.',
        'You are an engineer.'
      ]

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'oblique-strategies:toggle': => @toggle()
    # Shuffle and load strategies into memory
    @strategiesList = @shuffle(atom.config.get('oblique-strategies.strategiesList'))
    # Detect whether the package is enabled
    @enabled = atom.config.get('oblique-strategies.enabled')
    if @enabled
      @startShowTimeout()
    # Listen for keypress events to know when to display
    @addKeyupListener()

  deactivate: ->
    @subscriptions.dispose()

  # The wonderfully efficient Fisher-Yates shuffle
  # (http://bost.ocks.org/mike/shuffle/)
  shuffle: (array) ->
    m = array.length
    while m
      i = Math.floor(Math.random() * m--)
      t = array[m]
      array[m] = array[i]
      array[i] = t
    return array

  addKeyupListener: ->
    atom.workspaceView.eachEditorView (editorView) =>
      editorView.on 'keyup', (event) =>
        if @enabled
          console.log 'enabled'
          @startShowTimeout()
        else
          console.log 'disabled'

  show: ->
    console.log 'show'
    msg = @strategiesList.pop()
    console.log 'msg', msg
    atom.notifications.addInfo(msg, { dismissable: atom.config.get('oblique-strategies.areStrategiesSticky') });
    @strategiesList.unshift msg
    @startShowTimeout()

  startShowTimeout: ->
    console.log 'startShowTimeout'
    clearTimeout @showTimeout
    inactiveSec = atom.config.get('oblique-strategies.showAfterInactivitySeconds')
    @showTimeout = setTimeout =>
      @show()
    , inactiveSec * 1000

  toggle: ->
    @enabled = !@enabled
    if @enabled
      console.log 'start'
      # Start the timeout
      @startShowTimeout()
    else
      # Stop existing timeout
      console.log 'stop'
      clearTimeout @showTimeout
      @showTimeout = null
