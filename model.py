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

class MassEffect1(db.Model):
	"""Information associated with a single Mass Effect playthrough by a user"""

	__tablename__ = "onesies"

	char_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	user_id = db.Column(db.Integer, db.ForeignKey("users.user_id"), nullable=False)
	shep_background = db.Column(db.String(4), nullable=False) #spcr, coln, or erth 
	shep_psych_profile = db.Column(db.String(4), nullable=False) #warh, sole, or ruth
	shep_gender = db.Column(db.String(1), nullable=False) #M, F, N (non binary)
	shep_name = db.Column(db.String(20), nullable=False)
	romanced = db.Column(db.String(1), nullable=False) #K, L, A, or N for None
	player_class = db.Column(db.String(3), nullable=False) #Eng, Inf, Sol, Bio, Sen, Adp
	virmire_survivor = db.Column(db.String(1), nullable=False) #K or A
	reputation = db.Column(db.String(1), nullable=False) #P, R, N for neither
	rachni_queen_spared = db.Column(db.Boolean, nullable=False)
	shiala_alive = db.Column(db.Boolean, nullable=False)
	wrex_alive = db.Column(db.Boolean, nullable=False)
	council_saved = db.Column(db.Boolean, nullable=False)
	
	user = db.relationship("User", backref="masseffect1")

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<ME1 char_id=%s user_id=%s shep_name=%s>" % (self.char_id, self.user_id, self.shep_name))

class MassEffect2(db.Model):
	"""Information associated with a single Mass Effect 2 playthrough by a user"""

	__tablename__ = "twosies"

	char_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	user_id = db.Column(db.Integer, db.ForeignKey("users.user_id"), nullable=False)
	shep_gender = db.Column(db.String(1), nullable=False) #M, F, N (non binary)
	shep_name = db.Column(db.String(20), nullable=False)
	romanced = db.Column(db.String(3), nullable=False) #Mir, Tal, Jak, Jcb, Gar, Thn, Nan
	reputation = db.Column(db.String(1), nullable=False) #P, R, N for neither
	player_class = db.Column(db.String(3), nullable=False) #Eng, Inf, Sol, Bio, Sen, Adp
	genophage_research_saved = db.Column(db.Boolean) #can be null, mission is optional
	crew_dead_from_collectors = db.Column(db.Integer, nullable=False) #0 = none, 1 = half, 2 = all but chakwas
	survivors_escorted_by_loyal = db.Column(db.Boolean, nullable=False)
	collector_base_destroyed = db.Column(db.Boolean, nullable=False)
	mordin_loyal = db.Column(db.Boolean, nullable=False)
	mordin_dead = db.Column(db.Boolean, nullable=False)
	tali_recruited = db.Column(db.Boolean, nullable=False)
	tali_loyal = db.Column(db.Boolean) #if she's not recruited, N/A
	tali_dead = db.Column(db.Boolean) #if she's not recruited, status unknown
	kasumi_recruited = db.Column(db.Boolean, nullable=False)
	kasumi_loyal = db.Column(db.Boolean) #if she's not recruited, N/A
	kasumi_dead	= db.Column(db.Boolean) #if she's not recruited, status unknown
	jack_loyal = db.Column(db.Boolean, nullable=False)
	jack_dead = db.Column(db.Boolean, nullable=False)
	miranda_loyal = db.Column(db.Boolean, nullable=False)
	miranda_dead = db.Column(db.Boolean, nullable=False)
	jacob_loyal = db.Column(db.Boolean, nullable=False)
	jacob_dead = db.Column(db.Boolean, nullable=False)
	garrus_loyal = db.Column(db.Boolean, nullable=False)
	garrus_dead = db.Column(db.Boolean, nullable=False)
	samara_recruited = db.Column(db.Boolean, nullable=False)
	morinth_chosen = db.Column(db.Boolean) #if she's not recruited, N/A
	sam_mor_loyal = db.Column(db.Boolean) #if she's not recruited, N/A
	sam_mor_dead = db.Column(db.Boolean) #if she's not recruited, status unknown
	legion_activated = db.Column(db.Boolean) #if she's not recruited, status unknown
	legion_loyal = db.Column(db.Boolean) #if he's not recruited, N/A
	legion_dead = db.Column(db.Boolean) #if he's not recruited, status unknown
	thane_recruited = db.Column(db.Boolean, nullable=False)
	thane_loyal = db.Column(db.Boolean) #if he's not recruited, N/A
	thane_dead = db.Column(db.Boolean) #if he's not recruited, status unknown
	zaeed_recruited = db.Column(db.Boolean, nullable=False)
	zaeed_loyal = db.Column(db.Boolean) #if he's not recruited, N/A
	zaeed_dead = db.Column(db.Boolean) #if he's not recruited, status unknown
	grunt_activated = db.Column(db.Boolean, nullable=False)
	grunt_loyal = db.Column(db.Boolean) #if he's not recruited, N/A
	grunt_dead = db.Column(db.Boolean) #if he's not recruited, status unknown
	suicide_mission_success = db.Column(db.Boolean, nullable=False) #not enough crew members survive, Shepard bites the bucket

	user = db.relationship("User", backref="masseffect2")

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<ME2 char_id=%s user_id=%s shep_name=%s>" % (self.char_id, self.user_id, self.shep_name))

