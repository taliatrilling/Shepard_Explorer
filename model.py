"""Database model and associated functions, as well as functions that generate data for testing purposes"""

from flask_sqlalchemy import SQLAlchemy 

from datetime import datetime

db = SQLAlchemy()

class Game(db.Model):
	"""Information associated with a specific video game"""

	__tablename__ = "games"

	# cross reference with API to make sure columns make sense
	game_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	genres = db.Column(ARRAY(db.String(10)), nullable=False)
	available_platforms = db.Column(ARRAY(db.String(10)), nullable=False)

	#add repr

class User(db.Model):
	"""Information associated with a specific user"""

	__tablename__ = "users"

	user_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	username = db.Column(db.String(20), nullable=False, unique=True)
	# password --> need to implement with external library for security purposes
	joined_at = db.Column(db.DateTime, nullable=False)

	#add repr


class Review(db.Model):
	"""Review associated with a specific user and a specific game"""

	__tablename__ = "reviews"

	review_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	game_id = db.Column(db.Integer, db.ForeignKey("users.user_id"), nullable=False)
	user_id = db.Column(db.Integer, db.ForeignKey("games.game_id"), nullable=False)
	score = db.Column(db.Integer, nullable=False)
	review_text = db.Column(db.String(40), nullable=False)
	#^ I wasn't sure how long to make review text, so I based my choice on https://blog.bufferapp.com/optimal-length-social-media 
	reviewed_at = db.Column(db.DateTime, nullable=False)

	user = db.relationship("User", backref="reviews")
	game = db.relationship("Game", backref="reviews")


	#add repr


