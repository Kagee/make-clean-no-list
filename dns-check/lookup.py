#!/usr/bin/python2
# -*- coding: utf-8 -*-

import sys
import dns  
from dns.exception import DNSException
from dns.rdataclass import *
from dns.rdatatype import *
from dns.message import *
from dns.query import *
import dns.resolver
import random

def get_no_ns():
	a = dns.resolver.query("no.", "NS")
	for x in a.response.answer[0]:
		b = dns.resolver.query(
			x.to_text(), "A")
		for y in b.response.answer[0]:
			yield y.to_text()

def normal(domain, ns, recursive = True):
	query = dns.message.make_query(
		domain, 
		dns.rdatatype.NS, 
		dns.rdataclass.IN)

	if not recursive:
		query.flags ^= dns.flags.RD

	resp = dns.query.udp(query, ns)
	exists = False
	if (resp.rcode() == dns.rcode.NOERROR 
		and len(resp.answer) >= 1) or
		(resp.rcode() == dns.rcode.SERVFAIL 
		and len(resp.authority) >= 1):
		exists = True
		
	return exists, len(resp.answer), len(resp.authority), dns.rcode.to_text(resp.rcode())

def servfail(domain, ns):
        query = dns.message.make_query(
                domain,
                dns.rdatatype.NS,
                dns.rdataclass.IN)
 	query.flags ^= dns.flags.RD
        resp = dns.query.udp(query, 
			random.choice(ns))
	print resp.authority
        return len(resp.answer), dns.rcode.to_text(resp.rcode())

if len(sys.argv) < 2: # or (sys.argv[2] not in ["normal", "servfail"]):
  print "Usage: %s inputfile" % (sys.argv[0],)
  sys.exit(1)



no_nameservers = list(get_no_ns())
with open(sys.argv[1],'r') as inputfile:
  for line in inputfile:
    domain = line.strip()
    #if sys.argv[2] == "normal":
    exists, len_answ, len_auth, rcode = normal(domain, "8.8.8.8")
    #else:
    #len_answ, rcode = servfail(domain, no_nameservers)
    print "%s;%s;%s" % (domain, rcode, len_answ)
