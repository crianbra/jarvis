
getRequest = (robot, data, callback) ->
    url = "#{url}/YourRepoName/#{data.repository}/pulls/#{data.pullId}?access_token=#{token}"

    robot.http(url)
      .headers('Accept': 'application/rubyon')
      .get() (err, res, body) ->
        callback(err, res, body)

module.exports = (robot) ->

robot.on 'merge_conflict', (merge_conflict) ->
      room_id = robot.adapter.client.rtm.dataStore.getChannelByName(merge_conflict.room).id
      message =
        {
          "texto": ":no_entry_sign: Merge conflict: <#{merge_conflict.pullUrl}|##{merge_conflict.number} #{merge_conflict.pullTitle}> by #{merge_conflict.author}"
        }

      robot.messageRoom room_id, message


robot.router.post '/hubot/github/:room', (req, res) ->
    room = req.params.room

    try
      data = req.body
    catch error
      robot.emit 'error', error

    pull_request =
    {
      room: room,
      url: data.pull_request.url
      pullId: data.pull_request.number
      pullState: data.pull_request.state
    }

if (pull_request.pullState == 'open' || pull_request.pullState == 'reopened')
    # do stuff
    console.log()

checkMergeStatus = (robot, data) ->
    getRequest robot, data, (err, res, body) ->
      try
        response = JSON.parse body
        mergeStatus = response.mergeable
      catch error
        robot.emit 'error', error

if (mergeStatus == false)
    # send notification
  else if (mergeStatus == 'unknown')
    setTimeout ->
      checkMergeStatus(robot, data)
    , 1000
  else
    # do something?

 robot.on 'error', (error) ->
    #process the error
