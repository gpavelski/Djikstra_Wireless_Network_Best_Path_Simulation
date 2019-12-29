%% Inicialização do programa

clc; clear all; close all; %Limpa o prompt de comandos, a workspace a fecha todas as janelas

%% Inicialização das variáveis

A = importdata('Input_Grafo255.txt');  %Importa os dados a partir de um arquivo de texto
x = 1; %x = 0 ->> sentido único, x = 1 ->> duplo-sentido (ida e volta); 
P_0 = 1;  %Nó de partida para o algoritmo (a = 1, b = 2, ...)
P_f = 1;  %Nó de destino para o algoritmo (a = 1, b = 2, ...)
% Erros: Grafo 3, x = 0, P_0 = 3, P_f = 2
% Grafo 3, x = 0, P_0 = 4 P_f = 5
% Grafo 3, x = 0, P_0 = 4 P_f = 2

%% Obtenção da matriz de dados

K = zeros(max(unique(A.data(:,1:2))), max(unique(A.data(:,1:2)))); %Inicializa a matriz X

orig = A.data(:,1)'; %Define os enlaces origem a partir da 1a coluna do arquivo de texto
dest = A.data(:,2)'; %Define os enlaces destino a partir da 2a coluna do arquivo de texto
peso = A.data(:,3)'; %Define os enlaces peso a partir da 3a coluna do arquivo de texto

Alphabet=char('A'+(1:max(unique(A.data(:,1:2))))-1)'; %Cria uma letra que possa ser atribuída a cada nó
%Obs.:Caso o número de nós seja maior do que 26, repensar esse comando
nomes = cellstr(Alphabet)'; %Dá nome aos bois

for k = 1:size((A.data),1)
    K(orig(k),dest(k)) = peso(k); %Cria uma matriz correspondente aos pesos de cada enlace
    if x == 1
        K(dest(k),orig(k)) = peso(k);
    end
end

%% Cálculo do melhor caminho pelo algoritmo de Djikstra 
if x == 0
    G = digraph(K);
elseif x == 1
    G = graph(K)
end
 
 [L e] = shortestpath(G,P_0,P_f)
 %[e L] = dijkstra(K,P_0,P_f);  %Utiliza a função para resolver o algoritmo de Djikstra para encontrar o melhor caminho
 % e = menor custo
 % L = caminho de menor custo
 
 if e == Inf
     L = P_0;
 end
 
 Ld = L; %O algoritmo dá o melhor caminho de trás para frente, essa função apenas inverte a ordem
   

  %% Apresentação dos resultados
  
 msg = ['O menor custo da trajetória entre "', strjoin(nomes(P_0)),'" e "', strjoin(nomes(P_f)),'" é: ', num2str(e)];
 disp(msg); %Mostra o resultado através de mensagem no prompt de comando
 if e == Inf
    msg = ['Não há melhor caminho, sentido impossível'];
 else
     msg = ['O caminho para isto é: ', strjoin(nomes(Ld))];
 end
 disp(msg); %Mostra o melhor caminho através de mensagem no prompt de comando
 
  B = ones(length(peso),3); %Cria uma matriz auxiliar para facilitar a plotagem do melhor caminho
  B(:,1) = orig;    %Atribui à primeira coluna da matriz B os nós de origem dados na entrada
  B(:,2) = dest;    %Atribui à segunda coluna da matriz B os nós de destino dados na entrada
  

  m = 1; %Inicializa a variável m, que servirá como contador no loop a seguir
  k = 1; %Inicializa a variável k, que conta as linhas no loop a seguir
while k <= length(peso)
    if m == length(Ld)
            break;  %Quando o número de enlaces de maior peso for igual ao tamanho do vetor Ld, para o loop
            
    elseif x == 0
            if B(k,1) == Ld(m) && B(k,2) == Ld(m+1)
                B(k,3) = 15;    %Caso o enlace faça parte do melhor caminho calculado anteriormente, atribui peso maior
                m = m + 1;      %Caso um enlace já tenha sido incrementado de um peso maior, soma 1
                k= 0;
            end
    elseif x == 1
             if B(k,1) == Ld(m) && B(k,2) == Ld(m+1) || B(k,1) == Ld(m+1) && B(k,2) == Ld(m)
                B(k,3) = 15;    %Caso o enlace faça parte do melhor caminho calculado anteriormente, atribui peso maior
                m = m + 1;      %Caso um enlace já tenha sido incrementado de um peso maior, soma 1
                k= 0;
             end
    end

    k = k + 1; %Incrementa o loop
end
figure(1); %Abre nova janela de figura
subplot(1,2,1); %Divide a figura em duas partes: Grafo antes do algoritmo e depois
G = digraph(orig,dest,peso,nomes); %Gera o grafo original
if x == 1
    clear G;
    G = graph(orig,dest,peso,nomes); %Gera o grafo original
end
plot(G,'EdgeLabel', G.Edges.Weight) %Plota o grafo original
title('Grafo correspondente ao roteamento'); %Título da figura
p = G.Edges.Weight; %Salvo os pesos originais em uma variável p

subplot(1,2,2); %Muda para a segunda parte da figura
G = digraph(orig,dest,B(:,3),nomes); %Gera o grafo destacando melhor caminho
if x == 1
    clear G;
    G = graph(orig,dest,B(:,3),nomes); %Gera o grafo destacando melhor caminho
end
if e ~= 0 && e ~= Inf
    LWidths = 5*G.Edges.Weight/max(G.Edges.Weight); %Atribui espessura maior para o melhor caminho
    plot(G, 'EdgeLabel', p, 'LineWidth',LWidths) %Plota o grafo com melhor rota utilizando os pesos originais
elseif e== 0
    h = plot(G, 'EdgeLabel', p); %Plota o grafo com melhor rota utilizando os pesos originais
    highlight(h,L);
else
    h = plot(G, 'EdgeLabel', p);
    highlight(h,P_0, 'NodeColor', 'red');
end
title('Melhor caminho calculado pelo algoritmo de Djikstra'); %Título do gráfico
legend('Outras possibilidades/Melhor caminho') %Legenda do gráfico