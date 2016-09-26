

# Reloading modules from the repl in Node.js
# Benjamin Gleitzman (gleitz@mit.edu)
#
# Inspired by Ben Barkay
# http://stackoverflow.com/a/14801711/305414
#
# Usage: `node reload.js`
# You can load the module as usual
# var mymodule = require('./mymodule')
# And the reload it when needed
# mymodule = require.reload('./mymodule')

# Removes a module from the cache.
global.require.uncache = (moduleName) ->
  # Run over the cache looking for the files loaded by the specified module name
  require.searchCache moduleName, (mod) ->
    delete require.cache[mod.id]

# Runs over the cache to search for all the cached files.
global.require.searchCache = (moduleName, callback) ->
  # Resolve the module identified by the specified name
  mod = @.resolve(moduleName)
  # Check if the module has been resolved and found within the cache
  if mod? and (mod = @.cache[mod])?
    # Recursively go over the results
    ((mod) ->
      # Go over each of the module's children and
      # run over it
      mod.children.forEach (child) ->
        run child
      # Call the specified callback providing the
      # found module
      callback mod
    ) mod

# Load a module, clearing it from the cache if necessary.

global.require.reload = (moduleName) ->
  @.uncache moduleName
  @ moduleName

