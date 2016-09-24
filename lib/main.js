const TabLimit = {

  tabs: [],

  limit: 5,

  activate (state) {
    this.activePane = atom.workspace.getActivePane();
    this.tabs = this.activePane.getItems();
    this.activePane.onDidChangeActiveItem((item) => {
      this.handleNewActiveItem(item)
    });
  },

  handleNewActiveItem(item) {
    if (this.tabs.includes(item)) {
      this.tabs = this.tabs.splice(this.tabs.indexOf(item), 1)
    }
    this.tabs.push(item);
    console.log(this.tabs);
    this.eject();
  },

  eject() {
    if (this.tabs.length > this.limit) {
      const oldTab = this.tabs.shift();
      this.activePane.destroyItem(oldTab);
    }
  }

};

module.exports = TabLimit;
