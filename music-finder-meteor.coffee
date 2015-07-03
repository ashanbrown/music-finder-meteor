if Meteor.isClient
  Template.body.helpers
    songs: [
      name: "O Canada",
      url: 'https://upload.wikimedia.org/wikipedia/commons/9/9e/O_Canada.ogg'
    ,
      name: "Star-Spangled Banner"
      url: 'https://upload.wikimedia.org/wikipedia/commons/8/80/The_Star-Spangled_Banner_-_U.S._Army_1st_Armored_Division_Band.ogg'
    ]

  Meteor.startup ->
    Tracker.autorun ->
      if Meteor.userId()
        window.mixpanel.alias Meteor.userId()
        window.mixpanel.identify Meteor.userId()
        window.soundManager.setup()

  Template.body.events 'click #logout': () ->
    window.mixpanel.track 'logOut',
    Meteor.logout()
    return

  Template.song.events 'click a[data-name]': (e) ->
    window.mixpanel.track 'playedASong',
      name: $(e).data('name')
    return

if Meteor.isServer
  mixpanel = Meteor.npmRequire('mixpanel').init '7dee9e526849b7f55da99451fcae41c6',
    verbose: true
    debug: true

  Accounts.onCreateUser (options, user) ->
    email = user.emails[0].address
    mixpanel.track 'createdUser',
      distinct_id: user._id
    mixpanel.people.set user._id,
      $email: email
    user

  Accounts.onLogin (user) ->
    mixpanel.track 'logIn',
      distinct_id: user._id
    user

  Meteor.startup ->
    return
