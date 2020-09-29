#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# Copyright (c) 2020, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# This script is designed for Jamf Pro and does:
# 	- Creating temprory Wifi connection during enrollment
#
# Written by: 	Rob Potvin 			| Consulting Engineer @ Jamf
#				Mischa van der Bent	| Consulting Engineer @ Jamf
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 




# Hardcoded Wireless Variables (Best to use Parameter 4 and Parameter 5 within Jamf Pro)
wifissid=""
wifipassword=""

# Self destruct time for profile automatic removal
# Default set to 24 hours
# Examples | 24 hours = 86400 | 8 hours = 28800
timelimit="86400"

# Jamf Pro parameter value checks

if [[ "$4" != "" ]] && [[ "$wifissid" == "" ]]
then
	wifissid=$4
fi

if [[ "$5" != "" ]] && [[ "$wifipassword" == "" ]]
then
	wifipassword=$5
fi

createwifi(){
	cat > /tmp/wifi.mobileconfig <<EOF
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
		<key>DurationUntilRemoval</key>
		<integer>${timelimit}</integer>
		<key>PayloadContent</key>
		<array>
			<dict>
				<key>AutoJoin</key>
				<true/>
				<key>CaptiveBypass</key>
				<false/>
				<key>EncryptionType</key>
				<string>WPA</string>
				<key>HIDDEN_NETWORK</key>
				<false/>
				<key>IsHotspot</key>
				<false/>
				<key>Password</key>
				<string>${wifipassword}</string>
				<key>PayloadDescription</key>
				<string>Configures Wi-Fi settings</string>
				<key>PayloadDisplayName</key>
				<string>Wi-Fi</string>
				<key>PayloadIdentifier</key>
				<string>com.apple.wifi.managed.0F56A566-8009-4AA8-9AF2-5B1F81E004D0</string>
				<key>PayloadType</key>
				<string>com.apple.wifi.managed</string>
				<key>PayloadUUID</key>
				<string>0F56A566-8009-4AA8-9AF2-5B1F81E004D0</string>
				<key>PayloadVersion</key>
				<integer>1</integer>
				<key>ProxyType</key>
				<string>None</string>
				<key>SSID_STR</key>
				<string>${wifissid}</string>
			</dict>
		</array>
		<key>PayloadDisplayName</key>
		<string>Temp Wifi</string>
		<key>PayloadIdentifier</key>
		<string>com.xinca.eol</string>
		<key>PayloadOrganization</key>
		<string>Jamf</string>
		<key>PayloadRemovalDisallowed</key>
		<false/>
		<key>PayloadType</key>
		<string>Configuration</string>
		<key>PayloadUUID</key>
		<string>9A689DF1-575C-45E2-9F75-D7E3C079B908</string>
		<key>PayloadVersion</key>
		<integer>1</integer>
	</dict>
	</plist>
EOF
}

#Create wifi mobileconfig
createwifi
sleep 5

#load wifi
profiles install -path /tmp/wifi.mobileconfig
sleep 5