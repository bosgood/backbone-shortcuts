# Backbone.Shortcuts defines and dispatches keyboard shortcuts
#
# dependencies:
#   - underscore.js http://underscorejs.org)
#   - backbone.js (http://backbonejs.org/)
#   - keymaster.js (https://github.com/madrobby/keymaster)
#
# Examples:
#
# class Shortcuts extends Backbone.Shortcuts
# 
#   shortcuts:
#     "ctrl+r" : "reloadPage"
#   
#   reloadPage: ->
#     alert("page reloaded!")
#
# shortcuts = new Shortcuts
#
  
Shortcuts = (options) ->
  @cid = _.uniqueId("backbone.shortcuts")
  @initialize.apply(@, arguments)
  @delegateShortcuts()

getKeyAndScope = (shortcut) ->
  match = shortcut.match(/^(\S+)\s*(.*)$/)
  shortcutKey = match[1]
  scope = if match[2] == "" then "all" else match[2]
  return [shortcutKey, scope]

_.extend Shortcuts.prototype, Backbone.Events,
  initialize: ->
  delegateShortcuts: ->
    return unless @shortcuts
    for shortcut, callback of @shortcuts
      method = @[callback] unless _.isFunction(callback)
      throw new Error("Method #{callback} does not exist") unless method
      [shortcutKey, scope] = getKeyAndScope(shortcut, callback)
      method = _.bind(method, @)
      key(shortcutKey, scope, method)
  undelegateShortcuts: ->
    return unless @shortcuts
    for shortcut, callback of @shortcuts
      [shortcutKey, scope] = getKeyAndScope(shortcut, callback)
      key.unbind(shortcutKey, scope)

Backbone.Shortcuts = Shortcuts
Backbone.Shortcuts.extend = Backbone.View.extend
