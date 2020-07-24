function [L, C] = coh_graph(cohdata, freq, threshold)

% coh_graph computes the characteristic path length and clustering
% coefficient of a graph whose nodes are electrodes/channels and an edge 
% connect two nodes if the sum of coherence values between the two nodes is above a given threshold 
% for a certain frequency range.

% Inputs:
% cohdata is a numchannels x numchannels x srate matrix
% freq is a frequency range of interest [a, b], input as a:b.
% threshold is a numerical value above which the sum of coherence values for pair of channels is considered significant. 

% Outputs:
% L is the characteristic path length (mean shortest path length) and C is
% the average clustering coefficient of all the nodes as defined by Watts &
% Strogatz.

% number of channels
numchannels = size(cohdata, 1); 

% initialize matrix for sum of coh values in freq range
coh_sum = zeros(numchannels, 1); 

% sum of coherence values for each pair of channels
for i = 1:numchannels
    for j = 1:numchannels
    coh_sum(i, j) = sum(cohdata(i, j, freq));
    end
end

% adjacency matrix of channel pairs with sum of coherence values above
% threshold, do not consider coherence of channels with themselves
A = coh_sum > threshold & round(coh_sum) ~= freq(length(freq));

% create graph
G = graph(A);

%% characteristic path length
D = distances(G);
L = (sum(D, 'all'))./(G.numnodes*(G.numnodes - 1));

%% clustering coefficient
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
C = mean(C_i);

end





    