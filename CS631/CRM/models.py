from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# Customer model
class Customer(db.Model):
    __tablename__ = 'customers'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    phone = db.Column(db.String(20), unique=True, nullable=False)
    address = db.Column(db.String(200), nullable=True)

# Car model
class Car(db.Model):
    __tablename__ = 'cars'
    id = db.Column(db.Integer, primary_key=True)
    make = db.Column(db.String(50), nullable=False)
    model = db.Column(db.String(50), nullable=False)
    year = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Float, nullable=False)

# Sale model
class Sale(db.Model):
    __tablename__ = 'sales'
    id = db.Column(db.Integer, primary_key=True)
    car_id = db.Column(db.Integer, db.ForeignKey('cars.id'), nullable=False)
    customer_id = db.Column(db.Integer, db.ForeignKey('customers.id'), nullable=False)
    sold_price = db.Column(db.Float, nullable=False)
    sale_date = db.Column(db.Date, nullable=False)

    car = db.relationship('Car', backref='sales')
    customer = db.relationship('Customer', backref='sales')

# ServiceAppointment model
class ServiceAppointment(db.Model):
    __tablename__ = 'service_appointments'
    id = db.Column(db.Integer, primary_key=True)
    car_id = db.Column(db.Integer, db.ForeignKey('cars.id'), nullable=False)
    customer_id = db.Column(db.Integer, db.ForeignKey('customers.id'), nullable=False)
    appointment_date = db.Column(db.DateTime, nullable=False)
    estimated_time = db.Column(db.Float, nullable=True)

    car = db.relationship('Car', backref='appointments')
    customer = db.relationship('Customer', backref='appointments')

# ServiceRendered model
class ServiceRendered(db.Model):
    __tablename__ = 'services_rendered'
    id = db.Column(db.Integer, primary_key=True)
    appointment_id = db.Column(db.Integer, db.ForeignKey('service_appointments.id'), nullable=False)
    service_details = db.Column(db.String(200), nullable=True)
    cost = db.Column(db.Float, nullable=False)

    appointment = db.relationship('ServiceAppointment', backref='services_rendered')
