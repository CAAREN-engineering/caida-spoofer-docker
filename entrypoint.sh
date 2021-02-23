#!/bin/bash

LOG_FILE=/root/result.log

echo "=========================="
echo "Running the CAIDA spoofer test..."
echo "=========================="

# Create test results log file
touch $LOG_FILE

# provide command to launch shell inside the container
containerID=$(cat /proc/self/cgroup | head -n 1 | cut -d '/' -f3 | cut -b1-12)
echo "docker exec -it $containerID /bin/bash"


# Run spoofer
spoofer-prober -v -s1 -r1 -4 --no-tls > $LOG_FILE

# Parse results
URL_TEST_RESULT=$(tail -n 50 $LOG_FILE | grep 'https://spoofer.caida.org/report.php?sessionkey=' | tr -d ' ')
HOST_IP=$(curl -s https://ifconfig.me/ip)
whois_result=$(whois -h whois.cymru.com ${HOST_IP} | sed -n 2p)
HOST_AS=$(echo $whois_result | cut -d'|' -f 1)
HOST_ISP=$(echo $whois_result | cut -d'|' -f 3)

# Print results
echo "=========================="
echo "===== TEST FINISHED! ====="
echo "=========================="
result="HOST_IP:      $HOST_IP\n"
result+="HOST_AS:      $HOST_AS\n"
result+="HOST_ISP:     $HOST_ISP\n"
result+="URL_RESULT:   $URL_TEST_RESULT\n"
echo -ne $result

#sleep, so we can spend time in the container
echo "Sleeping for 900 seconds to play inside the container"
sleep 900
