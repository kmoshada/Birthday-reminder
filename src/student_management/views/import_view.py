import flet as ft
from student_management.services import import_students

def import_view(page: ft.Page):
    file_picker = ft.FilePicker()
    page.overlay.append(file_picker)
    output = ft.Text()

    def pick_file_result(e: ft.FilePickerResultEvent):
        if e.files:
            file_path = e.files[0].path
            success, message = import_students(file_path)
            output.value = message
            if success:
                output.color = "green"
            else:
                output.color = "red"
            page.update()

    file_picker.on_result = pick_file_result

    content_column = ft.Column(
        [
            output,
            ft.ElevatedButton(
                text="Choose JSON File",
                on_click=lambda _: file_picker.pick_files(
                    allow_multiple=False,
                    file_type=ft.FilePickerFileType.CUSTOM,
                    allowed_extensions=["json"],
                ),
                width=300,
                height=50,
            ),
        ],
        alignment=ft.MainAxisAlignment.CENTER,
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=15,
    )

    return ft.View(
        route="/import",
        appbar=ft.AppBar(
            title=ft.Text("Import Students"),
            center_title=True,
            leading=ft.IconButton(ft.Icons.ARROW_BACK, on_click=lambda e: page.go("/")),
        ),
        controls=[
            ft.SafeArea(content=content_column, expand=True)
        ],
    )
