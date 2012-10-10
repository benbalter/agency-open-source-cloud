cloud = {
    
    #social media registry
    account_query: 'http://registry.usa.gov/accounts.json?service_id=github&agency_id=&tag=&callback=?'
    
    #URL to query GitHub API to retreive repos
    repo_query: 'https://api.github.com/users/%s/repos?callback=?'
    
    #max size
    max_size: 3
    min_size: .1
    
    #data store
    counts: []

    #ul element selector
    ul: '#tags'
    
    #show counts
    show_counts: true
        
    render: ->
        cloud.min = cloud.calcMin cloud.counts
        cloud.max = cloud.calcMax cloud.counts
        denominator = Math.log( parseInt( cloud.max ) ) - Math.log( parseInt( cloud.min ) )
        logMin = Math.log( cloud.min )
        jQuery.each( cloud.counts, ( key, agency ) ->
            weight = ( Math.log( agency.count ) - logMin ) / denominator
            size = cloud.min_size + ( cloud.max_size - cloud.min_size ) * weight
            li = '<li class="tag" style="font-size:' + size + 'em">' + agency.agency
            
            if cloud.show_counts
                li += '<span class="count">(' + agency.count + ')</span> '
            
            li += '</li>'
            jQuery(cloud.ul).append( li )
            
        )
        
    
    getAccounts: ->
        jQuery.getJSON( cloud.account_query, (accounts) ->
            cloud.getRepos accounts.accounts
        )
        
    getRepos: (accounts) -> 
       jQuery.each( accounts, (key, agency ) ->
            jQuery.getJSON( cloud.repo_query.replace( '%s', agency.account ), (data) ->
                object = { agency: agency.organization, count: data.data.length }
                cloud.counts.push object

                #last iteration
                if key == accounts.length - 1
                    cloud.render()
 
            )
       ) 
        
    calcMin: (array) ->
        min = null
        jQuery.each( array, (key,obj)->
            if min == null or obj.count < min
                min = obj.count
        )
        min || 1
        
    calcMax:  (array) ->
        max = null
        jQuery.each( array, (key,obj)->
            if max == null or obj.count > max
                max = obj.count
        )    
        max

}

cloud.getAccounts()
window.cloud = cloud