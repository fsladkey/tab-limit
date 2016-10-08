tabLimit = require('../lib/main')

describe "math", ->
noop = ->

describe "subject-limit", ->
  subject = null

  createTabLimit = ->
    subject = Object.assign({}, tabLimit)

  beforeEach ->
    createTabLimit()

  describe "activate", ->
    activePane = { onDidChangeActiveItem: noop, getItems: noop }

    beforeEach ->
      spyOn(atom.workspace, "getActivePane").andReturn(activePane)
      spyOn(activePane, "onDidChangeActiveItem")

    it "registers a callback on active item change", ->
      subject.activate()
      expect(activePane.onDidChangeActiveItem).toHaveBeenCalled()


    it "sets the tabs array to the currently open subjects", ->
      spyOn(activePane, "getItems").andReturn([ { id: 1 }, { id: 2 } ])


      subject.activate()
      expect(subject.tabs.length).toBe(2)


  describe "handleNewActiveItem", ->

    describe "when the collection is empty", ->

      it "adds the subject to the subject list", ->
        tab = { title: "file.js" }
        subject.handleNewActiveItem(tab)
        expect(subject.tabs.length).toBe(1)
        expect(subject.tabs[0]).toBe(tab)

    describe "when almost full", ->

      it "adds a new tab to the list", ->
        subject.tabs = [null, null, null, null]
        tab = { title: "file.js" }
        subject.handleNewActiveItem(tab)
        expect(subject.tabs.length).toBe(5)
        expect(subject.tabs[4]).toBe(tab)

    describe "full", ->

      beforeEach ->
        subject.tabs = [1, 2, 3, 4, 5]
        subject.activePane = { destroyItem: noop }
        spyOn(subject.activePane, "destroyItem")

      it "adds a tab to the list when full", ->
        tab = { title: "file.js" }
        subject.handleNewActiveItem(tab)
        expect(subject.tabs.length).toBe(5)
        expect(subject.tabs[4]).toBe(tab)

      it "ejects tabs in the correct order", ->
        subject.handleNewActiveItem(6)
        expect(subject.tabs).toEqual([2, 3, 4, 5, 6])
        subject.handleNewActiveItem(7)
        expect(subject.tabs).toEqual([3, 4, 5, 6, 7])
        subject.handleNewActiveItem(8)
        expect(subject.tabs).toEqual([4, 5, 6, 7, 8])
        subject.handleNewActiveItem(6)
        expect(subject.tabs).toEqual([4, 5, 7, 8, 6])
        subject.handleNewActiveItem(4)
        expect(subject.tabs).toEqual([5, 7, 8, 6, 4])
        subject.handleNewActiveItem(10)
        expect(subject.tabs).toEqual([7, 8, 6, 4, 10])
