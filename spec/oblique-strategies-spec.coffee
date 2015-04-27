ObliqueStrategies = require '../lib/oblique-strategies'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ObliqueStrategies", ->
  [workspaceElement, activationPromise, notificationActivationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    atom.notifications.clear()
    notificationActivationPromise = atom.packages.activatePackage('notifications')
    waitsForPromise ->
      notificationActivationPromise
    activationPromise = atom.packages.activatePackage('oblique-strategies')
    waitsForPromise ->
      activationPromise

  describe "when the package is activated with enableOnLoad = true", ->
    it "sets the enabled flag to true and displays an activation message", ->
      atom.config.set 'oblique-strategies.enableOnLoad', true
      expect(atom.config.get 'oblique-strategies.enableOnLoad').toBe true
      # Don't need to trigger the toggle because we're testing whether it activates on start-up
      # atom.commands.dispatch workspaceElement, 'oblique-strategies:toggle'
      # waitsForPromise ->
      #   activationPromise
      runs ->
        expect(ObliqueStrategies.enabled).toBe true
        notificationContainer = workspaceElement.querySelector('atom-notifications')
        notification = notificationContainer.querySelector('atom-notification.info')
        expect(notification).toExist()

  describe "when the package is activated with enableOnLoad = false", ->
    it "does not load", ->
      atom.config.set 'oblique-strategies.enableOnLoad', false
      expect(atom.config.get 'oblique-strategies.enableOnLoad').toBe false
      # Don't need to trigger the toggle because we're testing whether it activates on start-up
      # atom.commands.dispatch workspaceElement, 'oblique-strategies:toggle'
      # waitsForPromise ->
      #   activationPromise
      runs ->
        expect(ObliqueStrategies.enabled).toBe false
        notificationContainer = workspaceElement.querySelector('atom-notifications')
        notification = notificationContainer.querySelector('atom-notification.info')
        expect(notification).toExist() # TODO: This should be a not
    
