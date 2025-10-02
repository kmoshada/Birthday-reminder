import flet as ft
from student_management.services import load_students, save_students

def delete_view(page: ft.Page):
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
            student_id_input.value = ""
        else:
            output.value = "Student not found."
            output.color = "red"
        
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

    def delete_student_action(e):
        students = load_students()
        sid = student_id_input.value.strip()
        if not sid:
            output.value = "Please enter a Student ID."
            output.color = "red"
            page.update()
            return

        if(sid not in students):
            output.value = "Student not found."
            output.color = "red"
            page.update()
            return

        output.value = "Student found."
        output.color ="green"
        page.dialog =  confirm_dialog
        confirm_dialog.open = True
        page.update()

    content_column = ft.Column(
        [
            student_id_input,
            output,
            ft.ElevatedButton(text="Delete Student", on_click=delete_student_action, width=300, height=50, color="white", bgcolor="red"),
        ],
        alignment=ft.MainAxisAlignment.CENTER,
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=15,
    )

    return ft.View(
        route="/delete",
        appbar=ft.AppBar(
            title=ft.Text("Delete Student"),
            center_title=True,
            leading=ft.IconButton(ft.Icons.ARROW_BACK, on_click=lambda e: page.go("/")),
        ),
        controls=[
            ft.SafeArea(content=content_column, expand=True),
            confirm_dialog
        ],
    )