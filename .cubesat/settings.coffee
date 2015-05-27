#!/usr/bin/env coffee

exports.Settings = 
packages: "isaac:cubesat"
mongo_url: process.env.MONGO_URL
google:
	maps:
		url: "https://maps.googleapis.com/maps/api/js"
		options:
			query:
				key: process.env.GOOGLE_MAPS_KEY
	map_input:
		url: "https://maps.googleapis.com/maps/api/js"
		options:
			query:
				v: "3.exp"
				signed_in: "true"
				libraries: "places"
facebook:
	oauth:
		version: 'v2.3'
		url: "https://www.facebook.com/dialog/oauth"
		options:
			query:
				client_id: process.env.FACEBOOK_CLIENT_ID 
				redirect_uri: 'http://localhost:3000/home'
		secret:    process.env.FACEBOOK_SECRET 
		client_id: process.env.FACEBOOK_CLIENT_ID 

uber:
	oauth:
		url: "https://login.uber.com/oauth/authorize"
		options:
			query:
				scope:         "profile history_lite"
				client_id:     process.env.UBER_CLIENT_ID
				redirect_uri:  "https://www.getber.com/submit"
				response_type: "token"
	profile:
		meteor_method: "uber_profile"
		method: "GET"
		url: "https://api.uber.com/v1/me"
		options:
			headers:
				Authorization: "Bearer {token}"
whitepages:
	phone:
		meteor_method: "whitepages_phone"
		method: "GET"
		url: "https://proapi.whitepages.com/2.1/phone.json"
		options:
			params:
				api_key: process.env.WHITEPAGES_API_KEY
				phone_number: "{phone}"
