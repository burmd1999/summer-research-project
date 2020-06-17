%% load data
load('COH.mat', 'COH')

%% variables
numchannels = size(COH, 1);

% set a threshold for coherence
threshold = 0.20;

%% adjacency matrix
A = all(COH > threshold & COH ~= 1, 3);

%% plot graph
G = graph(A);
figure()
plot(G)

%% characteristic path length between all pairs of nodes

D = distances(G);
L_coh = (sum(D, 'all'))./(G.numnodes*(G.numnodes - 1));

%% find clustering coefficient
% loop to find clustering coefficient of each node
C_i = zeros(G.numnodes, 1);
for i = 1:G.numnodes
    n = [find(A(i, :))];
    E = 0;
    for j = n([1:length(n)])
        m = [];
        m = [find(A(j, :))];
        for k = m([1:length(m)])
            if any(n == k)
                E = E + 1;
            end
        end
    end
    C_i(i) = E/(length(n)*(length(n) - 1)); % multiply by 2 for (k*(k-1)/2) but then divide by 2 to account for double counting of edges
end

% average clustering coefficient over all nodes
C_coh = mean(C_i);

%% avg degree of nodes
deg = degree(G);
avgdeg = mean(deg);

save('coherencegraph.mat', 'numchannels', 'L_coh', 'C_coh', 'avgdeg')




















    
    







    
   
    
    






