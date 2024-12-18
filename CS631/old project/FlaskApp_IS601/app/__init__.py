from flask import Flask
from flaskext.mysql import MySQL
from pymysql.cursors import DictCursor

mysql = MySQL(cursorclass = DictCursor)
__all__ = ['init_app']

def init_app():
    app = Flask(__name__)

    #Initialize the Core Application
    app.config.from_object('config.Config')

    #Initialize the Plugins
    mysql.init_app(app)

    with app.app_context():
        #Routing
        import routes

        return app
