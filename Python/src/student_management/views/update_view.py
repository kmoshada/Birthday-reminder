import flet as ft
from student_management.services import load_students, save_students
from datetime import datetime

def update_view(page: ft.Page):
    student_id_input = ft.TextField(label="Student ID")
    name_input = ft.TextField(label="New Name", visible=False)
    course_input = ft.TextField(label="New Course", visible=False)
    birthday_input = ft.TextField(label="New Birthday (YYYY-MM-DD)", visible=False)
    output = ft.Text()
    
    def update_student(e):
        students = load_students()
        sid = student_id_input.value.strip()
        new_name = name_input.value.strip()
        new_course = course_input.value.strip()
        new_birthday = birthday_input.value.strip()

        if not all([new_name, new_course, new_birthday]):
            output.value = "Please fill in all fields."
            output.color = "red"
            page.update()
            return

        try:
            datetime.strptime(new_birthday, "%Y-%m-%d")
        except ValueError:
            output.value = "Invalid birthday format. Use YYYY-MM-DD."
            output.color = "red"
            page.update()
            return

        if sid in students:
            students[sid]["name"] = new_name
            students[sid]["course"] = new_course
            students[sid]["birthday"] = new_birthday
            save_students(students)
            output.value = "Student updated successfully!"
            output.color = "green"
        else:
            output.value = "Student not found."
            output.color = "red"
        page.update()

    update_button = ft.ElevatedButton(text="Update", on_click=update_student, width=300, height=50, visible=False)

    def find_student_for_update(e):
        students = load_students()
        sid = student_id_input.value.strip()
        if sid in students:
            st = students[sid]
            name_input.value = st['name']
            course_input.value = st['course']
            birthday_input.value = st['birthday']
            name_input.visible = True
            course_input.visible = True
            birthday_input.visible = True
            update_button.visible = True
            output.value = ""
        else:
            output.value = "Student not found."
            output.color = "red"
            name_input.visible = False
            course_input.visible = False
            birthday_input.visible = False
            update_button.visible = False
        page.update()

    content_column = ft.Column(
        [
            ft.Row(
                [
                    student_id_input,
                    ft.ElevatedButton(text="Find", on_click=find_student_for_update),
                ],
                alignment=ft.MainAxisAlignment.CENTER,
            ),
            name_input,
            course_input,
            birthday_input,
            output,
            update_button,
        ],
        alignment=ft.MainAxisAlignment.CENTER,
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=15,
    )

    return ft.View(
        route="/update",
        appbar=ft.AppBar(
            title=ft.Text("Update Student"),
            center_title=True,
            leading=ft.IconButton(ft.Icons.ARROW_BACK, on_click=lambda e: page.go("/")),
        ),
        controls=[
            ft.SafeArea(content=content_column, expand=True)
        ],
    )