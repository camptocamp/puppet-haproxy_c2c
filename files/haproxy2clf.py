#!/usr/bin/env python
# vim: set fileencoding=utf-8:

#
# Camptocamp SA
# FranÃÂ§ois Deppierraz <francois.deppierraz@camptocamp.com>
#
# Initial version: Thu Sep 25 19:18:01 CEST 2008

import sys
import re

FIELDS = ('process_name', 'pid', 'client_ip', 'client_port', 'date', 'listener_name', 'server_name', 'T', 'http_return_code', 'bytes_read', 'captured_request_cookie', 'captured_response_cookie', 'termination_state', 'actconn', 'feconn', 'beconn', 'srv_conn', 'retries', 'srv_queue', 'listener_queue', 'captured_request_headers', 'captured_response_headers', 'request')
PATIN  = '^\S+\s+\S+ \S+ \S+ (\S+)\[(\S+)\]: ([\.\d]+):(\d+) \[(\S+)\] (\S+) (\S+) (\S+)? (\S+)? (\S+)? (\S+)? (\S+)? (\S+)? (\S+)/(\S+)/(\S+)/(\S+)/(\S+) (\S+)/(\S+) (?:\{(\S+)\} )?(?:\{(\S+)\} )?"([^"]+)"'
PATOUT = '%(client_ip)s - - [%(date)s] "%(request)s" %(http_return_code)s %(bytes_read)s'

parse_errors = 0
bad_requests = 0
lines = 0
files = {}

try:
  directory = sys.argv[1]
except:
  print "Usage: %s directory < local2.log"
  sys.exit(1)

while 1:
  line = sys.stdin.readline()
  lines += 1

  if not line:
    break

  values = re.findall(PATIN, line)

  try:
    hash = dict(map(None, FIELDS, values[0]))
    if "<BADREQ>" in hash['request']:
      bad_requests += 1
      continue
    server = hash["server_name"].split("/")[0]
    hash["date"] = hash["date"].split('.')[:-1][0] + " +0200"
  except:
    #sys.stderr.write("Warning: cannot parse: \n" + PATIN + "\n" + line + "\n")
    parse_errors += 1
    continue
 
  if not files.has_key(server):
    files[server] = file("%s/%s.log" % (directory, server), "a")

  files[server].write(PATOUT % hash + "\n")

for f in files.values():
  f.close()

#sys.stderr.write("*****\n")
#sys.stderr.write("Parsed lines: %d\n" % lines)
#sys.stderr.write("Bad requests: %d\n" % bad_requests)
#sys.stderr.write("Parse errors: %d\n" % parse_errors)
#sys.stderr.write("*****\n")
