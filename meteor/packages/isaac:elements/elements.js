// Generated by CoffeeScript 1.8.0
var knownElementNames;

knownElementNames = 'a abbr acronym address applet area article aside audio b base basefont bdi bdo big blockquote body br button canvas caption center cite code col colgroup command data datagrid datalist dd del details dfn dir div dl dt em embed eventsource fieldset figcaption figure font footer form frame frameset h1 h2 h3 h4 h5 h6 head header hgroup hr html i iframe img input ins isindex kbd keygen label legend li link main map mark menu meta meter nav noframes noscript object ol optgroup option output p param pre progress q rp rt ruby s samp script section select small source span strike strong style sub summary sup table tbody td textarea tfoot th thead time title tr track tt u ul var video wbr'.split(' ');

if (Meteor.isClient) {
  (typeof window !== "undefined" && window !== null) && 'DIV H1 H2 H3 H4 H5 H6 P BR VIDEO SOURCE'.split(' ').map(function(a) {
    return window[a] = function(obj, str) {
      if (str != null) {
        return HTML.toHTML(HTML[a](obj, str));
      } else {
        return HTML.toHTML(HTML[a](obj));
      }
    };
  });
}
