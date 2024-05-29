function centrality_vector = node_centrality(adjacent_matrix, centrality_type)
    % 根据不同的中心性类型执行不同的计算
    switch centrality_type
        case 'degree'
            % 计算度中心性
            centrality_vector = centrality(graph(adjacent_matrix), 'degree');
            
        case 'closeness'
            % 计算接近中心性
             centrality_vector = centrality(graph(adjacent_matrix), 'closeness');

        case 'betweenness'
            % 计算中介中心性
            centrality_vector = centrality(graph(adjacent_matrix), 'betweenness');
            
        case 'eigenvector'
            % 计算特征向量中心性
            centrality_vector = centrality(graph(adjacent_matrix), 'eigenvector');
            
        case 'pagerank'
            % 计算特征向量中心性
            centrality_vector = centrality(graph(adjacent_matrix), 'pagerank');
            
        otherwise
            fprintf('未知的中心性类型。\n');
            centrality_vector = [];
    end
end