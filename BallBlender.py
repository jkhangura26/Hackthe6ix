import bpy
import math

def create_materials(colors):
    materials = []
    for index, color in enumerate(colors):
        material = bpy.data.materials.new(name=f"Material_{index}")
        material.diffuse_color = (color[0], color[1], color[2], 1)  # RGBA
        materials.append(material)
    return materials

def create_balloon(location, radius, index, material):
    # Create the balloon (UV sphere)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=radius, location=location)
    balloon = bpy.context.object
    # Name the balloon uniquely by appending the index
    balloon.name = f'Balloon_{index}'

    # Assign the material
    if len(balloon.data.materials) == 0:
        balloon.data.materials.append(material)
    else:
        balloon.data.materials[0] = material

    # Add physics properties
    bpy.ops.object.shade_smooth()
    bpy.ops.rigidbody.object_add()
    balloon.rigid_body.type = 'ACTIVE'
    balloon.rigid_body.mass = 1
    balloon.rigid_body.collision_shape = 'SPHERE'
    balloon.rigid_body.restitution = 0.6  # Bounciness

def delete_balloons():
    # Deselect all objects first
    bpy.ops.object.select_all(action='DESELECT')
    
    # Select objects named with the pattern "Balloon_" and delete them
    for obj in bpy.data.objects:
        if obj.name.startswith("Balloon_"):  # Match the naming pattern
            obj.select_set(True)
    bpy.ops.object.delete()

def main():
    # Remove existing balloons
    delete_balloons()
    
    # Define colors
    colors = [
        (1, 0, 0),    # Red
        (0, 1, 0),    # Green
        (0, 0, 1),    # Blue
        (1, 1, 0),    # Yellow
        (0, 1, 1),    # Cyan
    ]
    
    # Create materials array
    materials = create_materials(colors)
    
    # Read balloon centers from file
    balloon_file_path = r'C:\Users\mehak\Downloads\balloon_centers.txt'
    try:
        with open(balloon_file_path, 'r') as file:
            # Read the additional data from the first line
            first_line = file.readline().strip().split()
            color_counts = list(map(int, first_line[:-1]))  # First five values
            total_balloons = int(first_line[-1])  # The sum of the first five values
            
            print("DPAOSJ")

            # Ensure that the sum matches the number of balloons to be created
            if total_balloons != sum(color_counts):
                raise ValueError("The sum of color counts does not match the total number of balloons")

            # Create balloons according to the color distribution
            color_index = 0
            color_counter = 0
            lines = file.readlines()
            for index, line in enumerate(lines):
                if color_counter >= color_counts[color_index] and color_index < 3:
                    color_index += 1
                    color_counter = 0
                x, y, z = map(float, line.split())
                # Ensure color_index is within bounds
                if color_index >= len(colors):
                    raise IndexError("Color index out of range. Check your color counts and color definitions.")
                create_balloon(location=(x, y, z), radius=250, index=index, material=materials[color_index])
                color_counter += 1
                print(f'Created balloon at ({x}, {y}, {z}) with color {colors[color_index]}')

    except Exception as e:
        print(f'Failed to read balloon centers from {balloon_file_path}: {e}')

if __name__ == "__main__":
    main()