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

def get_character_decision_made(char_id, decision):
	"""Get outcome for a certain character's decision"""

	d = DecisionMade.query.filter(DecisionMade.char_id == char_id, DecisionMade.decision_id == decision).first()
	return d.outcome_id

def get_possible_outcomes(decision):
	"""Get all possible outcomes to a certain decision"""

	possibilites = Outcome.query.filter(Outcome.decision_id == decision).all()
	return possibilites

#route functions

if __name__ == "__main__":
	app.debug = True
	connect_to_db(app)
	DebugToolbarExtension(app)
	app.run()