class MassEffect3(db.Model):
	"""Information associated with a single Mass Effect 3 playthrough by a user"""

	__tablename__ = "threesies"

	char_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	user_id = db.Column(db.Integer, db.ForeignKey("users.user_id"), nullable=False)
	shep_gender = db.Column(db.String(1), nullable=False) #M, F, N (non binary)
	shep_name = db.Column(db.String(20), nullable=False)
	romanced = db.Column(db.String(3), nullable=False) #Mir, Tal, Jak, Jcb, Gar, Ash, Stv, Sam, Kai, Lia, Nan
	reputation = db.Column(db.String(1), nullable=False) #P, R, N for neither
	player_class = db.Column(db.String(3), nullable=False) #Eng, Inf, Sol, Bio, Sen, Adp
	allers_recruited = db.Column(db.Boolean, nullable=False)
	grissom_saved = db.Column(db.Boolean, nullable=False)
	krogan_team_sacrificed = db.Column(db.Boolean, nullable=False)
	samara_saved = db.Column(db.Boolean) #n/a if she doesn't make it to the third game, so nullable
	kelly_survives = db.Column(db.Boolean) #n/a if she doesn't make it to the third game, so nullable
	cure_sabotaged = db.Column(db.Boolean, nullable=False)
	geth_quarian_outcome = db.Column(db.String(4), nullable=False) #geth, quar, both
	illusive_man_convinced = db.Column(db.Boolean, nullable=False)
	final_war_readiness db.Column(db.Integer, nullable=False) 
	final_outcome = db.Column(db.String(3), nullable=False) #Des, Syn, Con, Ref --> options autolimited by code based on inputed readiness
	fate_of_earth = db.Column(db.String(4), nullable=False) #Dest, Deva, Safe --> autogenerated by code based on inputed readiness
	squad_survives = db.Column(db.Boolean, nullable=False) # --> autogenerated by code based on inputed readiness

	user = db.relationship("User", backref="masseffect3")

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<ME3 char_id=%s user_id=%s shep_name=%s>" % (self.char_id, self.user_id, self.shep_name))


class LinkedPlaythroughChars(db.Model):
	"""Information associated with one triad or duo of linked playthroughs by one user"""

	__tablename__ = "playthroughs"

	playthrough_id = db.Column(db.Integer, autoincrement=True, primary_key=True, nullable=False)
	user_id = db.Column(db.Integer, db.ForeignKey("users.user_id"), nullable=False)
	games_played = db.Column(db.Integer, nullable=False) #100, 110, 111, 010, 011, 001
	char1_id = db.Column(db.Integer, db.ForeignKey("onesies.char_id"), nullable=True) #nullable because game may be skipped
	char2_id = db.Column(db.Integer, db.ForeignKey("twosies.char_id"), nullable=True) #nullable because game may be skipped
	char3_id = db.Column(db.Integer, db.ForeignKey("threesies.char_id"), nullable=True) #nullable because game may be skipped

	user = db.relationship("User", backref="playthrough")
	masseffect1 = db.relationship("MassEffect1", backref="playthrough")
	masseffect2 = db.relationship("MassEffect2", backref="playthrough")
	masseffect3 = db.relationship("MassEffect3", backref="playthrough")

	def __repr__(self):
		"""Provides helpful information on an instance when printed"""

		return ("<Playthrough playthrough_id=%s user_id=%s>" % (self.playthrough_id, self.user_id))
	


