Sheriff.Groups = {
  observeInputControls: function(rows) {
    jQuery(rows).each(function() {
      var checkbox = jQuery('input[type=checkbox]', this).first()
        , inputs   = jQuery('input:not([type=checkbox]), select', this)

        console.log(checkbox, inputs)


      inputs.each(function() {
        jQuery(this).change(function() { checkbox.attr('checked', true) })
      })
    })
  }
}
