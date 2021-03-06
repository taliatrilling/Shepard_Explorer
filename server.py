"""Server logic and routes"""

from flask import (Flask, render_template, redirect, request, session, flash, jsonify, url_for)

from model import User, Character, Decision, Outcome, DecisionMade, Squadmate, SquadOutcome, DecisionDescription, OutcomeDescription, connect_to_db, db

from jinja2 import StrictUndefined

from flask_debugtoolbar import DebugToolbarExtension

import os

from datetime import datetime

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

def check_outcome_valid_for_decision(outcome_id, decision_id):
	"""Check that an outcome being entered is a valid entry for the decision -- 
	function not to be used by user but by system to reduce errors"""

	outcomes = (Outcome.query.filter(Outcome.outcome_id == outcome_id).all()).decision_id
	if decision_id not in outcomes:
		return False
	return True


def add_outcome(user_id, char_id, decision_id, outcome_id):
	"""Add specific outcome associated with a decision for a specific character to the database, returns the
	generated object's id"""

	dm = DecisionMade(char_id=char_id, decision_id=decision_id, outcome_id=outcome_id)
	db.session.add(dm)
	db.session.commit()
	return dm.made_id

def get_id_for_outcome(outcome):
	"""Get db id for outcome"""

	return (Outcome.query.filter(Outcome.outcome == outcome).first()).outcome_id

def get_id_for_decision(decision):
	"""Get db id for decision"""

	return (Decision.query.filter(Decision.decision_id == decision_id).first()).decision_id

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
	#readiness stats/options taken from http://www.ign.com/wikis/mass-effect-3/Endings
	
	score = DecisionMade.query.filter(DecisionMade.made_id == made_id).first()
	if score.outcome.outcome == 1749:
		options = ["destroy", "refusal"]
	elif int(score.outcome.outcome) >= 2049 and int(score.outcome.outcome) <= 2799:
		options = ["destroy", "control", "refusal"]
	else:
		options = ["destroy", "control", "synthesis", "refusal"]
	return options 	

def determine_ending_effects(ending_made_id, score, char_id):
	"""For ending chosen, what to add to database/assume occured"""
	
	ending = DecisionMade.query.filter(DecisionMade.made_id == ending_made_id).first()
	earth_outcome_id = Decision.query.filter(Decision.decision == "fate of Earth").first()
	squad_outcome_id = Decision.query.filter(Decision.decision == "squad survival").first()
	if ending.outcome.outcome == "destroy":
		if int(score) <= 2049: 
			earth_status = DecisionMade(char_id=char_id, decision_id=earth_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "vaporized").first()).outcome_id)
			squad_status = DecisionMade(char_id=char_id, decision_id=squad_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "no survivors").first()).outcome_id)
		if int(score) >= 2349 and int(score) <= 2649:
			earth_status = DecisionMade(char_id=char_id, decision_id=earth_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "devastated").first()).outcome_id)
			squad_status = DecisionMade(char_id=char_id, decision_id=squad_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "survive").first()).outcome_id)
		if int(score) >= 2799:
			earth_status = DecisionMade(char_id=char_id, decision_id=earth_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "saved").first()).outcome_id)
			squad_status = DecisionMade(char_id=char_id, decision_id=squad_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "survive").first()).outcome_id)
	if ending.outcome.outcome == "control":
		if int(score) < 2649:
			earth_status = DecisionMade(char_id=char_id, decision_id=earth_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "devastated").first()).outcome_id)
			squad_status = DecisionMade(char_id=char_id, decision_id=squad_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "survive").first()).outcome_id)
		if int(score) >= 2649:
			earth_status = DecisionMade(char_id=char_id, decision_id=earth_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "saved").first()).outcome_id)
			squad_status = DecisionMade(char_id=char_id, decision_id=squad_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "survive").first()).outcome_id)
	if ending.outcome.outcome == "synthesis":
		earth_status = DecisionMade(char_id=char_id, decision_id=earth_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "saved").first()).outcome_id)
		squad_status = DecisionMade(char_id=char_id, decision_id=squad_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "survive synthesized").first()).outcome_id)
	if ending.outcome.outcome == "refusal":
		earth_status = DecisionMade(char_id=char_id, decision_id=earth_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "vaporized").first()).outcome_id)
		squad_status = DecisionMade(char_id=char_id, decision_id=squad_outcome_id, outcome_id=(Outcome.query.filter(Outcome.outcome == "no survivors").first()).outcome_id)
	db.session.add(earth_status)
	db.session.add(squad_status)
	db.session.commit()

