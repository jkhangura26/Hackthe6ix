numb_balls = 144;
function centers = bouncing_spheres_3d(num_spheres)
   % tic;
    % Define the radius of the spheres
    radius = 250;

    % Create a sphere
    % [X, Y, Z] = sphere;
    % 
    % % Scale the sphere
    % X = radius * X;
    % Y = radius * Y; 
    % Z = radius * Z;

    % Generate random initial centers for the spheres
    % centers = 2*length * (rand(num_spheres, 3) - 0.5);
    
     % Calculate the number of layers needed for the pyramid
    layers = 0;
    total_spheres = 0;
    dim = 0;
    curr_dim = 1;
    while total_spheres < num_spheres
        total_spheres = total_spheres + curr_dim^2;
        layers = layers + 1;
        dim = dim + 1;
        if dim == curr_dim
            curr_dim = curr_dim + 1;
            dim = 0;
        end
    end 
    % disp(total_spheres);
    % disp(num_spheres);

    % Initialize centers for the spheres
    % centers = zeros(total_spheres, 3);
    centers = [];

    % Generate centers for the spheres in a pyramid-like arrangement
    sphere_count = 0;
    height = 0;
    for l = 0:layers-1
    for k = 0:l
        for i = 0:l
            for j = 0:l
                if sphere_count >= total_spheres 
                    break;
                end
                % if ~((i == 0) || (i == l) || (j == 0) || (j == l))
                %     sphere_count = sphere_count + 1;
                %     continue;
                % end
                x = (i - l/2) * 2 * radius;
                y = (j - l/2) * 2 * radius;
                z = (layers-height) * 2 * radius; % Place each layer above the previous one
                centers(sphere_count+1, 1) = x + 10 * rand();
                centers(sphere_count+1, 2) = y - 8000 + 10 * rand();
                centers(sphere_count+1, 3) = z + 10 * rand();
                sphere_count = sphere_count + 1;
            end
            if sphere_count >= total_spheres 
                break;
            end
        end
        height = height + 1;
    end 
    end

    return;
    % Create a figure and plot the spheres
    % figure;
    % hold on;
    % h = gobjects(total_spheres, 1);
    % for i = 1:total_spheres
    %     h(i) = surf(X + centers(i, 1), Y + centers(i, 2), Z + centers(i, 3));
    %     set(h(i), 'EdgeColor', 'none');
    % end
    % hold off;
    % 
    % % Set axis properties
    % axis equal;
    % grid on;
    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
    % title('Bouncing Spheres');
    % view(3); % Set a 3D view

    % Fix the axis limits to ensure a stable view
    % axis([-100 100 -100 100 -layers*radius - 3*radius, radius]);
    % tot_time = toc;
    % disp(tot_time);
end

% Call the function with the desired number of spheres
coords = bouncing_spheres_3d(numb_balls); % Adjust the number of spheres as needed

% Save balloon centers to a text file
save('balloon_centers.txt', 'coords', '-ascii');

% Define the paths with escaped backslashes and ensure paths with spaces are handled
blenderPath = 'C:\\Program Files\\Blender Foundation\\Blender 4.2\\blender.exe';
scriptPath = 'C:\\Users\\mehak\\Downloads\\96-uploads_files_2720101_textures-2\\BallBlender.py';

% Create the command string using sprintf and enclosing paths in double quotes
command = sprintf('"%s" --background --python "%s"', blenderPath, scriptPath);

% Execute the system command 
[status, cmdout] = system(command);

% Check the status
if status == 0
    disp('Blender script executed successfully.');
else
    disp(['Error executing Blender script: ', cmdout]);
end