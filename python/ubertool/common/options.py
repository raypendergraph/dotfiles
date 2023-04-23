from enum import Enum



class OutputFormat(str, Enum):
    pretty = "pretty"
    json = "json"

    def help_text(self) -> str:
        return 'Format of the data printed to stdout. Possible values are: pretty, json'
