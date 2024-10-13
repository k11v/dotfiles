from sublime_plugin import WindowCommand


class SmartNewFileCommand(WindowCommand):
    """
    Create a new file inheriting syntax from the current one.
    """
    def run(self):
        current_window = self.window
        current_syntax = current_window.active_view().settings().get("syntax")
        new_view = current_window.new_file()
        new_view.set_syntax_file(current_syntax)
