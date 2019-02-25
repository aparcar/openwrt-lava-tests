#!/usr/bin/env python3
#
# License: MIT
# 2019 Alexander Couzens <lynxis@fe80.eu>

import argparse
import json
import yaml

def convert(yaml_fh, output_fh, name,
            metadata=None,
            image_url=None):
    doc = yaml_fh.read()
    if image_url:
        doc = doc.replace('IMAGE_URL', image_url)

    parsed = yaml.load(doc)

    if metadata:
        if 'metadata' not in parsed:
            parsed['metadata'] = {}

        for k, v in metadata.items():
            parsed['metadata'][k] = v

    parsed['job_name'] = name

    output_fh.write(yaml.dump(parsed))

def parse_metadata(args):
    """
    parse and process all meta data arguments
    """
    metadata = {}

    if args.meta:
        for meta in args.meta:
            try:
                key, value = meta.split()
                metadata[key] = value
            except ValueError:
                raise RuntimeError("Can not parse argument 'meta %s'" % meta)

    if args.metafile:
        for meta in args.metafile:
            metadata.update(json.load(meta))

    return metadata

def main():
    parser = argparse.ArgumentParser(prog='create-lava-job')
    parser.add_argument('--name', help='The job name', required=True)
    parser.add_argument('--output',
            help='The output file for the generated job',
            type=argparse.FileType('w'),
            required=True)
    parser.add_argument('--template',
            help='The input template for the generated job. E.g. device.yml',
            type=argparse.FileType('r'),
            required=True)
    parser.add_argument('--metafile', help='a json file', type=argparse.FileType('r'), nargs='*')
    parser.add_argument('--meta', help='a key=value to extend meta data', nargs='*')
    parser.add_argument('--image', help='Optional image url. Will replace IMAGE_URL in the template.')
    args = parser.parse_args()

    metadata = parse_metadata(args)
    convert(args.template, args.output, args.name, metadata, args.image)

if __name__ == "__main__":
    main()
