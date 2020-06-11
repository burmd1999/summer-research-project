%% load data

load('coherence_test.mat', 'coherence_test', 'pairs_test')

%% variables 
srate = size(coherence_test, 2);
numchannels = pairs_test(size(pairs_test, 1), 2);

% set a threshold for coherence
threshold = 0.20;

%% adjacency matrix

A = zeros(numchannels);

% loop to create adjacency matrix
for i = 1:length(coherence_test)
    if coherence_test(i, :) > threshold
        A(pairs_test(i, 1), pairs_test(i, 2)) = 1;
        A(pairs_test(i, 2), pairs_test(i, 1)) = 1;
    else A(pairs_test(i, 1), pairs_test(i, 2)) = 0;
         A(pairs_test(i, 2), pairs_test(i, 1)) = 0;
    end
end

%% plot graph

channels = [1:numchannels];
G = graph(A);
plot(G)

%% characteristic path length between all pairs of nodes

D = distances(G);
cpl = (sum(D, 'all'))./(G.numnodes*(G.numnodes - 1));

%% find clustering coefficient

% loop to find clustering coefficient of each node
C_i = zeros(G.numnodes, 1);
for v = 1:G.numnodes
    n = [find(A(v, :))];
    E = 0;
    for w = n([1:length(n)])
        m = []
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
C_v = mean(C_i);

%% avg degree of nodes
deg = degree(G);
avgdeg = mean(deg);


%% regular graph
A_R 











    
    







    
   
    
    






