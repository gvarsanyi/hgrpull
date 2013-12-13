
module.exports = (url) ->
  [protocol, user] = url.split '://'
  [user, host] = user.split '@'
  [user, password] = user.split ':'
  [host, uri] = host.split '/', 2
  [host, port] = host.split ':'
  protocol = protocol.toLowerCase()
  {protocol, user, password, host, port, uri}
