{CompositeDisposable} = require 'atom'

module.exports = ObliqueStrategies =

  # Properties
  subscriptions: null
  showTimeout: null
  enabled: false
  strategiesList: []
  recentStrategiesList: [],
  countdown: 0

  # Exported configuration settings
  config:
    enableOnLoad:
      title: 'Enable on load',
      description: 'Should this package activate itself when Atom loads? (Default: checked)'
      type: 'boolean'
      default: true
    areStrategiesSticky:
      title: 'Sticky strategies',
      description: 'Should strategies hang around (checked) or dismiss themselves (unchecked)? (Default: unchecked)'
      type: 'boolean'
      default: false
    randomizeStrategies:
      title: 'Randomize strategies',
      description: 'Should strategies be randomized? (Default: checked)'
      type: 'boolean'
      default: true
    showAfterInactivitySeconds:
      title: 'Inactivity Trigger'
      description: 'Number of seconds of inactivity before a strategy is displayed.'
      type: 'integer'
      default: 30
      minimum: 5
    notificationType:
      title: 'Notification Type',
      description: 'The type of notification that should be used to display the strategies. (Default: Info)'
      type: 'string',
      default: 'Info',
      enum: ['Success', 'Info', 'Warning', 'Error']
    strategiesList:
      title: 'Strategies List'
      description: 'A comma-separated list of strategies that will be displayed at random for inspiration after a period of inactivity.'
      type: 'array'
      items:
        type: 'string'
      default: [
        # The following are from Oblique Strategies: Prompts for Programmers
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
        'If you lack motivation, find the most interesting thing and branch from there.',
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
        'You are an engineer.',
        # Mine :)
        'Take a walk.',
        'Look to the left and the right. Stretch your neck.'
      ]

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'oblique-strategies:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'oblique-strategies:show': => @show()
    # Pre-load list into memory
    @strategiesList = atom.config.get('oblique-strategies.strategiesList')
    # Detect editor inactivity
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      editor.onDidStopChanging () =>
        if @enabled
          @startShowTimeout()
    # Detect whether the package is enabled
    if atom.config.get('oblique-strategies.enableOnLoad')
      @toggle()

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

  show: ->
    if atom.config.get('oblique-strategies.randomizeStrategies')
      if @countdown > 0
        @countdown--
      else
        @strategiesList = @shuffle(atom.config.get('oblique-strategies.strategiesList'))
        @countdown = @strategiesList.length
    msg = @strategiesList.shift()
    addFn = 'add' + atom.config.get('oblique-strategies.notificationType')
    atom.notifications[addFn](msg, { dismissable: atom.config.get('oblique-strategies.areStrategiesSticky') });
    @strategiesList.push msg
    @startShowTimeout()

  startShowTimeout: ->
    clearTimeout @showTimeout
    inactiveSec = atom.config.get('oblique-strategies.showAfterInactivitySeconds')
    @showTimeout = setTimeout =>
      @show()
    , inactiveSec * 1000

  toggle: ->
    @enabled = !@enabled
    if @enabled
      # Start the timeout
      atom.notifications.addInfo('Oblique Strategies: Enabled', { dismissable: false });
      @startShowTimeout()
    else
      # Stop existing timeout
      atom.notifications.addInfo('Oblique Strategies: Disabled', { dismissable: false });
      clearTimeout @showTimeout
      @showTimeout = null
