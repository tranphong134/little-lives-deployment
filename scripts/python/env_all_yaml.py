#!/usr/bin/env python3
 
import sys
import os
import json
import yaml

if (len(sys.argv)>1):

    ENV = sys.argv[1]
    ENV_PATH = str.replace(os.path.join(os.path.dirname(os.path.realpath(__file__))), "/scripts/python", "/env/%s" % (ENV,))

    out = {}

    def readFile(filename):
        with open(os.path.join(ENV_PATH, filename),'r') as f:
            return f.read()

    for f in os.listdir(ENV_PATH):
        if f.endswith(".json"):
            print(" - %s" % (f,))
            out.update(json.loads(readFile(f)))
        
    y = yaml.dump(out, encoding=('utf-8')).decode("utf-8")
    p = os.path.join(ENV_PATH, '.env.yaml')
    with open(p, 'w') as writer:
        writer.write(y)
        print(" --> %s" % (p,))

    