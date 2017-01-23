tabLimit = {

  tabs: [],

  limit: 5,

  activate: (state) ->
    this.activePane = atom.workspace.getActivePane()
    this.tabs = this.activePane.getItems()
    this.activePane.onDidChangeActiveItem((item) =>
      this.handleNewActiveItem(item)
    )

  handleNewActiveItem: (item) ->
    if this.tabs.includes(item)
      this.tabs.splice(this.tabs.indexOf(item), 1)
    this.tabs.push(item)
    this.eject()

  eject: ->
    if this.tabs.length > this.limit
      oldTab = this.tabs.shift()
      this.activePane.destroyItem(oldTab)

};

module.exports = tabLimit
