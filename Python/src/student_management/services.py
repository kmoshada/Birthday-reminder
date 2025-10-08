import json, os, shutil
from datetime import datetime
from .models import Student

# Construct the absolute path for students.json
# The services.py script is in student_management/, and students.json is in the parent directory
_current_dir = os.path.dirname(os.path.abspath(__file__))
DATA_FILE = os.path.join(os.path.dirname(_current_dir), "students.json")


def load_students() -> dict:
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, "r") as file:
            try:
                return json.load(file)
            except json.JSONDecodeError:
                return {}
    return {}


def save_students(students: dict):
    with open(DATA_FILE, "w") as file:
        json.dump(students, file, indent=4)


def import_students(file_path: str) -> tuple[bool, str]:
    try:
        with open(file_path, "r") as f:
            data = json.load(f)
        if not isinstance(data, dict):
            return False, "Invalid file format: not a JSON object."
        if os.path.exists(DATA_FILE):
            shutil.copy(DATA_FILE, DATA_FILE + ".bak")
        with open(DATA_FILE, "w") as f:
            json.dump(data, f, indent=4)
        return True, f"✅ Imported successfully from {os.path.basename(file_path)}"
    except FileNotFoundError:
        return False, "❌ File not found."
    except json.JSONDecodeError:
        return False, "❌ Invalid JSON format."
    except IOError as e:
        return False, f"❌ An error occurred: {e}"


def get_today_birthdays() -> list[Student]:
    students = load_students()
    today = datetime.now().strftime("%m-%d")
    birthdays = []
    for sid, student in students.items():
        try:
            if datetime.strptime(student.get("birthday", ""), "%Y-%m-%d").strftime("%m-%d") == today:
                birthdays.append(Student.from_dict(sid, student))
        except ValueError:
            continue
    return birthdays


def get_upcoming_birthdays(days: int = 7) -> list[tuple[Student, str]]:
    students = load_students()
    today = datetime.now()
    upcoming = []
    for sid, student in students.items():
        try:
            bday = datetime.strptime(student.get("birthday", ""), "%Y-%m-%d")
            bday_this_year = bday.replace(year=today.year)
            if bday_this_year < today:
                bday_this_year = bday_this_year.replace(year=today.year + 1)
            delta = (bday_this_year - today).days
            if 1 <= delta <= days:
                upcoming.append((Student.from_dict(sid, student), bday_this_year.strftime("%Y-%m-%d")))
        except ValueError:
            continue
    return upcoming