def validate_user_creds(username, password):
	"""For a username/password combo, checks if hashed password matches db entry"""
	
	identity = User.query.filter(User.username == username).first()
	if identity:
		if User.validate_pword(identity, password):
			return (User.query.filter(User.username == username).first()).user_id
	return False

def get_games_played(char_id):
	"""For a given character in the database, check which games were played to allow the route to show options
	to update/add info"""

	char_entry = Character.query.filter(Character.char_id == char_id).first()
	games_needing_info = []
	if char_entry.played_1: 
		games_needing_info.append(1)
	if char_entry.played_2: 
		games_needing_info.append(2)
	if char_entry.played_3: 
		games_needing_info.append(3)
	return games_needing_info

def check_char_ownership(char_id, user_id):
	"""Checks a certain user has ownership of a character"""

	char = Character.query.filter(Character.char_id == char_id).first()
	if char.user_id != user_id:
		return False
	return True

def get_char_name(char_id):
	"""Gets character name from character id"""

	char = Character.query.filter(Character.char_id == char_id).first()
	return char.shep_name

def delete_char(char_id, user_id):
	"""If a user has ownership, deletes a character from the db"""

	if not check_char_ownership(char_id, user_id):
		return False
	char = char = Character.query.filter(Character.char_id == char_id).first()
	db.session.delete(char)
	db.session.commit()
	return True

def get_all_open_decisions_for_game(char_id, relevant_game_num):
	"""For a given character and game, get all decisions that still need to be made"""

	all_decisions = Decision.query.filter(Decision.associated_game == relevant_game_num).all()
	decisions_already_made = DecisionMade.query.filter(DecisionMade.char_id == char_id).all()
	to_check = [decision.decision_id for decision in decisions_already_made]
	open_decisions = []
	for decision in all_decisions:
		if decision.decision_id not in to_check:
			open_decisions.append(decision)
	return open_decisions

def get_decision_description(decision_id):
	"""For a decision, get its description"""
	
	return ((DecisionDescription.query.filter(DecisionDescription.decision_id == decision_id).first()).text)

def get_outcome_description(outcome_id):
	"""For an outcome, get its description"""
	
	return ((OutcomeDescription.query.filter(OutcomeDescription.outcome_id == outcome_id).first()).text)

def get_decision_summary_dict(char_id, game_num):
	"""For a given character and game, get the decisions, outcomes and related descriptions for displaying
	a character summary"""

	char_info = Character.query.filter(Character.char_id == char_id).all()
	eligible_decisions_obj = Decision.query.filter(Decision.associated_game == game_num).all()
	eligible = [decision.decision_id for decision in eligible_decisions_obj]
	decisions = DecisionMade.query.filter(DecisionMade.char_id == char_id, 
		DecisionMade.decision_id.in_(eligible)).all()
	summaries = {}
	for decision in decisions:
		for_summaries = {}
		for_summaries["decision_id"] = decision.decision_id
		for_summaries["outcome_id"] = decision.outcome_id
		for_summaries["decision_desc"] = get_decision_description(decision.decision_id)
		for_summaries["outcome_desc"] = get_outcome_description(decision.outcome_id)
		for_summaries["relevant_game_num"] = decision.decision.associated_game
		summaries[decision.decision.decision] = for_summaries
	return summaries

def get_decision_obj_from_decision_id(char_id, decision_id):
	"""Gets the actual decision made object from the id, so that can be updated in the db"""

	obj = DecisionMade.query.filter(DecisionMade.char_id == char_id, DecisionMade.decision_id == decision_id).first()
	return obj

@app.template_filter("get_desc")
def get_desc_for_template_form(outcome_id):
	"""Templating filter for get_outcome_description function, so that can be easily used in jinja2 template 
	for form purposes"""

	return get_outcome_description(outcome_id)

#route functions

@app.route("/")
def home():
	"""Homepage route"""

	return render_template("home.html")


@app.route("/register")
def register():
	"""Route to register a new user"""
	
	if "user_id" in session:
		flash("Please sign out before registering a new account")
		return redirect("/")
	return render_template("register.html")


