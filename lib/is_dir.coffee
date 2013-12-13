
module.exports = (dir) ->
  orig = process.cwd()
  try
    process.chdir dir
  catch err
    fail = true
  process.chdir orig
  not fail
