# Shepard Explorer -- Overview of WIP:

  - Personal project in Python/Flask with the goal of exploring the most effective way to interface with a large and dynamic database that needs to store multitudes of user choices while recognizing that each user may vary in the extent that they are able or willing to report game outcomes
  - Secondary goal of experimenting with AngularJS to build the frontend as well as ChartJS to allow for users to interact with gameplay metrics
  - Currently, the application requires users to self-report outcomes on a large scale, but potential for future integration with PC save files/save editors to capture user decisions without needing self-report data

# Installation 

Until the application is completed and deployed via Heroku, you may experiment with the code by following the steps below (requires [pip](https://pypi.python.org/pypi/pip), [virtualenv](https://pypi.python.org/pypi/virtualenv), and [PostgreSQL](https://www.postgresql.org/)):

```sh
$ git clone https://github.com/taliatrilling/Shepard_Explorer
$ cd Shepard_Explorer
$ virtualenv env
$ source env/bin/activate
$ pip install -r requirements.txt
$ touch secret_test.sh
$ echo "export SECRET_KEY='test'" > secret_test.sh
$ source secret_test.sh
$ createdb masseffect
$ psql masseffect < masseffect.sql
$ python server.py
```
Finally, navigate your browser to http://localhost:5000/

# About Me

I am a graduate of Pitzer College as well as Hackbright Academy working in the San Francisco Bay Area as a software engineer. My unique academic background in psychology research and media studies allows me to bring a multidisciplinary perspective to any project, and I love discovering new and unique ways to interact with technology. Please feel free to reach out to me with any questions you may have about my work.
[LinkedIn](http://www.linkedin.com/in/taliatrilling)
[Personal Website](http://taliatrilling.github.io)
