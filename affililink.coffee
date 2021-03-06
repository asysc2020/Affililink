###
*  Affililink v0.21
*  http://affililink.com
*  Created by Dean Barrow (http://deanbarrow.co.uk)
###

affililink = ->

  ### enter your affiliate codes below ###
  ebayCode = 'campaign': 0, 'country': ''
  universalCode = 'amazon.co.uk': 'tag=', 'amazon.com': 'tag=', 'amazon.de': 'tag=', 'amazon.fr': 'tag=', 'javari.co.uk': 'tag=', 'javari.de': 'tag=', 'javari.fr': 'tag=', 'amazonsupply.com': 'tag=', 'amazonwireless.com': 'tag=', 'endless.com': 'tag='
  options = 'replace_links': true, 'track_views': false, 'track_clicks': true

  ### DO NOT EDIT BELOW THIS LINE ###
  
  # track analytics
  track = ->
    # Google analytics
    if window.gat_ && window.gat_.getTracker_
      if options['track_clicks']
        url.setAttribute('onclick', "_gaq.push(['_trackEvent', 'Affililink', 'Click', "+url.href+"]);")
      if options['track_views']
        _gaq.push(['_trackEvent', 'Affililink', 'View', url.href])
    return true

  # ebay
  ebay = ->
    if ebayCode['campaign'] and ebayCode['country']
      ebayDomains = ['ebay.com.au', 'ebay.at', 'ebay.be', 'ebay.ca', 'ebay.ch', 'ebay.de', 'ebay.es', 'ebayanuncios.es', 'ebay.fr', 'ebay.ie', 'ebay.it', 'ebay.nl', 'ebay.co.uk', 'ebay.com', 'half.com']
      for ebayDomain in ebayDomains
        unless domain is ebayDomain or domain.substring(domain.length - ebayDomain.length - 1) is '.'+ebayDomain
          continue
          
        switch ebayCode['country']
          when 'AT'
            ebayCode['code'] = '5221-53469-19255-0'
          when 'AU'
            ebayCode['code'] = '705-53470-19255-0'
          when 'BE'
            ebayCode['code'] = '1553-53471-19255-0'
          when 'CA'
            ebayCode['code'] = '706-53473-19255-0'
          when 'CH'
            ebayCode['code'] = '5222-53480-19255-0'
          when 'DE'
            ebayCode['code'] = '707-53477-19255-0'
          when 'ES'
            ebayCode['code'] = '1185-53479-19255-0'
          when 'FR'
            ebayCode['code'] = '709-53476-19255-0'
          when 'IE'
            ebayCode['code'] = '5282-53468-19255-0'
          when 'IT'
            ebayCode['code'] = '724-53478-19255-0'
          when 'NL'
            ebayCode['code'] = '1346-53482-19255-0'
          when 'UK'
            ebayCode['code'] = '710-53481-19255-0'
          when 'US'
            ebayCode['code'] = '711-53200-19255-0'
        
        # replace their link
        if domain is 'rover.ebay.com'
          if options['replace_links']
            url.href = url.href.replace /campid=([0-9]+)/g, 'campid=' + ebayCode['campaign']
            url.href = url.href.replace /rover\/1\/([0-9\-]+)/g, 'rover/1/' + ebayCode['code']
            return true
          else return false
          
        if domain.substring(domain.length - 'half.com'.length) is 'half.com'
          ebayCode['code'] = '8971-56017-19255-0'

        url.href = 'http://rover.ebay.com/rover/1/' + ebayCode['code'] + '/1?ff3=4&pub=5574962087&toolid=10001&campid=' + ebayCode['campaign'] + '&customid=affililink&mpre=' + encodeURIComponent(url.href)
        return true
        
    
  # universal function for append to url style tag
  addTagToEnd = (links) ->
    for link, tag of links
      unless domain is link or domain.substring(domain.length - link.length - 1) is '.'+link
        continue
      
      unless link and tag then return false
      
      match = tag.match /([a-zA-Z0-9\-]+)=([a-zA-Z0-9\-]+)/
      unless match[2] then return false
      
      # if existing affiliate tag
      match2 = new RegExp(match[1] + '=([a-zA-Z0-9\-]+)')
      if url.href.search(match2) > -1
        if options['replace_links']
          url.href = url.href.replace match2, match[1] + '=' + match[2]
          return true
        else return false
      
      if url.href.substring(url.href.length, url.href.length - 1) is '/'
        url.href += '?' + match[1] + '=' + match[2]
        return true
 
      if url.href.match /(\?)/
        url.href += '&' + match[1] + '=' + match[2]
      else
        url.href += '/?' + match[1] + '=' + match[2]
    
      return true
  
  a = document.getElementsByTagName('a')
  host = window.location.hostname

  for url in a
    # filter internal links, mailto etc
    unless url.href.substring(0, 7) is 'http://' or url.href.substring(0, 8) is 'https://'
      continue
    domain = url.href.split("/")[2]
    unless domain
      continue
    else
      ebay()
      addTagToEnd (universalCode)
      track()

# run once page has loaded
if window.attachEvent
  window.attachEvent "onload", affililink
else
  if window.onload
    curronload = window.onload
    newonload = ->
      curronload
      affililink
    window.onload = newonload
  else
    window.onload = affililink
