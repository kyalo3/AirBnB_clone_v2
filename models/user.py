#!/usr/bin/python3
"""This module defines a class User"""
from models.base_model import BaseModel
from os import getenv
from sqlalchemy import Column, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship


Base = declarative_base()

class User(BaseModel, Base):
    """This class defines a user by various attributes"""
    if getenv('HBNB_TYPE_STORAGE') == 'db':
        __tablename__ = 'users'
        email = Column(String(128), nullable=False)
        password = Column(String(128), nullable=False)
        first_name = Column(String(128), nullable=True)
        last_name = Column(String(128), nullable=True)
        places = relationship('Place', cascade='all, delete-orphan', backref='user')
        reviews = relationship('Review', cascade='all, delete-orphan', backref='user')
    else:
        email = ''
        password = ''
        first_name = ''
        last_name = ''
