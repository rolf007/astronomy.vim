"This will get the sunrise and sunset times of a specific location. To be able
"to determine $l you need to first go to http://weather.yahoo.com/ and look up
"your location. The last numbers in the URL will be the $l
"Instead of forecastrss?w=$l you can also use forecastrss?p=$l and use the RSS
"link of the city you found.
"Also see http://developer.yahoo.com/weather/ for more information
"
"552299 is Birkeroed, Denmark

function! GetSun()
	if !exists("s:sun")
		let must_fetch = 0
		if filereadable('/tmp/sun')
			if len(system('find /tmp/sun -daystart -mtime -1')) == 0
				let must_fetch = 1
			endif
		else
			let must_fetch = 1
		endif
		if must_fetch
			call system('curl -s https://query.yahooapis.com/v1/public/yql?q=select\%20astronomy\%20from\%20weather.forecast\%20where\%20woeid\%20in\%20\(552299\)\&format=xml > /tmp/sun')
		endif

		let foo = readfile('/tmp/sun')
		if len(foo) < 2
			let s:sun = "?"
		else
			let matches = matchlist(foo[1], 'sunrise="\([0-9]\+\):\([0-9\+]\+\) \([ap]\)m".*sunset="\([0-9]\+\):\([0-9\+]\+\) \([ap]\)m"')
			let [m,h0,m0,ap0,h1,m1,ap1;rest] = matches
			if ap0 == 'p' | let h0 = h0 + 12 | endif
			if ap1 == 'p' | let h1 = h1 + 12 | endif
			let s:sun = printf("%d:%02d->%d:%02d",h0,m0,h1,m1)
		endif
	endif
	return s:sun
endfunction
"true
