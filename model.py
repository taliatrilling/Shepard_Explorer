"""Database model and associated functions, as well as functions that generate data for testing purposes"""

from flask_sqlalchemy import SQLAlchemy 

from datetime import datetime

db = SQLAlchemy()

class User(db.Model):
	"""Information associated with a specific user"""

	__tablename__ = "users"

	user_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	username = db.Column(db.String(20), nullable=False, unique=True)
	# password --> need to implement with external library for security purposes
	joined_at = db.Column(db.DateTime, nullable=False)

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<User user_id=%s username=%s>" % (self.user_id, self.username))

class Character(db.Model):
	"""Information associated with a specific Shepard created by a specific user"""

	__tablename__ = "characters"

	char_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	user_id = db.Column(db.Integer, db.ForeignKey("users.user_id"), nullable=False)
	shep_background = db.Column(db.Enum("Spacer", "Colonist", "Earthborn", name="backgrounds"), nullable=False) 
	shep_psych_profile = db.Column(db.Enum("Sole Survivor", "War Hero", "Ruthless", name="profiles"), nullable=False) 
	shep_gender = db.Column(db.Enum("Female", "Male", "Nonbinary", name="genders"), nullable=False)
	shep_name = db.Column(db.String(20), nullable=False)
	reputation = db.Column(db.Enum("Paragon", "Renegade", "Paragade", name="reputations"), nullable=False) 
	player_class = db.Column(db.Enum("Engineer", "Infiltrator", "Soldier", "Biotic", "Sentinel", "Adept", name="player_classes"), nullable=False) 
	played_1 = db.Column(db.Boolean, nullable=False)
	played_2 = db.Column(db.Boolean, nullable=False)
	played_3 = db.Column(db.Boolean, nullable=False)

	user = db.relationship("User", backref="character")

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<Character char_id=%s user_id=%s shep_name=%s>" % (self.char_id, self.user_id, self.shep_name))

class Decision(db.Model):
	""" """

	__tablename__ = "decisions"

	decision_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	decision = db.Column(db.String(20), nullable=False, unique=True)
	associated_game = db.Column(db.Integer, nullable=False)

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<Decision decision_id=%s decision=%s>" % (self.decision_id, self.decision))

class Outcome(db.Model):
	""" """
	
	__tablename__ = "outcomes"

	outcome_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	decision_id = db.Column(db.Integer, db.ForeignKey("decisions.decision_id"), nullable=False)
	outcome = db.Column(db.String(20), nullable=False)

	decision = db.relationship("Decision", backref="outcome")

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<Outcome outcome_id=%s decision_id=%s outcome=%s>" % (self.outcome_id, self.decision_id, self.outcome))

class DecisionMade(db.Model):
	""" """

	__tablename__ = "decisionsmade"

	made_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	char_id = db.Column(db.Integer, db.ForeignKey("characters.char_id"), nullable=False)
	decision_id = db.Column(db.Integer, db.ForeignKey("decisions.decision_id"), nullable=False)
	outcome_id = db.Column(db.Integer, db.ForeignKey("outcomes.outcome_id"), nullable=False)

	character = db.relationship("Character", backref="decisionmade")
	decision = db.relationship("Decision", backref="decisionmade")
	outcome = db.relationship("Outcome", backref="decisionmade")

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<DecisionMade char_id=%s outcome_id=%s>" % (self.char_id, self.outcome_id))

class Squadmate(db.Model):
	""" """

	__tablename__ = "squadmates"
	
	squadmate_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	name = db.Column(db.String(10), nullable=False, unique=True)

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<Squadmate squadmate_id=%s name=%s>" % (self.squadmate, self.name))

class SquadOutcome(db.Model):
	""" """

	__tablename__ = "squadoutcomes"

	squad_outcome_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	squadmate_id = db.Column(db.Integer, db.ForeignKey("squadmates.squadmate_id"), nullable=False)
	char_id = db.Column(db.Integer, db.ForeignKey("characters.char_id"), nullable=False)
	status = db.Column(db.Enum("Alive", "Dead", name="status"), nullable=False)

	squadmate = db.relationship("Squadmate", backref="squadoutcome")
	character = db.relationship("Character", backref="squadoutcome")

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<SquadOutcome char_id=%s squadmate_id=%s>" % (self.char_id, self.squadmate_id))

def connect_to_db(app, uri="postgresql:///masseffect"):
	""" """

	app.config['SQLALCHEMY_DATABASE_URI'] = uri
	db.app = app
	db.init_app(app)

if __name__ == '__main__':
	from server import app
	connect_to_db(app)
	db.create_all()


