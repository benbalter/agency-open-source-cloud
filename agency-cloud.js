// Generated by CoffeeScript 1.3.3
(function(){var e;e={account_query:"http://registry.usa.gov/accounts.json?service_id=github&agency_id=&tag=&callback=?",repo_query:"https://api.github.com/users/%s/repos?callback=?",max_size:3,min_size:.1,counts:[],ul:"#tags",show_counts:!0,render:function(){var t,n;return e.min=e.calcMin(e.counts),e.max=e.calcMax(e.counts),t=Math.log(parseInt(e.max))-Math.log(parseInt(e.min)),n=Math.log(e.min),jQuery.each(e.counts,function(r,i){var s,o,u;return u=(Math.log(i.count)-n)/t,o=e.min_size+(e.max_size-e.min_size)*u,s='<li class="tag" style="font-size:'+o+'em">'+i.agency,e.show_counts&&(s+='<span class="count">('+i.count+")</span> "),s+="</li>",jQuery(e.ul).append(s)})},getAccounts:function(){return jQuery.getJSON(e.account_query,function(t){return e.getRepos(t.accounts)})},getRepos:function(t){return jQuery.each(t,function(n,r){return jQuery.getJSON(e.repo_query.replace("%s",r.account),function(i){var s;s={agency:r.organization,count:i.data.length},e.counts.push(s);if(n===t.length-1)return e.render()})})},calcMin:function(e){var t;return t=null,jQuery.each(e,function(e,n){if(t===null||n.count<t)return t=n.count}),t||1},calcMax:function(e){var t;return t=null,jQuery.each(e,function(e,n){if(t===null||n.count>t)return t=n.count}),t}},e.getAccounts(),window.cloud=e}).call(this);