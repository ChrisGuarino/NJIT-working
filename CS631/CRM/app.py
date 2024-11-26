from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from models import db, Customer, Car, Sale, ServiceAppointment, ServiceRendered


app = Flask(__name__)

# Configure the database URI
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://username:password@localhost/car_dealership'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize the database
db.init_app(app)

# Create tables
with app.app_context():
    db.create_all()

# Home route
@app.route('/')
def home():
    return "Welcome to the Car Dealership Management System"

# Add a new car sale
@app.route('/sales', methods=['POST'])
def add_sale():
    data = request.get_json()
    # Extract sale details
    car_id = data.get('car_id')
    customer_id = data.get('customer_id')
    sold_price = data.get('sold_price')
    sale_date = data.get('sale_date')

    # Create a new sale
    sale = Sale(car_id=car_id, customer_id=customer_id, sold_price=sold_price, sale_date=sale_date)
    db.session.add(sale)
    db.session.commit()

    return jsonify({"message": "Sale added successfully", "sale_id": sale.id}), 201

# Schedule a service appointment
@app.route('/services', methods=['POST'])
def schedule_service():
    data = request.get_json()
    car_id = data.get('car_id')
    customer_id = data.get('customer_id')
    appointment_date = data.get('appointment_date')
    estimated_time = data.get('estimated_time')

    # Create a new service appointment
    service = ServiceAppointment(car_id=car_id, customer_id=customer_id,
                                  appointment_date=appointment_date, estimated_time=estimated_time)
    db.session.add(service)
    db.session.commit()

    return jsonify({"message": "Service scheduled successfully", "appointment_id": service.id}), 201

# Retrieve sales statistics
@app.route('/sales/stats', methods=['GET'])
def sales_stats():
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')

    # Query sales within the date range
    stats = db.session.query(
        Car.make, Car.model, Car.year, db.func.count(Sale.id), db.func.sum(Sale.sold_price)
    ).join(Sale).filter(Sale.sale_date.between(start_date, end_date)).group_by(Car.make, Car.model, Car.year).all()

    # Format the result
    results = [
        {"make": stat[0], "model": stat[1], "year": stat[2], "count": stat[3], "total_sales": stat[4]}
        for stat in stats
    ]

    return jsonify({"sales_statistics": results})

# List all cars
@app.route('/cars', methods=['GET'])
def list_cars():
    # Add logic to retrieve cars from the database (coming soon)
    return jsonify({"message": "List of cars retrieved"})

# List all customers
@app.route('/customers', methods=['GET'])
def list_customers():
    # Add logic to retrieve customers from the database (coming soon)
    return jsonify({"message": "List of customers retrieved"})

if __name__ == "__main__":
    app.run(debug=True)