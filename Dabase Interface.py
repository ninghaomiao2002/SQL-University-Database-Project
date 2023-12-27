import mysql.connector
from tkinter import Tk, Label
from tkinter.ttk import Treeview

def perform_search(query):
    connection = mysql.connector.connect(host=host, user=user, password=password, database=database)
    cursor = connection.cursor()
    cursor.execute(query)
    results = cursor.fetchall()
    window = Tk()
    window.title("Searched Data")
    label = Label(window, text="Searched Data", font=("Arial", 16))
    label.pack()
    columns = [desc[0] for desc in cursor.description]
    tree = Treeview(window, columns=columns, show="headings")
    for col in columns:
        tree.heading(col, text=col, anchor="center")
        tree.column(col, width=200, anchor="center")
    for row in results:
        tree.insert("", "end", values=row)
    tree.pack()
    cursor.close()
    connection.close()

host = "localhost"
user = "administrator "
password = "passwordadministrator"
database = "university_system"

while True:
    search_input = input("Please let me know what command you need?\n"
                         "1 for getting student modules table\n"
                         "2 for getting student timetable\n"
                         "3 for getting Student Tutor Appointment\n"
                         "4 for getting Lecturer Timetable\n"
                         "Type 'exit' to quit or type any command to use MySql\n")

    if search_input.lower() == 'exit':
        break

    if search_input == "1":
        search_query = "SELECT * FROM `Student Modules Table`;"
    elif search_input == "2":
        search_query = "SELECT * FROM `Student General Timetable`;"
    elif search_input == "3":
        search_query = "SELECT * FROM `Student Tutor Appointment`;"
    elif search_input == "4":
        search_query = "SELECT * FROM `Lecturer Timetable`;"
    else:
        search_query = search_input
    perform_search(search_query)