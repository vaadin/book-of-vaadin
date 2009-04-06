function write_footer() {
  document.body.innerHTML = document.body.innerHTML + '</div>' +
  '<div id="footer">(c) Oy IT Mill Ltd, 2000-2006</span>';

}

function style(href) {
  var title=document.title;
  document.write('<link href="' + href + '/local.css" rel="stylesheet" type="text/css" />');
  document.write('<table border="0" width="100%"><tr><td
style="padding-left: 10px;"><img src="'+href+'/img/itmill-logo.png"/></td><td align="right" style="padding-right: 10px; font-size: 14pt; font-weight: bold;">'+title+'</td></tr></table>');
  document.write('<div id="page">');
  window.onload=write_footer;
}


