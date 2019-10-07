#!/usr/bin/env -S run-in-asdf python utils python

import argparse
import contextlib
import http.cookiejar
import os
import os.path
import re
import time

import requests
from bs4 import BeautifulSoup


FAVORITES_URL = 'https://wallhaven.cc/favorites/{id}'
WALLPAPER_URL = 'https://w.wallhaven.cc/full/{server_id}/wallhaven-{id}.{ext}'
SERVER_ID_PATTERN = re.compile('/orig/([^/]+)/')
DEFAULT_EXTENSION = 'jpg'
EXTENSIONS = ['png']


def parse_args():
	parser = argparse.ArgumentParser(description = 'Download wallpapers from wallhaven favorites.')
	parser.add_argument('cookies', metavar = 'cookies.txt', help = 'The cookies.txt for an active user session.')
	parser.add_argument('path', help = 'The output path.')
	parser.add_argument('collection_id', nargs = '+', help = 'The id(s) of the collection(s) to download.')
	return parser.parse_args()


def get_wallpapers(soup):
	""" Get the full urls of all wallpaper image files from a page of thumbnails. """
	for thumnail in soup.find_all(class_ = 'thumb'):
		for ext in EXTENSIONS:
			if thumnail.find(class_ = ext):
				break
		else:
			ext = DEFAULT_EXTENSION

		id_ = thumnail['data-wallpaper-id']
		server_id = SERVER_ID_PATTERN.search(thumnail.img['data-src']).group(1)
		yield WALLPAPER_URL.format(server_id = server_id, id = id_, ext = ext)


def get_favorites(collection_id, cookies):
	""" Get the full urls of all wallpaper image files from a collection. """
	url = FAVORITES_URL.format(id = collection_id)
	print(f'Grabbing wallpapers urls from {url}')
	response = requests.get(url, cookies = cookies)
	soup = BeautifulSoup(response.text, 'lxml')
	yield from get_wallpapers(soup)

	num_pages_section = soup.find('header', class_ = 'thumb-listing-page-header')
	if num_pages_section is not None:
		for page_num in range(2, int(num_pages_section.text.split('/')[-1]) + 1):
			print(f'Grabbing wallpapers urls from {url} (page {page_num})')
			response = requests.get(url, params = { 'page': page_num }, cookies = cookies)
			soup = BeautifulSoup(response.text, 'lxml')
			yield from get_wallpapers(soup)


def download_wallpapers(download_dir, urls, cookies):
	""" Download the given wallpapers. """
	count = len(urls)
	for i, url in enumerate(urls, start = 1):
		filename = url.rpartition('/')[-1]
		path = os.path.join(download_dir, filename)

		if os.path.exists(path):
			continue

		print(f'\rDownloading wallpaper {i}/{count}: {url}', end = '')
		response = requests.get(url, cookies = cookies)
		with open(path, 'wb') as image:
			image.write(response.content)
		time.sleep(1)


def main():
	args = parse_args()

	cookies = http.cookiejar.MozillaCookieJar(args.cookies)
	cookies.load()

	with contextlib.suppress(FileExistsError):
		os.mkdir(args.path)

	for collection_id in args.collection_id:
		print(f'Downloading collection {collection_id}.')
		urls = list(get_favorites(collection_id, cookies))
		print()
		download_wallpapers(args.path, urls, cookies)


if __name__ == '__main__':
	main()
