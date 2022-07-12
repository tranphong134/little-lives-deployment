#!/usr/bin/env python3
 
import sys
import json

# Not proper json so jq fails
if (len(sys.argv)==2):

    j = json.loads(sys.argv[1])
    print(j["value"])

    