import csv  # Use this to read the csv file


def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by the db_file

    Parameters
    ----------
    Connection
    """
    return sqlite3.connect(db_file)
    pass


def update_employee_salaries(conn, increase):
    """
    Parameters
    ----------
    conn: Connection
    increase: float
    """
    cur = conn.cursor()
    update = ((100+increase)/100)
    sql_command = """ UPDATE ConstructorEmployee SET SalaryPerDay = SalaryPerDay * ?
    WHERE ConstructorEmployee.EID = (SELECT ConstructorEmployeeOverFifty.EID FROM ConstructorEmployeeOverFifty)
        """
    return cur.execute(sql_command, (update,))
    pass


def get_employee_total_salary(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    int
    """
    cur = conn.cursor()
    sql_command = """ 
    SELECT SUM(SalaryPerDay) FROM ConstructorEmployee
    """
    return cur.execute(sql_command).fetchone()[0]
    pass


def get_total_projects_budget(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    float
    """
    cur = conn.cursor()
    sql_command = """
      SELECT SUM (Budget)
      from Project
      """
    return cur.execute(sql_command).fetchone()[0]
    pass


def calculate_income_from_parking(conn, year):
    """
    Parameters
    ----------
    conn: Connection
    year: int

    Returns
    -------
    float
    """
    cur = conn.cursor()
    sql_command = "SELECT SUM(Cost) FROM CarParking WHERE strftime('%Y', StartTime) = ?"
    return cur.execute(sql_command,(year,)).fetchone()[0]
    pass


def get_most_profitable_parking_areas(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    list[tuple]

    """
    cur = conn.cursor()
    sql_command = """  
     select AID ParkingAreaID, SUM(cost) Income
     from CarParking
     group by (AID)
     order by SUM(cost) DESC, AID DESC LIMIT 5;
    """
    return cur.execute(sql_command).fetchall()
    pass


def get_number_of_distinct_cars_by_area(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    list[tuple]

    """
    cur = conn.cursor()
    sql_command = """ 
       select ParkingArea.AID, COUNT(DISTINCT CarParking.CID) as DistinctCarsNumber
       from CarParking , ParkingArea WHERE CarParking.AID = ParkingArea.AID
       group by ParkingArea.AID
       order by DistinctCarsNumber DESC
    """
    return  cur.execute(sql_command).fetchall()
    pass


def add_employee(conn, eid, firstname, lastname, birthdate, street_name, number, door, city):
    """
    Parameters
    ----------
    conn: Connection
    eid: int
    firstname: str
    lastname: str
    birthdate: datetime
    street_name: str
    number: int
    door: int
    city: str
    """
    cur = conn.cursor()
    cur.execute('INSERT INTO [Employee] VALUES (?,?,?,?,?,?,?,?)', (eid, firstname, lastname, birthdate, street_name, number, door, city))
    conn.commit()
    pass


def load_neighborhoods(conn, csv_path):
    """

    Parameters
    ----------
    conn: Connection
    csv_path: str
    """
    cur = conn.cursor()
    csv_excel = open(csv_path)
    for row in csv_excel:
        cur.execute("INSERT INTO [Neighborhood] ([NID], [Name]) VALUES (?, ?)", (row[0], row[2:]))
    pass
