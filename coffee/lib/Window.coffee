
class Window
  init: (@rows) ->
    @rows = process.stdout.rows if not @rows?
    process.stdout.write('\n') for i in [0 ... @rows]
    @last_x = 0
    @

  out: (msg, x, y, maxlength) ->
    msg = String msg
    maxlength = maxlength or msg.length
    msg += ' ' while msg.length < maxlength
    y += process.stdout.rows - @rows

    w = '\u001B[' + (y + 1) + ';' + (x + 1) + 'H'
    w += msg.substr 0, maxlength
    # move cursor to last row
    w += '\u001B[' + (process.stdout.rows - 1) + ';' + (@last_x + 1) + 'H'
    process.stdout.write w
    @

  clear_last_row: ->
    @last_x = 0
    w = '\u001B[' + (process.stdout.rows - 1) + ';1H'
    w += ' ' for i in [0 ... process.stdout.columns]
    w += '\u001B[' + (process.stdout.rows - 1) + ';1H'
    process.stdout.write w
    @

  get_password: (prompt, callback) ->
    [callback, prompt] = [prompt, callback] if callback is undefined

    process.stdout.write(prompt or 'Password: ')

    process.stdin.setRawMode true
    process.stdin.resume()
    process.stdin.setEncoding 'utf8'

    @last_x = String(prompt or 'Password: ').length

    password = ''
    process.stdin.on 'data', (character) ->
      switch character
        when '\r', '\n', '\u0004'
          process.stdout.write '\n'
          process.stdin.setRawMode false
          process.stdin.pause()
          callback null, password
        when '\u0003' # Ctrl-C
          callback new Error('Ctrl-C was hit')
        else
          process.stdout.write '*'
          @last_x += 1
          password += character
    @

module.exports = Window
