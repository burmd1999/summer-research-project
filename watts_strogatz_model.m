%% Watts-Strogatz small world network model

% number of nodes, degree
N = numchannels % number of nodes
k = floor(avgdeg)

% create a ring lattice with nodes = numchannels, k = same avg degree as
% coh graph
% each node connected to its k nearest neighbours, k/2 on each side

%% regular ring lattice
% build adjacency matrix for ring lattice
A = zeros(N);
for i = 1:N
    for j = 1:N
        if i - j ~=0 && mod(abs(i - j), N - k/2) <= k/2 
           A(i, j) = 1;
           A(j, i) = 1;
        else A(i, j) = 0;
             A(j, i) = 0;
        end
    end
end

% plot regular ring lattice 
G_r = graph(A)
figure()
plot(G_r)
title('Ring Lattice')

% calculate characteristic path length for ring lattice
D = distances(G_r);
L_r = (sum(D, 'all'))./(N*(N - 1));

% calculate clustering coefficient for ring lattice
% loop to find clustering coefficient of each node
C_i = zeros(N, 1);
for v = 1:N
    n = [find(A(v, :))];
    E = 0;
    for w = n([1:length(n)])
        m = [];
        m = [find(A(w, :))];
        for j = m([1:length(m)])
            if any(n == j)
                E = E + 1;
            end
        end
    end
    C_i(v) = E/(length(n)*(length(n) - 1)); % multiply by 2 for (k*(k-1)/2) but then divide by 2 to account for double counting of edges
end

% average clustering coefficient over all nodes
C_r = mean(C_i);


% rewiring process for different values of p
% consider p = 0.001, p = 0.01, p = 0.1, p = 1

%% p = 0.001 
% reiterate rewiring process for p = 0.001 20 times 

C = zeros(20, 1);
L = zeros(20, 1);

for i = 1:20
    
    p = 0.001; 
    A = full(adjacency(G_r)); % re-initialize adjacency matrix to regular ring lattice 
    
    for sourcenode = 1:N                                            % consider each source node
        for t = 1:k/2                                               % consider each righthand nearest neighbour of each node, moving from first neighbour clockwise                  
            endnodes = find(A(sourcenode, :));                      % find the endnodes of the source node (i.e nodes connected by an edge)
            r = rand;                                               % generate uniform random number between 0 and 1
            if r > p                                                % if r is greater than the probability given p, continue rewiring process                    
               A(sourcenode, mod(sourcenode + t - 1, N) + 1) = 0;   % remove the edge from the original end node
               A(mod(sourcenode + t - 1, N) + 1, sourcenode) = 0;   % symmetric index in adjacency matrix
               s = setdiff([1:N], endnodes);                        % list of possible new end nodes with already connected nodes removed from list
               s = setdiff(s, sourcenode);                          % remove source node from list of end nodes so that there are no self loops
               targetnode = randsample(s, 1);                       % randomly select one of the nodes in c
               A(sourcenode, targetnode) = 1;                       % connect source node to new end node  
               A(targetnode, sourcenode) = 1;                       % symmetric index in adjacency matrix
            end
        end
    end

    % plot rewired graph
    G_rewired = graph(A);
    %figure()
    %plot(G_rewired)

    % compute characteristic path length for rewired graph
    D = distances(G_rewired);
    L_p = (sum(D, 'all'))./(N*(N - 1));

    % compute clustering coefficient for rewired graph
    C_i = zeros(N, 1);
    for v = 1:N
        n = [find(A(v, :))];
        E = 0;
        for w = n([1:length(n)])
            m = [];
            m = [find(A(w, :))];
            for j = m([1:length(m)])
                if any(n == j)
                E = E + 1;
                end
            end
        end
        C_i(v) = E/(length(n)*(length(n) - 1)); % multiply by 2 for (k*(k-1)/2) but then divide by 2 to account for double counting of edges
    end

    % average clustering coefficient over all nodes
    C_p = mean(C_i);

    % store L_p and C_p in L and C vectors
    L(i) = L_p;
    C(i) = C_p;
end

% average over 20 random realizations
L = mean(L);
C = mean(C);








 



    






    
    
    
    
    


