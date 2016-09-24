const TabLimit = {

  tabs: [],

  limit: 5,

  activate (state) {
    console.log("ACTIVATING");
    const activePane = atom.workspace.getActivePane();
    activePane.onDidChangeActiveItem(handleNewActiveItem);
    activePane.onDidAddItem(handleNewItem);
  },

  deactivate () {
    console.log("DEACTIVATING");
    this.subscriptions.dispose();
  },

  handleNewActiveItem(item) {
    console.log("NEW ACTIVE ITEM");
    if (this.tabs.include(item)) {
      this.tabs = this.tabs.splice(this.tabs.indexOf(item), 1)
    }
    this.tabs.push(item);
    this.eject();
  },

  eject() {
    if (this.tabs.length > this.limit) {
      const oldTab = this.tabs.shift();
      oldTab.destroy();
    }
  }

};
export default TabLimit;
