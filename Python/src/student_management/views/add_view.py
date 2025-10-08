import flet as ft
from student_management.services import load_students, save_students
from datetime import datetime

def add_view(page: ft.Page):
    student_id_input = ft.TextField(label="Student ID")
    name_input = ft.TextField(label="Name")
    course_input = ft.TextField(label="Course")
    birthday_input = ft.TextField(label="Birthday (YYYY-MM-DD)")
    output = ft.Text()

    def add_student(e):
        students = load_students()
        sid = student_id_input.value.strip()
        name = name_input.value.strip()
        course = course_input.value.strip()
        birthday = birthday_input.value.strip()

        if not all([sid, name, course, birthday]):
            output.value = "Please fill in all fields."
            output.color = "red"
            page.update()
            return

        if sid in students:
            output.value = f"Student with ID {sid} already exists."
            output.color = "red"
            page.update()
            return

        try:
            datetime.strptime(birthday, "%Y-%m-%d")
        except ValueError:
            output.value = "Invalid birthday format. Use YYYY-MM-DD."
            output.color = "red"
            page.update()
            return

        students[sid] = {"name": name, "course": course, "birthday": birthday}
        save_students(students)
        page.snack_bar = ft.SnackBar(ft.Text(f"Student {name} added successfully!"))
        page.snack_bar.open = True
        page.go("/")

    content_column = ft.Column(
        [
            student_id_input,
            name_input,
            course_input,
            birthday_input,
            output,
            ft.ElevatedButton(text="Add", on_click=add_student, width=300, height=50),
        ],
        alignment=ft.MainAxisAlignment.CENTER,
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=15,
    )

    return ft.View(
        route="/add",
        appbar=ft.AppBar(
            title=ft.Text("Add Student"),
            center_title=True,
            leading=ft.IconButton(ft.Icons.ARROW_BACK, on_click=lambda e: page.go("/")),
        ),
        controls=[
            ft.SafeArea(content=content_column, expand=True)
        ],
    )