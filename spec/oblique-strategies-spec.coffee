ObliqueStrategies = require '../lib/oblique-strategies'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ObliqueStrategies", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('oblique-strategies')

  describe "enableOnLoad determines whether oblique-strategies loads when Atom starts", ->
    it "loads on Atom start-up when enableOnLoad is true", ->

      atom.config.set 'oblique-strategies.enableOnLoad', true

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'oblique-strategies:toggle'

      waitsForPromise ->
        activationPromise
      runs ->
        expect(ObliqueStrategies.enabled).toBe true

    it "does not load on Atom start-up when enableOnLoad is false", ->
      atom.config.set 'oblique-strategies.enableOnLoad', false

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'oblique-strategies:toggle'

      waitsForPromise ->
        activationPromise
      runs ->
        expect(ObliqueStrategies.enabled).toBe false
