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
# 	- mimic the quickadd pkg when the pkg can't be used
#
# Written by: 	Rob Potvin 		| Consulting Engineer @ Jamf
#		Mischa van der Bent	| Consulting Engineer @ Jamf
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

inviteID=""
jamfproURL=""

jamfinstall(){
	/usr/bin/curl -ks ${jamfproURL}/bin/jamf -o /tmp/jamf
	/bin/mkdir -p /usr/local/jamf/bin /usr/local/bin
	/bin/mv /tmp/jamf /usr/local/jamf/bin
	/bin/chmod +x /usr/local/jamf/bin/jamf
	/bin/ln -s /usr/local/jamf/bin/jamf /usr/local/bin
	/usr/local/jamf/bin/jamf createConf -url ${jamfproURL} -verifySSLCert always
	/usr/local/jamf/bin/jamf enroll -invitation ${inviteID}
}

jss(){
	curl -ks ${jamfproURL}/bin/SelfService.tar.gz -o /tmp/SelfService.tar.gz
	/bin/rm -rf "/Applications/Self Service.app"
	sleep 1
	tar -xzf /tmp/SelfService.tar.gz -C /Applications
	defaults write /Library/Preferences/com.jamfsoftware.jamf.plist self_service_app_path "/Applications/Self Service.app"
}

jamfinstall
jss

/usr/local/jamf/bin/jamf policy
