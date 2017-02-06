"""Server logic and routes"""

from flask import (Flask, render_template, redirect, request, session, flash, jsonify, url_for)

from model import User, Character, Decision, Outcome, DecisionMade, Squadmate, SquadOutcome, connect_to_db, db

from jinja2 import StrictUndefined

from flask_debugtoolbar import DebugToolbarExtension

import os

app = Flask(__name__)

app.secret_key = os.environ["SECRET_KEY"]

#so that error raised if jinja tries to reference an undefined variable
app.jinja_env.undefined = StrictUndefined
#so that app autoreloads in debug mode (specification needed because of above)
app.jinja_env.auto_reload = True

#logic functions

def add_user(username, password):
	"""Adds new user to database, returns that user's id"""

	user = User(username=username, password=password, joined_at=datetime.now())
	db.session.add(user)
	db.session.commit()
	user_id = user.user_id
	return user_id

def add_character(user_id, background, profile, gender, name, reputation, pclass, played1, played2, played3):
	"""Adds a user's new character to database, returns the new char_id"""

	character = Character(user_id=user_id, shep_background=background, shep_psych_profile=profile, 
		shep_gender=gender, shep_name=name, reputation=reputation, player_class=pclass, played_1=played1, 
		played_2=played2, played_3=played3)
	db.session.add(character)
	db.session.commit()
	return character.char_id


def add_outcome(user_id, char_id, decision, outcome):
	"""Add specific outcome associated with a decision for a specific character to the database, returns the
	generated object's id"""

	dm = DecisionMade(char_id=char_id, decision_id=decision, outcome_id=outcome)
	db.session.add(dm)
	db.session.commit()
	return dm.made_id

def add_squadmate_status(char_id, squadmate_id, status_code):
	"""Add a specific squadmate status for a specific character"""

	status = SquadOutcome(squadmate_id=squadmate_id, char_id=char_id, status=status_code)
	db.session.add(status)
	db.session.commit()
	return status.squad_outcome_id

def get_character_decision_made(char_id, decision):
	"""Get outcome for a certain character's decision"""

	d = DecisionMade.query.filter(DecisionMade.char_id == char_id, DecisionMade.decision_id == decision).first()
	return d.outcome_id

def get_possible_outcomes(decision):
	"""Get all possible outcomes to a certain decision"""

	possibilites = Outcome.query.filter(Outcome.decision_id == decision).all()
	return possibilites

def get_squadmate_status(char_id, squadmate_id):
	"""Get the squadmate status for a specific character/squadmate"""

	status = SquadOutcome.query.filter(SquadOutcome.char_id == char_id, SquadOutcome.squadmate_id == squadmate_id).first()
	return status.status

def determine_ending_options(made_id):
	"""Get possible endings for given war readiness"""
	#readiness options taken from http://www.ign.com/wikis/mass-effect-3/Endings because I only ever had max readiness...
	
	score = DecisionMade.query.filter(DecisionMade.made_id == made_id).first()
	if score.outcome.outcome == 1749:
		options = ["destroy", "refusal"]
	elif int(score.outcome.outcome) >= 2049 and int(score.outcome.outcome) <= 2799):
		options = ["destroy", "control", "refusal"]
	else:
		options = ["destroy", "control", "synthesis", "refusal"]
	return options 	

def determine_ending_effects(ending_made_id, score, char_id):
	"""For ending chosen, what to add to database/assume occured"""
	
	ending = DecisionMade.query.filter(DecisionMade.made_id == ending_made_id).first()
	if ending.outcome.outcome == "destroy":
		if int(score) <= 2049:
			earth_status = DecisionMade(char_id=char_id, decision_id=24, outcome_id=71)
			squad_status = DecisionMade(char_id=char_id, decision_id=25, outcome_id=74)
		if int(score) >= 2349 and int(score) <= 2649:
			earth_status = DecisionMade(char_id=char_id, decision_id=24, outcome_id=72)
			squad_status = DecisionMade(char_id=char_id, decision_id=25, outcome_id=75)
		if int(score) >= 2799:
			earth_status = DecisionMade(char_id=char_id, decision_id=24, outcome_id=73)
			squad_status = DecisionMade(char_id=char_id, decision_id=25, outcome_id=75)
	if ending.outcome.outcome == "control":
		if int(score) < 2649:
			earth_status = DecisionMade(char_id=char_id, decision_id=24, outcome_id=72)
			squad_status = DecisionMade(char_id=char_id, decision_id=25, outcome_id=75)
		if int(score) >= 2649:
			earth_status = DecisionMade(char_id=char_id, decision_id=24, outcome_id=73)
			squad_status = DecisionMade(char_id=char_id, decision_id=25, outcome_id=75)
	if ending.outcome.outcome == "synthesis":
		earth_status = DecisionMade(char_id=char_id, decision_id=24, outcome_id=73)
		squad_status = DecisionMade(char_id=char_id, decision_id=25, outcome_id=76)
	if ending.outcome.outcome == "refusal":
		earth_status = DecisionMade(char_id=char_id, decision_id=24, outcome_id=71)
		squad_status = DecisionMade(char_id=char_id, decision_id=25, outcome_id=74)
	db.session.add(earth_status)
	db.session.add(squad_status)
	db.session.commit()

#route functions

if __name__ == "__main__":
	app.debug = True
	connect_to_db(app)
	DebugToolbarExtension(app)
	app.run()


