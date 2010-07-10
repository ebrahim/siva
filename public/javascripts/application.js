function remove_fields(link)
{
	$(link).previous('.hidden').down('input[type=hidden]').value = '1';
	$(link).up('.inputs').hide();
}

function add_fields(link, association, content)
{
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).insert({ before: content.replace(regexp, new_id) });
}
