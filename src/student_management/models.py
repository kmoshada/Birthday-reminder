class Student:
    def __init__(self, student_id: str, name: str, course: str, birthday: str):
        self.student_id = student_id
        self.name = name
        self.course = course
        self.birthday = birthday

    def to_dict(self):
        return {
            "name": self.name,
            "course": self.course,
            "birthday": self.birthday,
        }

    @staticmethod
    def from_dict(student_id: str, data: dict):
        return Student(
            student_id,
            data.get("name", ""),
            data.get("course", ""),
            data.get("birthday", ""),
        )