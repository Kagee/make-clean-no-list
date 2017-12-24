
Replaced by the [MCN](https://github.com/search?q=user%3AKagee+mcn+in%3Aname&type=Repositories) (make clean no)-projects.

# What are in the different folders:
* sources
 * Different sources that when <source>/list_domains is called will
   list all domains for this source
 * alexa
   * All .no domains in Alexa top 1m
   * All domains in Alexa top 1m with TLD replaced with .no
 * enhetsregisteret
   * All domains found in enhetsregisteret
 * permutate
   * Permutations of all two- and three-letter valid domains
   
* utils

* dns-checker

* scraper
 * regexp_dotno
   - Regexp for extraction .no domains from messy text
 * test:regexo
   - Tests for regexp_dotno
 * get_norid_cat_domains
   - Script that will download and parse the list of Norid
     category domains
