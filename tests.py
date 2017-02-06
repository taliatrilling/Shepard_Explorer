from server import app
from model import User, Character, Decision, Outcome, DecisionMade, Squadmate, SquadOutcome, connect_to_db, db, make_test_data
import unittest
from flask_sqlalchemy import SQLAlchemy 
from flask import (Flask, render_template, redirect, request, session, flash, jsonify)
from passlib.hash import bcrypt

class LogicFunctionTestCases(unittest.TestCase):
	"""Tests logic/non-route server function"""

	def setUp(self):
		connect_to_db(app, "postgresql:///masseffecttest")
		db.create_all()
		make_test_data()

	def tearDown(self):
		db.session.close()
		db.drop_all()

#add route test case class (with and without session?)