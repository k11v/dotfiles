import sublime_plugin


class SugaryNewFileCommand(sublime_plugin.WindowCommand):
    """
    Creates new file inheriting the syntax of the active one.
    """
    def run(self):
        # get current window
        current_window = self.window
        # get current file's syntax
        current_syntax = current_window.active_view().settings().get('syntax')
        # create new file
        new_view = current_window.new_file()
        # set new file's syntax
        new_view.set_syntax_file(current_syntax)
