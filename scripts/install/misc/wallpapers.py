#!/usr/bin/env nix-shell
#!nix-shell -i python
#!nix-shell -p python310
#!nix-shell -p python310Packages.requests

import argparse
import contextlib
import http.cookiejar
import os
import os.path
import re
import time

import requests


COLLECTIONS_ENDPOINT = 'https://wallhaven.cc/api/v1/collections/{username}'
COLLECTION_CONTENTS_ENDPOINT = 'https://wallhaven.cc/api/v1/collections/{collection.username}/{collection.id}'
APIKEY_ARG = 'apikey'


class Collection(object):
	def __init__(self, username, _id):
		self.username = username
		self.id = _id

	@classmethod
	def parse(cls, as_string):
		parts = as_string.split('/')
		if len(parts) != 2:
			raise argparse.ArgumentTypeError(
				f"Not a valid collection id: '{collection}', must be in form username/collection_id.",
			)
		return cls(*parts)

	def __str__(self):
		return f'{self.username}/{self.id}'


def parse_args():
	parser = argparse.ArgumentParser(description = 'Download wallpapers from wallhaven favorites.')
	parser.add_argument(
		'-a', '--api-key',
		metavar = 'api_key',
		help = 'The API key. Find it at https://wallhaven.cc/settings/account.',
	)
	subparsers = parser.add_subparsers(metavar = 'subcommand', required = True)

	sparser = subparsers.add_parser(
		'list-collections',
		aliases = ('ls', 'list'),
		help = 'List all collections (favorites) of a given user.',
	)
	sparser.add_argument('username', help = 'The name of the user to list the collections of.')
	sparser.set_defaults(func = list_collections)

	sparser = subparsers.add_parser(
		'download-collections',
		aliases = ('dl', 'download'),
		help = 'Download all wallpapers in one or more collection(s).',
	)
	sparser.add_argument('path', help = 'The output path.')
	sparser.add_argument(
		'collection',
		nargs = '+',
		type = Collection.parse,
		help = 'The id(s) of the collection(s) to download.',
	)
	sparser.set_defaults(func = download_collections)

	return parser.parse_args()


def format_url(url, args, **kwargs):
	fargs = dict(args._get_kwargs())
	fargs.update(kwargs)
	url = url.format(**fargs)
	if args.api_key:
		url = f'{url}?{APIKEY_ARG}={args.api_key}'
	return url


def api(url):
	response = requests.get(url)
	json = response.json()
	data = json.get('data', None)
	if not data:
		raise Exception(json['error'])
	return data


def list_collections(args):
	data = api(format_url(COLLECTIONS_ENDPOINT, args))
	for collection in data:
		print('{username}/{id}: {label}'.format(username = args.username, **collection))


def download_collections(args):
	with contextlib.suppress(FileExistsError):
		os.makedirs(args.path)

	urls = []
	for collection in args.collection:
		print(f'Grabbing URLs for collection {collection}.')
		data = api(format_url(COLLECTION_CONTENTS_ENDPOINT, args, collection = collection))
		urls += [w['path'] for w in data if 'path' in w]

	count = len(urls)
	for i, url in enumerate(urls, start = 1):
		filename = url.rpartition('/')[-1]
		path = os.path.join(args.path, filename)

		if os.path.exists(path):
			continue

		print(f'\rDownloading wallpaper {i}/{count}: {url}', end = '')
		response = requests.get(url)
		with open(path, 'wb') as image:
			image.write(response.content)

		time.sleep(0.5)


def main():
	args = parse_args()
	args.func(args)


if __name__ == '__main__':
	main()
