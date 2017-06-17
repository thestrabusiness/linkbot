$(document).on('turbolinks:load', function () {
    $('.team-select').change(function (){
        this.closest('form').submit()
    })
});
