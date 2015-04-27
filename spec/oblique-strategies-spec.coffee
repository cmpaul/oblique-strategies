ObliqueStrategies = require '../lib/oblique-strategies'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ObliqueStrategies: ", ->
  [workspaceElement, activationPromise, notificationActivationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    notificationActivationPromise = atom.packages.activatePackage('notifications')
    waitsForPromise ->
      notificationActivationPromise
    atom.notifications.clear()
    activationPromise = atom.packages.activatePackage('oblique-strategies')
    waitsForPromise ->
      activationPromise

  describe "when the package is activated with enableOnLoad = true", ->
    it "sets the enabled flag to true and displays an activation message", ->
      atom.config.set 'oblique-strategies.enableOnLoad', true
      expect(atom.config.get 'oblique-strategies.enableOnLoad').toBe true
      runs ->
        expect(ObliqueStrategies.enabled).toBe true
        notificationContainer = workspaceElement.querySelector('atom-notifications')
        notification = notificationContainer.querySelector('atom-notification.info')
        expect(notification).toExist()

  describe "when the package is activated with enableOnLoad = false", ->
    beforeEach ->
      atom.packages.deactivatePackage('oblique-strategies')
    it "does not load", ->
      atom.config.set 'oblique-strategies.enableOnLoad', false
      expect(atom.config.get 'oblique-strategies.enableOnLoad').toBe false
      runs ->
        expect(ObliqueStrategies.enabled).toBe false
