function Redes_Rand_Input( n, l, i, Pmax )

%% Descrição:

%O objetivo deste programa é criar uma função que crie automaticamente um
%arquivo de entrada que represente um grafo que será posteriormente
%utilizado na função Redes_sem_Fio. Esse arquivo deve ser gerado com pesos
%e enlaces aleatórios a partir de dados de entrada fornecidos pelo usuário.

%% Inicialização das variáveis

Int = 0;

lmin = n - 1;
v = 1:n;
C = nchoosek(v,2);
if i == 1
    lmax = nchoosek(n,2); %Número máximo de enlaces
elseif i == 0
    lmax = 2*nchoosek(n,2); %Número máximo de enlaces
    C = union(C,fliplr(C),'rows');
end


Int = randperm(lmax,l);

%% Escreve o arquivo de saída

fileID = fopen('Input_Grafo255.txt','w');
fprintf(fileID,'%0s %1s %1s\r\n','O','D', 'P');
K = 1;
while K <= length(Int)
    fprintf(fileID,'%0d %1d %1d\r\n',C(Int(K),1), C(Int(K),2),  randi([1 Pmax]));
    K = K + 1;
end
fclose(fileID);
%type Input_Grafo255.txt
%Redes_sem_Fio( 255, double(i), 1, max(unique(C)) )