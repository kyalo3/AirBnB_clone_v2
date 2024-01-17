#!/usr/bin/python3
from fabric.api import local
from datetime import datetime
import os
"""A fabric script that compresses contents of webstatic folder"""


def do_pack():
	"""Generates a .tgz archive"""
	try:
	    ""
		local("mkdir -p versions")
		zip_name=f"versions/web_static_{current_datetime.strftime('%Y%m%d%H%M%S')}.tgz"
		local(f"tar -czvf {zip_name} webstatic")
		return zip_name
	except Exception as e:
		return None
