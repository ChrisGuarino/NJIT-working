from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Configure the database URI
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://username:password@localhost/car_dealership'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize SQLAlchemy
db = SQLAlchemy(app)

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

    # Add logic to save to the database (coming soon)
    return jsonify({"message": "Car sale added successfully", "data": data}), 201

# Schedule a service appointment
@app.route('/services', methods=['POST'])
def schedule_service():
    data = request.get_json()
    car_id = data.get('car_id')
    customer_id = data.get('customer_id')
    appointment_date = data.get('appointment_date')
    estimated_time = data.get('estimated_time')

    # Add logic to save to the database (coming soon)
    return jsonify({"message": "Service scheduled successfully", "data": data}), 201

# Retrieve sales statistics
@app.route('/sales/stats', methods=['GET'])
def sales_stats():
    start_date = request.args.get('start_date')
    end_date = request.args.get('end_date')

    # Add logic to query the database for statistics (coming soon)
    return jsonify({"message": "Sales stats retrieved", "start_date": start_date, "end_date": end_date})

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