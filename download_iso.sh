export PVNB_IMG="http://cdimage.debian.org/debian-cd/8.3.0/i386/iso-cd/debian-8.3.0-i386-netinst.iso"

progressfilt ()
{
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%c' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}

echo "=> Downloading debian image"
wget --show-progress --progress=bar:force $PVNB_IMG 2>&1 | progressfilt
