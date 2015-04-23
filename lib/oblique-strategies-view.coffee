module.exports =
class ObliqueStrategiesView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('oblique-strategies')

    # Create message element
    message = document.createElement('div')
    messageHeader = document.createElement('h1')
    messageHeader.textContent = "Oblique Strategies"
    messageContent = document.createElement('p')
    messageContent.textContent = "The ObliqueStrategies package is Alive! It's ALIVE!"
    message.appendChild(messageHeader)
    message.appendChild(messageContent)
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
