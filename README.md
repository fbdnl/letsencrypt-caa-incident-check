# Let's Encrypt CAA Incident Check
Bash script to search for domain(s) with or without TLD(s) that are affected by Let's Encrypt incident "2020.02.29 CAA Rechecking Bug".

In order to properly function, the script will download and unzip the official archive provided by Let's Encrypt containing all the serial numbers to be checked (available at https://letsencrypt.org/caaproblem). If you wish to download it manually, simply place a file called "serials.db" in the same dir as the script.