@app.route("/registration-complete", methods=["POST"])
def register_complete():
	"""Adds new user to database with form information"""
	
	username = request.form.get("username")
	password = request.form.get("password")

	user_id = add_user(username, password)

	session["user_id"] = user_id
	flash("You have been successfully registered")
	return redirect("/")


@app.route("/login")
def login():
	"""Login form for already registered users"""

	if "user_id" in session:
		flash("Please log out if you would like to log in to another account")
		return redirect("/")
	return render_template("login.html")


@app.route("/logged-in", methods=["POST"])
def logged_in():
	"""Checks credentials and logs in user if valid"""

	username = request.form.get("username")
	password = request.form.get("password")

	user_id = validate_user_creds(username, password)

	if user_id:
		session["user_id"] = user_id
		flash("You have been successfully logged in")
		return redirect("/")
	flash("Your username or password is incorrect, please try again")
	return redirect("/login")


@app.route("/logout")
def log_out():
	"""Logs a current user out by deleting the session key/value"""

	del session["user_id"]
	flash("You have been logged out")
	return redirect("/")


@app.route("/new-char")
def add_new_char():
	"""Form with basics for adding an new character -- info that goes across all 3 games 
	plus which games were played"""

	if "user_id" in session:
		return render_template("new_char.html")
	else:
		flash("Please log in to add a character entry")
		return redirect("/")


@app.route("/char-added", methods=["POST"])
def char_added():
	"""Adds new character to database with basic info/games played"""

	if "user_id" not in session:
		flash("Please log in to add a character entry")
		return redirect("/")

	name = request.form.get("shep_name")
	gender = request.form.get("gender")
	background = request.form.get("background")
	psych = request.form.get("psych")
	rep = request.form.get("reputation")
	player_class = request.form.get("player_class")
	if request.form.get("1"):
		game1 = True
	else:
		game1 = False
	if request.form.get("2"):
		game2 = True
	else:
		game2 = False
	if request.form.get("3"):
		game3 = True
	else:
		game3 = False

	user_id = session["user_id"]

	char_id = add_character(user_id, background, 
		psych, gender, name, rep, player_class, game1, game2, game3)

	return redirect("/profile")

@app.route("/profile")
def profile():
	"""Displays current user's profile"""

	if "user_id" not in session:
		flash("Please log in or register to access your profile")
		return redirect("/")
	user_id = session["user_id"]
	user = User.query.filter(User.user_id == user_id).first()
	return render_template("profile.html", user=user)


@app.route("/char-management")
def char_management():
	"""Displays existing characters for a user, options to add a new character, update a character, or delete 
	a character"""

	if "user_id" not in session:
		flash("Please log in to manage characters")
		return redirect("/")
	user_id = session["user_id"]
	characters = Character.query.filter(Character.user_id == user_id).all()
	return render_template("char_management.html", characters=characters)


@app.route("/delete-char/<int:char_id>")
def delete_char_route(char_id):
	"""Checks if user has access, and if does, shows option to delete a character"""

	if "user_id" not in session:
		flash("Please log in to delete a character")
		return redirect("/")
	user_id = session["user_id"]
	if not check_char_ownership(char_id,user_id):
		flash("You do not have access to that character for deletion purposes")
		return redirect("/")
	char = Character.query.filter(Character.char_id == char_id).first()
	return render_template("delete_char.html", char=char)


@app.route("/delete-char-result", methods=["POST"])
def delete_char_result():
	"""Actually deletes a character from the db after permissions confirmed and user has initiated"""

	if "user_id" not in session:
		flash("Please log in to delete a character")
		return redirect("/")
	user_id = session["user_id"]
	char_id = request.form.get("char_id")
	if delete_char(char_id, user_id):
		flash("Your character was successfully deleted from the database.")
		return redirect("/char-management")
	flash("You do not have access to that character for deletion purposes")
	return redirect("/")


