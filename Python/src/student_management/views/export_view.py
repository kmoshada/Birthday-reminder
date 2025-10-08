import flet as ft
import json, os
from student_management.services import load_students

def export_view(page: ft.Page):
    output = ft.Text()

    def export_students_to_txt(e):
        students = load_students()
        _current_dir = os.path.dirname(os.path.abspath(__file__))
        storage_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(_current_dir))), "storage")
        if not os.path.exists(storage_dir):
            os.makedirs(storage_dir)
        save_path = os.path.join(storage_dir, "students_export.txt")
        with open(save_path, "w") as f:
            f.write(json.dumps(students, indent=4))
        output.value = f"Students exported to {save_path}!"
        output.color = "green"
        page.update()

    content_column = ft.Column(
        [
            output,
            ft.ElevatedButton(text="Export to TXT", on_click=export_students_to_txt, width=300, height=50),
        ],
        alignment=ft.MainAxisAlignment.CENTER,
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=15,
    )

    return ft.View(
        route="/export",
        appbar=ft.AppBar(
            title=ft.Text("Export Students"),
            center_title=True,
            leading=ft.IconButton(ft.Icons.ARROW_BACK, on_click=lambda e: page.go("/")),
        ),
        controls=[
            ft.SafeArea(content=content_column, expand=True)
        ],
    )