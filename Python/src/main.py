import flet as ft
import sys

from student_management.views.add_view import add_view
from student_management.views.find_view import find_view
from student_management.views.display_view import display_view
from student_management.views.update_view import update_view
from student_management.views.export_view import export_view
from student_management.views.import_view import import_view
from student_management.views.delete_view import delete_view

from student_management.services import get_today_birthdays, get_upcoming_birthdays


def main(page: ft.Page):
    page.title = "Student Management System"
    page.window_width = 200
    page.window_height = 700
    page.theme_mode = ft.ThemeMode.DARK
    page.theme = ft.Theme(
        color_scheme=ft.ColorScheme(
            primary=ft.Colors.DEEP_PURPLE,
            background=ft.Colors.LIGHT_GREEN_500,
        )
    )
    page.dark_theme = ft.Theme(
        color_scheme=ft.ColorScheme(
            primary=ft.Colors.PURPLE_300,
            background=ft.Colors.BLUE_GREY_500,
        )
    )

    def exit_app(page: ft.Page):
        try:
            page.window_destroy()
        except:
            sys.exit()

    def main_view():
        # Birthday Cards
        birthday_cards = ft.Column()
        
        # Today's Birthdays
        birthdays = get_today_birthdays()
        if birthdays:
            birthday_cards.controls.append(ft.Text("🎂 Today's Birthdays", size=18))
            for s in birthdays:
                birthday_cards.controls.append(
                    ft.Card(
                        content=ft.ListTile(
                            leading=ft.Icon(ft.Icons.CAKE),
                            title=ft.Text(s.name),
                            subtitle=ft.Text(f"ID: {s.student_id}"),
                        )
                    )
                )
            page.snack_bar = ft.SnackBar(ft.Text("🎉 Birthday Reminder!"))
            page.snack_bar.open = True

        # Upcoming Birthdays
        upcoming = get_upcoming_birthdays(7)
        if upcoming:
            birthday_cards.controls.append(ft.Text("📅 Upcoming Birthdays", size=16))
            for s, date in upcoming:
                birthday_cards.controls.append(
                    ft.Card(
                        content=ft.ListTile(
                            leading=ft.Icon(ft.Icons.CALENDAR_MONTH),
                            title=ft.Text(s.name),
                            subtitle=ft.Text(f"on {date}"),
                        )
                    )
                )
        
        if not birthdays and not upcoming:
            birthday_cards.controls.append(ft.Text("No birthdays coming up."))

        return ft.View(
            route="/",
            appbar=ft.AppBar(
                title=ft.Text("Student Management"),
                center_title=True,
            ),
            controls=[
                ft.SafeArea(
                    content=ft.Column(
                        [
                            birthday_cards,
                            ft.ElevatedButton(text="Add Student", on_click=lambda _: page.go("/add"), width=300, height=50),
                            ft.ElevatedButton(text="Find Student", on_click=lambda _: page.go("/find"), width=300, height=50),
                            ft.ElevatedButton(text="Display Students", on_click=lambda _: page.go("/display"), width=300, height=50),
                            ft.ElevatedButton(text="Update Student", on_click=lambda _: page.go("/update"), width=300, height=50),
                            ft.ElevatedButton(text="Export Students", on_click=lambda _: page.go("/export"), width=300, height=50),
                            ft.ElevatedButton(text="📥 Import JSON", on_click=lambda _: page.go("/import"), width=300, height=50),
                            ft.ElevatedButton(text="Delete Student", on_click=lambda _: page.go("/delete"), width=300, height=50),
                            ft.ElevatedButton(text="Exit", on_click=lambda e: exit_app(page), width=300, height=50),
                        ],
                        alignment=ft.MainAxisAlignment.CENTER,
                        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                        spacing=15,
                    ),
                    expand=True,
                )
            ],
        )

    def route_change(e: ft.RouteChangeEvent):
        page.views.clear()
        if page.route == "/":
            page.views.append(main_view())
        elif page.route == "/add":
            page.views.append(add_view(page))
        elif page.route == "/find":
            page.views.append(find_view(page))
        elif page.route == "/display":
            page.views.append(display_view(page))
        elif page.route == "/update":
            page.views.append(update_view(page))
        elif page.route == "/export":
            page.views.append(export_view(page))
        elif page.route == "/import":
            page.views.append(import_view(page))
        elif page.route == "/delete":
            page.views.append(delete_view(page))
        page.update()

    page.on_route_change = route_change
    page.go("/")


ft.app(target=main, view=ft.AppView.FLET_APP_HIDDEN)
