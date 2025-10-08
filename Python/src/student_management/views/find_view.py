import flet as ft
from student_management.services import load_students, save_students

def find_view(page: ft.Page):
    student_id_input = ft.TextField(label="Student ID")
    output = ft.Text()
    
    def yes_delete(e):
        students = load_students()
        sid = student_id_input.value.strip()
        if sid in students:
            del students[sid]
            save_students(students)
            output.value = f"Student {sid} deleted successfully."
            output.color = "green"
            delete_button.visible = False
        
        confirm_dialog.open = False
        page.update()

    def no_delete(e):
        confirm_dialog.open = False
        page.update()

    confirm_dialog = ft.AlertDialog(
        modal=True,
        title=ft.Text("Please confirm"),
        content=ft.Text("Do you really want to delete this student?"),
        actions=[
            ft.TextButton("Yes", on_click=yes_delete),
            ft.TextButton("No", on_click=no_delete),
        ],
        actions_alignment=ft.MainAxisAlignment.END,
    )

    def delete_student(e):
        page.dialog = confirm_dialog
        confirm_dialog.open = True
        page.update()

    delete_button = ft.ElevatedButton(text="Delete", on_click=delete_student, width=300, height=50, color="white", bgcolor="red", visible=False)

    def find_student(e):
        students = load_students()
        sid = student_id_input.value.strip()
        if sid in students:
            st = students[sid]
            output.value = f"ID: {sid}\nName: {st['name']}\nCourse: {st['course']}\nBirthday: {st['birthday']}"
            output.color = "green"
            delete_button.visible = True
        else:
            output.value = "Student not found."
            output.color = "red"
            delete_button.visible = False
        page.update()

    content_column = ft.Column(
        [
            student_id_input,
            output,
            ft.ElevatedButton(text="Find", on_click=find_student, width=300, height=50),
            delete_button,
        ],
        alignment=ft.MainAxisAlignment.CENTER,
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=15,
    )

    return ft.View(
        route="/find",
        appbar=ft.AppBar(
            title=ft.Text("Find Student"),
            center_title=True,
            leading=ft.IconButton(ft.Icons.ARROW_BACK, on_click=lambda e: page.go("/")),
        ),
        controls=[
            ft.SafeArea(content=content_column, expand=True)
        ],
    )