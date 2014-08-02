function rla_json()
{
    # Cleanup function.
    function _rla_json_cleanup()
    {
        # Remove temp files.
        [[ -f temp.html ]] && rm temp.html
    }
    trap "_rla_json_cleanup" SIGINT SIGTERM EXIT

    # Start values.
    BASEURL="rla.localhost/app_dev.php"
    URL="${1:-achievement/1}"

    # Loop, waiting for input.
    while read n
    do 
        clear

        # If something was entered (as opposed to just pressing enter to
        # refresh), parse the new url out of it (if it's valid).
        if [[ -n $n ]]
        then
            NEWURL=$(echo $n | ruby -ruri -e 'puts URI.parse(gets.chomp).path' 2> /dev/null | sed 's/app.*\.php//' | sed 's/\/\//\//g')
            if [[ -z $NEWURL ]]
            then
                echo "Invalid url"
            else
                URL=$NEWURL
            fi
        fi

        # Create the full url.
        _URL=$(echo "$BASEURL/$URL" | sed 's/\/\//\//g' | sed 's/\/$//')

        # Remove temp files.
        _rla_json_cleanup

        # Get the page.
        output=$(curl -s -H "Accept: application/json" $_URL)
        
        # Check if the returned page is HTML or JSON.
        if [[ -n $(echo $output | grep '<html>' -i) ]]
        then
            echo "We got HTML instead of JSON, does the requested page ($_URL) support JSON?"
            echo "Output saved to temp.html"
            echo $output > temp.html
            continue
        fi

        # Check if the returned JSON is valid.
        if [[ -n $(echo $output | json_verify 1>/dev/null 2>&1) ]]
        then
            echo "Invalid JSON:"
            echo $output | json_verify
            continue
        fi

        #  $output the formatted json.
        echo $output | json_reformat
    done

    _rla_json_cleanup
}
