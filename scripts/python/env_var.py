#!/usr/bin/env python3
 
import sys
import os
import json

if (len(sys.argv)>2):

    ENV = sys.argv[1]
    VAR = sys.argv[2]
    ENV_PATH = str.replace(os.path.join(os.path.dirname(os.path.realpath(__file__))), "/scripts/python", "/env/%s" % (ENV,))

    def readFile(filename):
        with open(os.path.join(ENV_PATH, filename),'r') as f:
            return f.read()

    for f in os.listdir(ENV_PATH):
        if f.endswith('.json'):
            j = json.loads(readFile(f))
            if VAR in j:
                print(j[VAR])
                break
