var SlackRubyBotServer = {};

$(document).ready(function() {

    SlackRubyBotServer.message = function(text) {
        $('#messages').fadeOut('slow', function() {
            $('#messages').fadeIn('slow').html(text)
        });
    };

    // Slack OAuth
    var code = $.url('?code');
    if (code) {
        SlackRubyBotServer.message('Working, please wait ...');
        $('#register').hide();
        $.ajax({
            type: "POST",
            url: "api/registration/",
            data: {
                code: code
            },
            success: function () {
                SlackRubyBotServer.message('Team successfully registered!<br><br>DM <b>@bot</b> or create a <b>#channel</b> and invite <b>@bot</b> to it.');
                $('#links').show();
            },
            error: function () {
                SlackRubyBotServer.message('There was a problem with your auth code. Are you already registered? If not, try again!');
                $('#register').fadeIn();
            }
        });
    }
});
