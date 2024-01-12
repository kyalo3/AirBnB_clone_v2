#!/usr/bin/python3
""" Place Module for HBNB project """
from models.base_model import BaseModel, Base
from models.amenity import Amenity
from sqlalchemy import Column, Integer, String, Float, ForeignKey, Table
from sqlalchemy.orm import relationship
from os import getenv


class Place(BaseModel, Base):
    """ A place to stay """
    __tablename__ = 'places'
    city_id = Column(String(60), ForeignKey('cities.id'), nullable=False)
    user_id = Column(String(60), ForeignKey('users.id'), nullable=False)
    name = Column(String(128), nullable=False)
    description = Column(String(1024), nullable=True)
    number_rooms = Column(Integer, default=0, nullable=False)
    number_bathrooms = Column(Integer, default=0, nullable=False)
    max_guest = Column(Integer, default=0, nullable=False)
    price_by_night = Column(Integer, default=0, nullable=False)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    reviews = relationship("Review", backref="place",
                           cascade="all, delete-orphan")

    @property
    def reviews(self):
        """Getter attribute that returns the list of Review instances"""
        return (
            [review for review in self.reviews if review.place_id == self.id])
    
    place_amenity = Table(
        'place_amenity', Base.metadata,
        Column('place_id', String(60), ForeignKey('places.id'), primary_key=True),
        Column('amenity_id', String(60), ForeignKey('amenities.id'), primary_key=True)
    )

    if getenv('HBNB_TYPE_STORAGE') == 'db':
        amenities = relationship("Amenity", secondary=place_amenity,
                             backref="places", viewonly=False)
    else:
        amenity_ids = []

        @property
        def amenities(self):
            """Getter attribute for amenities (file storage)"""
            from models.amenity import Amenity
            amenities = []
            for amenity_id in self.amenity_ids:
                amenity = Amenity.query.get(amenity_id)
                if amenity:
                    amenities.append(amenity)
            return amenities
        
        @amenities.setter
        def amenities(self, new_amenities):
            """Setter attribute for amenities (file storage)"""
            if isinstance(new_amenities, Amenity):
                self.amenity_ids.append(new_amenities.id)
            else:
                pass
