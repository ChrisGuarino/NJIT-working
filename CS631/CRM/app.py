from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# Configure the database URI
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgresqlJ1ggyb0t5@localhost/car_dealership'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize SQLAlchemy
db = SQLAlchemy(app)

# Home route
@app.route('/')
def home():
    return "Welcome to the Car Dealership Management System"

# Add a new car purchase
@app.route('/purchases', methods=['POST'])
def add_purchase():
    data = request.get_json()
    customer_id = data.get('customer_id')
    car_id = data.get('car_id')
    cost = data.get('cost')

    try:
        # Insert into Purchase table
        sql = """
            INSERT INTO Purchase (CustomerID, CarID, Cost)
            VALUES (%s, %s, %s) RETURNING PurchaseID;
        """
        result = db.session.execute(sql, (customer_id, car_id, cost))
        db.session.commit()

        purchase_id = result.fetchone()[0]

        # Optionally, insert into Made_Purchase table if necessary
        # Assuming Made_Purchase is used to link customers to purchases (though it's redundant here)
        # sql_made_purchase = """
        #     INSERT INTO Made_Purchase (CustomerID, PurchaseID)
        #     VALUES (%s, %s);
        # """
        # db.session.execute(sql_made_purchase, (customer_id, purchase_id))
        # db.session.commit()

        return jsonify({"message": "Purchase added successfully", "purchase_id": purchase_id}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

# Schedule a service appointment
@app.route('/appointments', methods=['POST'])
def schedule_appointment():
    data = request.get_json()
    customer_id = data.get('customer_id')
    start_time = data.get('start_time')  # Expecting time in HH:MM:SS format
    date = data.get('date')              # Expecting date in YYYY-MM-DD format
    time_slot = data.get('time_slot')    # E.g., 'Morning', 'Afternoon'

    try:
        # Insert into Appointment table
        sql = """
            INSERT INTO Appointment (CustomerID, Start_Time, Date, Time_Slot)
            VALUES (%s, %s, %s, %s) RETURNING AppointmentID;
        """
        result = db.session.execute(sql, (customer_id, start_time, date, time_slot))
        db.session.commit()

        appointment_id = result.fetchone()[0]
        return jsonify({"message": "Appointment scheduled successfully", "appointment_id": appointment_id}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

# Retrieve sales statistics
@app.route('/purchases/stats', methods=['GET'])
def purchase_stats():
    start_date = request.args.get('start_date')  # Expected format: 'YYYY-MM-DD'
    end_date = request.args.get('end_date')      # Expected format: 'YYYY-MM-DD'

    try:
        sql = """
            SELECT ci.Make, ci.Model, ci.Year, COUNT(p.PurchaseID) AS total_purchases, SUM(p.Cost) AS total_revenue
            FROM Purchase p
            JOIN Cars_in_Inventory ci ON ci.CarID = p.CarID
            WHERE p.PurchaseID IN (
                SELECT PurchaseID FROM Purchase WHERE Date BETWEEN %s AND %s
            )
            GROUP BY ci.Make, ci.Model, ci.Year;
        """
        result = db.session.execute(sql, (start_date, end_date)).fetchall()

        # Format the result
        results = [
            {"make": row[0], "model": row[1], "year": row[2], "total_purchases": row[3], "total_revenue": row[4]}
            for row in result
        ]

        return jsonify({"purchase_statistics": results})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# List all cars in inventory
@app.route('/cars', methods=['GET'])
def list_cars():
    try:
        sql = "SELECT CarID, Make, Model, Year, Color FROM Cars_in_Inventory;"
        result = db.session.execute(sql).fetchall()

        cars = [
            {"car_id": row[0], "make": row[1], "model": row[2], "year": row[3], "color": row[4]}
            for row in result
        ]

        return jsonify({"cars": cars})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

# List all customers
@app.route('/customers', methods=['GET'])
def list_customers():
    try:
        sql = "SELECT CustomerID, Name, Email, Address FROM Customer;"
        result = db.session.execute(sql).fetchall()

        customers = [
            {"customer_id": row[0], "name": row[1], "email": row[2], "address": row[3]}
            for row in result
        ]

        return jsonify({"customers": customers})
    except Exception as e:
        return jsonify({"error": str(e)}), 400

if __name__ == "__main__":
    app.run(debug=True)
