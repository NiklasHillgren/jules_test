
import json

with open('comments.json', 'r') as f:
    comments = json.load(f)

with open('classes/OrderClientDTOBuilder.cls', 'r') as f:
    lines = f.readlines()

def format_comment(comment):
    return f'/**\\n * {comment}\\n */\\n'

def get_class_name_from_builder(builder_name):
    if builder_name.endswith("Builder"):
        return builder_name[:-7]
    return builder_name

def get_with_method_name(line):
    start = line.find("with") + 4
    end = line.find("(")
    return line[start:end]

output_lines = []
current_class = None

for line in lines:
    stripped_line = line.strip()

    if stripped_line.startswith("public class") or stripped_line.startswith("public virtual class"):
        parts = stripped_line.split(" ")
        for i, part in enumerate(parts):
            if part == "class":
                current_class_builder = parts[i+1]
                current_class = get_class_name_from_builder(current_class_builder)
                break

    if "with" in stripped_line and "(" in stripped_line and ")" in stripped_line:
        method_name_unformatted = get_with_method_name(stripped_line)
        method_name = method_name_unformatted[0].lower() + method_name_unformatted[1:]

        if current_class in comments and method_name in comments[current_class]:
            comment = comments[current_class][method_name]
            if comment:
                # Check if a comment already exists
                previous_line_index = lines.index(line) - 1
                previous_line = lines[previous_line_index].strip()
                if not previous_line.endswith("*/"):
                    output_lines.append(format_comment(comment))

    output_lines.append(line)


with open('classes/OrderClientDTOBuilder.cls', 'w') as f:
    f.writelines(output_lines)
