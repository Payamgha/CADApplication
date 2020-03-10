function stlwrite_ET(filename, X,Y,Z)

%% Converitng the Mesh to Face, you can use the delaunay function in MATLAB but the results may not look good
%faces = delaunay(Y,Z);
%vertices = [X(:) Y(:) Z(:)];
%filename = 'obj.stl';

[F, V] = mesh2tri(X,Y,Z,'f');
% Create the facets
facets = single(V');
facets = reshape(facets(:,F'), 3, 3, []);

% Compute their normals
V1 = squeeze(facets(:,2,:) - facets(:,1,:));
V2 = squeeze(facets(:,3,:) - facets(:,1,:));

normals = V1([2 3 1],:) .* V2([3 1 2],:) - V2([2 3 1],:) .* V1([3 1 2],:);
normals = bsxfun(@times, normals, 1 ./ sqrt(sum(normals .* normals, 1)));
facets = cat(2, reshape(normals, 3, 1, []), facets);

%% Open the file for writing

fid = fopen(filename, 'w');
if (fid == -1)
    error('stlwrite:cannotWriteFile', 'Unable to write to %s', filename);
end

%% Write the file contents

    % Write HEADER
    title = 'SolidObject';
    fprintf(fid, '%-80s', title);                  
    fwrite(fid, size(facets, 3), 'uint32');           
    
    % Add one uint16(0 or color) to the end of each facet 
    facets = reshape(typecast(facets(:), 'uint16'), 12*2, []);     
    facets(end+1,:) = 0;
   
    fwrite(fid, facets, 'uint16');

fclose(fid);
disp('STL export was successful')