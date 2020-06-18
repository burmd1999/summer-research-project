%% Watts-Strogatz small world network model 

% number of nodes, degree
N = 1000;
k = 10; 

% test code to see if randomization process reproduces graph in Watts paper
% for N=1000 nodes and k=10 nearest neighbours

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


%% random rewiring process for varying values of p

% sequence of p values 
p_v = [0.0001 0.00025 0.0005 0.001 0.0025 0.005 0.01 0.025 0.05 0.1 0.25 0.5 1]; 
% create vectors to store characteristic path length and clustering coefficient for each value of p
L_p = zeros(1, length(p_v));
C_p = zeros(1, length(p_v));

for y = 1:length(p_v)
L = zeros(20, 1);
C = zeros(20, 1);
p = p_v(y); 
    for x = 1:20 
        A = full(adjacency(G_r));                                   
        for sourcenode = 1:N                                            % consider each source node
            for t = 1:k/2                                               % consider each righthand nearest neighbour of each node, moving from first neighbour clockwise
                r = zeros(1, k/2);                                      % empty vector for random uniform numbers
                endnodes = find(A(sourcenode, :));                      % find the endnodes of the source node (i.e nodes connected by an edge)
                r(t) = rand;                                            % generate uniform random numbers between 0 and 1
                if r(t) < p                                             % if r is less than the probability given p, continue rewiring process                    
                   A(sourcenode, mod(sourcenode + t - 1, N) + 1) = 0;   % remove the edge from the original end node
                   A(mod(sourcenode + t - 1, N) + 1, sourcenode) = 0;   % symmetric index in adjacency matrix
                   s = find(~ismember([1:N], [endnodes sourcenode]));   % find indices of target nodes that are not already connected to source node                              
                   targetnode = randsample(s, 1);                       % randomly uniformly select one of the nodes
                   A(sourcenode, targetnode) = 1;                       % connect source node to new end node  
                   A(targetnode, sourcenode) = 1;                       % symmetric index in adjacency matrix
                end
            end
        end

        G_p = graph(A);
        % compute characteristic path length for rewired graph
        D = distances(G_p);
        l = (sum(D, 'all'))./(N*(N - 1));
        % compute clustering coefficient 
        c_i = zeros(N, 1);
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
            c_i(v) = E/(length(n)*(length(n) - 1)); 
        end
        c = mean(c_i);
        L(x) = l;
        C(x) = c;
    end
% average over 20 random realizations and save
L_p(y) = mean(L);
C_p(y) = mean(C);
end

%% plot 
% normalize CPL and CC for each value of p by regular lattice CPL and CC
L_p_norm = L_p./L_r;
C_p_norm = C_p./C_r;

% plot on log scale
figure()
scatter(p_v, L_p_norm, 'black', 'filled')
set(gca, 'xscale', 'log')
hold on
scatter(p_v, C_p_norm, 'square', 'black')
legend('L(p)/L(0)', 'C(p)/C(0)')
title('L(p) and C(p) for Randomly Rewired Graphs')










 



    






    
    
    
    
    


