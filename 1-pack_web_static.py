#!/usr/bin/python3
from fabric.api import local
from datetime import datetime
"""A fabric script that compresses contents of webstatic folder"""


def do_pack():
	"""Generates a .tgz archive"""
	zip_name=f"web_static_{current_datetime.strftime('%Y%m%d%H%M%S')}.tgz"
	local("tar -czvf {zip_name} webstatic")
