#Instructions: automate download of Google Drive files by shared link
#Instructions Source: https://stackoverflow.com/questions/25010369/wget-curl-large-file-from-google-drive
#
#The easy way:
#1. Go to the Google Drive webpage that has the download link
#2. Open your browser console and go to the "network" tab
#3. Click the download link
#4. Wait for it the file to start downloading, and find the corresponding request (should be the last one in the list), then you can cancel the download
#5. Right click on the request and click "Copy as cURL" (or similar)
#
#You should end up with something like:
#curl 'https://doc-0s-80-docs.googleusercontent.com/docs/securesc/aa51s66fhf9273i....................blah blah blah...............gEIqZ3KAQ==' --compressed
#Past it in your console, add > my-file-name.extension to the end (otherwise it will write the file into your console), then press enter :)
#
#NOTE: add --insecure flag to curl command to avoid download failure related to no certificates installed on current terminal session
#
#
if [ ! -d "output" ]; then	#Only proceed if directory do NOT exists
	#Download zip file	
  curl --insecure 'https://doc-08-bs-docs.googleusercontent.com/docs/securesc/8fu69g2eb9k8r0uvoh791prm247jug1u/9l7dtrg0bepau7f3h0qnounfdpv9cibd/1560960000000/17030387196731929750/17030387196731929750/1XteAYNoKe_WCgcqi2u11W8uc9GrQFIug?e=download&nonce=e2vpipki0encm&user=17030387196731929750&hash=jf5h0llrbbaoqkp5a0lhr6qlvrjmtgbt' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H 'X-Client-Data: CIa2yQEIprbJAQjBtskBCKmdygEIqKPKAQixp8oBCOKoygEI8anKAQjNrcoBCJ6uygE=' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7' -H 'Cookie: AUTH_klvd8s94rra2n5h4s8ul2f3jj6cq9cka_nonce=e2vpipki0encm' --compressed  > output.zip
  
  #Only proceed if zip file has been downloaded successfully and is not empty
	if [ -f "output.zip" ] && [ $(stat -c %b output.zip) != 0 ]; then	
		unzip output.zip	#Extract zip contents
		rm output.zip  		#Remove zip file
		echo "downloadOutputFolder script log: contents downlaoded and extracted successfully"
	else
		echo "downloadOutputFolder script log: ERROR: unable to download zip file"
	fi
else
	echo "downloadOutputFolder script log: output folder located. Skipping download attempt"
fi
