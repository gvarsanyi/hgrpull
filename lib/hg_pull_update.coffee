child  = require 'child_process'

module.exports = (protocol, user, password, host, callback) ->
  cmd = 'hg pull'
  if host and protocol and user and password
    cmd += ' --config auth.rc.prefix=' + protocol + '://' + host + '/'
    cmd += ' --config auth.rc.username=' + user
    cmd += ' --config auth.rc.password=' + password
  cmd += ' -u'

  proc = child.exec cmd, (err, stdout, stderr) ->
    return callback(err) if err
    callback null, stdout
