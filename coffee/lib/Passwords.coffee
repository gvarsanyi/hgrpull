
class Passwords
  constructor: (@window) ->
    @users = {}
    @queue = []
    @retrieving = false

  retrieve: () ->
    if not @retrieving
      @retrieving = true
      id = @queue.shift()
      {user, protocol, host} = @users[id]
      msg = 'Password for ' + user + '@' + host + ' over ' + protocol + ': '
      @window.clear_last_row()
      @window.get_password msg, (err, password) =>
        throw new Error(err) if err
        @window.clear_last_row()
        @users[id].password = password or ''
        callback(null, password or '') for callback in @users[id].callbacks
        @retrieving = false
        @retrieve() if @queue.length

  get: (user, protocol, host, callback) ->
    id = [user, protocol, host].join '*'

    return callback(null, @users[id].password) if @users[id]?.password?

    if @users[id] is undefined
      @users[id] = {user, protocol, host, callbacks: [callback]}
      @queue.push id
      @retrieve()
    else
      @users[id].callbacks.push callback

module.exports = Passwords
