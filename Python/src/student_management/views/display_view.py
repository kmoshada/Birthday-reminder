import flet as ft
from student_management.services import load_students

def display_view(page: ft.Page):
    table = ft.DataTable(
        columns=[
            ft.DataColumn(ft.Text("ID")),
            ft.DataColumn(ft.Text("Name")),
            ft.DataColumn(ft.Text("Course")),
            ft.DataColumn(ft.Text("Birthday")),
        ],
        rows=[],
    )
    output = ft.Text()

    def show_students():
        students = load_students()
        if students:
            table.rows = [
                ft.DataRow(cells=[
                    ft.DataCell(ft.Text(sid)),
                    ft.DataCell(ft.Text(st["name"])),
                    ft.DataCell(ft.Text(st["course"])),
                    ft.DataCell(ft.Text(st["birthday"])),
                ]) for sid, st in students.items()
            ]
            output.value = ""
        else:
            output.value = "No students available."

    show_students()

    content_column = ft.Column(
        [
            output,
            ft.Container(
                content=table,
                width=600,  # Set a fixed width for the table
            ),
        ],
        alignment=ft.MainAxisAlignment.START,
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=15,
        expand=True,
        scroll="auto",  # Enable scrolling for the column
    )

    return ft.View(
        route="/display",
        appbar=ft.AppBar(
            title=ft.Text("Display Students"),
            center_title=True,
            leading=ft.IconButton(ft.Icons.ARROW_BACK, on_click=lambda e: page.go("/")),
        ),
        controls=[
            ft.SafeArea(content=content_column, expand=True)
        ],
    )