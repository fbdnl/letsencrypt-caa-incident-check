# Let's Encrypt CAA Incident Check
Bash script to search for domain(s) with or without TLD(s) that are affected by Let's Encrypt incident "2020.02.29 CAA Rechecking Bug".

In order to properly function, the script needs a "serials.txt" file to read into, which is the ungzipped version of the official list prvided by Let's Encrypt (available at https://letsencrypt.org/caaproblem).