@app.route("/char-stats/<int:char_id>")
def char_stats(char_id):
	"""Displays existing stats for a character as well as options to update/add"""

	char = Character.query.filter(Character.char_id == char_id).first()
	if "user_id" not in session:
		flash("Please log in to edit a character")
		return redirect("/")
	user_id = session["user_id"]
	if user_id != char.user_id:
		flash("Your current account does not have access to editing this character")
		return redirect("/")
	if char.played_1:
		one = get_decision_summary_dict(char_id, 1)
		one_open = get_all_open_decisions_for_game(char_id, 1)
		one_desc = []
		for item in one_open:
			details = {}
			details["desc"] = get_decision_description(item.decision_id)
			details["options"] = get_possible_outcomes(item.decision_id)
			details["id"] = item.decision_id
			one_desc.append(details)
	else:
		one = []
		one_open = []
		one_desc = []
	if char.played_2:
		two = get_decision_summary_dict(char_id, 2)
		two_open = get_all_open_decisions_for_game(char_id, 2)
		two_desc = []
		for item in two_open:
			details = {}
			details["desc"] = get_decision_description(item.decision_id)
			details["options"] = get_possible_outcomes(item.decision_id)
			details["id"] = item.decision_id
			two_desc.append(details)
	else:
		two = []
		two_open = []
		two_desc = []
	if char.played_3:
		three = get_decision_summary_dict(char_id, 3)
		three_open = get_all_open_decisions_for_game(char_id, 3)
		three_desc = []
		for item in three_open:
			details = {}
			details["desc"] = get_decision_description(item.decision_id)
			details["options"] = get_possible_outcomes(item.decision_id)
			details["id"] = item.decision_id
			three_desc.append(details)
	else:
		three = []
		three_open = []
		three_desc = []

	#change template to make established decisions changable

	return render_template("char_stats.html", char=char, one=one, one_open=one_open, one_desc=one_desc, 
		two=two, two_open=two_open, two_desc=two_desc, three=three, three_open=three_open, three_desc=three_desc)


@app.route("/char/<int:char_id>")
def display_char(char_id):
	"""Shows info associated with a character without the option to change stats -- used to share character
	with friends or other users"""

	char = Character.query.filter(Character.char_id == char_id).first()
	if char.played_1:
		one = get_decision_summary_dict(char_id, 1)
	else:
		one = []
	if char.played_2:
		two = get_decision_summary_dict(char_id, 2)
	else:
		two = []
	if char.played_3:
		three = get_decision_summary_dict(char_id, 3)
	else:
		three = []

	return render_template("char.html", char=char, one=one, two=two, three=three)


@app.route("/add-char-stats/<int:char_id>", methods=["POST", "GET"])
def update_existing_char(char_id):
	"""Put new character info in DB, if the user is authorized -- distinction between
	this route, which adds info for decisions that weren't already specified, different
	route used for updating already defined decisions"""

	if request.method == "GET": 
		flash("This is not a valid use of this URL, please use character management to make changes to your characters.")
		return redirect("/")
	char = Character.query.filter(Character.char_id == char_id).first()
	if "user_id" not in session or char.user_id != session["user_id"]:
		flash("You do not have the authority to make changes to this character. If this is your character, please make sure you are logged into your account.")
		return redirect("/")
	r = request.form
	for dec in r:
		outcome = int(request.form.getlist(dec)[0])
		to_add = add_outcome(session["user_id"], char.char_id, dec, outcome)
		if to_add is None:
			flash("An error has occured, please try again")
			return redirect("/")
	flash("Your changes have been successfully made.")
	return redirect("/")

@app.route("/update-existing-dec/<int:char_id>/<int:decision_id>", methods=["POST", "GET"])
def change_existing_decision_for_char(char_id, decision_id):
	""" """

	if "user_id" not in session or char.user_id != session["user_id"]:
		flash("You do not have the authority to make changes to this character. If this is your character, please make sure you are logged into your account.")
		return redirect("/")
	if request.method == "GET":
		desc_of_changing = get_decision_description(decision_id)
		outcomes = get_possible_outcomes(decision_id)
		options = []
		for outcome in outcomes:
			options.append({outcome, get_outcome_description(outcome_id)})
		char_name = get_char_name(char_id)
		return render_template("update_decision.html", options=options, 
			desc_of_changing=desc_of_changing, char_name=char_name)
	dec_obj = get_decision_obj_from_decision_id(char_id, decision_id)
	dec_obj.outcome_id = request.form.get("chosen")
	db.session.commit()
	flash("You have successfully made updates to your character")
	return redirect("/char-stats/" + char_id)






## ADD CSRF TOKENS TO TEMPLATES WITH FORMS!


if __name__ == "__main__":
	app.debug = True
	connect_to_db(app)
	DebugToolbarExtension(app)
	app.run()


