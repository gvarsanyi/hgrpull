fs = require 'fs'

is_dir         = require './lib/is_dir'
parse_url      = require './lib/parse_url'
hg_pull_update = require './lib/hg_pull_update'

window    = new (require './lib/Window')
passwords = new (require './lib/Passwords') window

home = process.cwd()

fs.readdir '.', (err, dirs) ->
  throw new Error(err) if err

  update = (dir, id) ->
    status = (msg) ->
      window.out msg, 1, id + 1, 1

    process.chdir home + '/' + dir
    window.out dir, 4, id + 1

    process.cwd home + '/' + dir
    status '.'
    fs.readFile '.hg/hgrc', encoding: 'utf-8', (err, hgrc) ->
      finish = (err, stdout) ->
        if err
          status '\u2716'
          done stdout, err, protocol, user, password, host
        else
          if stdout.indexOf('no changes found') is -1
            status '\u2714'
            done stdout, null, dir, protocol, user, password, host
          else
            status '\u2713'
            done null, null, dir, protocol, user, password, host

      if err
        status '\u2716'
      else
        lines = hgrc.split '\n'
        for line in lines
          paths = false if line[0] is '['
          paths = true if line is '[paths]'
          if line.substr(0, 10) is 'default = '
            {protocol, user, password, host} = parse_url line.substr 10
            break

        if protocol in ['http', 'https'] and user and not password
          status '?'
          passwords.get user, protocol, host, (err, password) ->
            return status('\u2716') if err
            status '#'
            hg_pull_update protocol, user, password, host, finish
        else
          status '#'
          hg_pull_update protocol, user, password, host, finish

  list = []
  maxlen = 0
  for dir in dirs
    if is_dir home + '/' + dir
      id = list.length
      count += 1
      list.push dir

      maxlen = dir.length if maxlen < dir.length

  window.init list.length + 4
  window.out 'Updating all services', 0, 0
  update(item, id) for item, id in list

logs = []
count = 0
done_count = 0
done = (stdout, err, dir, protocol, user, password, host) ->
  done_count += 1
  if err or stdout
    logs.push ' '
    logs.push '[' + dir + ' ' + protocol + '://' + user + '@' + host + ']'
    logs.push('STDOUT:', stdout) if stdout
    logs.push('ERROR:', err) if err
    logs.push '--------------------------------------------------------'

  (console.log log for log in logs) if done_count is count
