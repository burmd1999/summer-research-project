% find characteristic path length and clustering coefficient of coherence graph
% load data
load('no_voc_task_301_coh.mat', 'no_voc_task_301_coh')

% variables
numchannels = size(no_voc_task_301_coh, 1);

% set a threshold for coherence
threshold = 0.20;

% adjacency matrix
A = all(no_voc_task_301_coh > threshold & no_voc_task_301_coh ~= 1, 3);

% graph
G = graph(A);

% characteristic path length between all pairs of nodes
D = distances(G);
L_coh = (sum(D, 'all'))./(G.numnodes*(G.numnodes - 1));

% find clustering coefficient
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

% avg degree of nodes
deg = degree(G);
avgdeg = floor(mean(deg));

% compute Watts-Strogatz model for regular graph with same number of nodes
% and average degree
p_v = [0.0001 0.00025 0.0005 0.001 0.0025 0.005 0.01 0.025 0.05 0.1 0.25 0.5 1]; 
[L_r, C_r, L_p, C_p] = wsmodel(numchannels, avgdeg, p_v);

%% add points to scatter plot
% plot 
% normalize CPL and CC for each value of p by regular lattice CPL and CC
L_p_norm = L_p./L_r;
C_p_norm = C_p./C_r;

% plot on log scale
figure()
wsmodel = scatter(p_v, L_p_norm, 'black', 'filled')
set(gca, 'xscale', 'log')
hold on
scatter(p_v, C_p_norm, 'square', 'black')
L_coh_norm = L_coh/L_r;
C_coh_norm = C_coh/C_r;
compare = [p_v' L_p_norm' C_p_norm'];
hold on
scatter(0.055, L_coh_norm, 'red', 'filled')
hold on
scatter(0.055, C_coh_norm, 'blue', 'filled')
legend('L(p)/L(0)', 'C(p)/C(0)', 'L for 301 coherence data', 'C for 301 coherence data')
title('Watts-Strogatz Model for 301 Coherence Data')
