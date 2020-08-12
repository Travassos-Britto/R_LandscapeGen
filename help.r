landscapeGen  		package: nenhum			R documentation

GERA E/OU ANALISA PAISAGENS BINÁRIAS

Description:
  Gera e/ou analisa uma paisagem bidimensional binária, com nível de fragmentação FRAG.Retorna uma interface gráfica mostrando o perfil da paisagem e os valores para o número de fragmentos, o tamanho do maior e do menor fragmento e o tamanho médio dos fragmentos.

Usage:
  laçndscapeGen (DATA=NA, TAMX=30, TAMY=30, FRAG=0.5, COVER=0.2, NEI8=FALSE)

Arguments:
  DATA    Matriz binária (0 ou 1). Caso seja deixado em NA a função irá gerar uma paisagem com os argumentos dados. 
  TAMX    Número inteiro definindo o número de células no eixo x da paisagem. Definição desnecessária caso DATA uma matriz binária.
  TAMY    Número inteiro definindo o número de células no eixo y da paisagem. Definição desnecessária caso DATA uma matriz binária.
  FRAG    Número entre '0' e '1', não incluindo '0' definindo o nível de fragmentação.Definição desnecessária caso DATA uma matriz binária
  COVER   Número entre '0' e '1' definindo a proporção da paisagem que será considerada como hábitat.Definição desnecessária caso DATA uma matriz binária
  NEI8    Variável lógica definindo a regra de vizinhança das células. TRUE indica que serão consideradas vizinhas de uma célula x, as células que estiverem nas oito direções cardinais. FALSE indica que somente as células nas 4 direções cardinais serão consideradas vizinhas. 

Details:
  O nível de fragmentação é dado por um algorítimo  modificado do medelo apresentado por Fahrig (1998). Em resumo, quanto maior o nível de fragmentação maior a probabilidade de as células de hábitat serem celecionadas de maneira aleatória na paisagem, quanto menor esse valor maior a probabilidade de elas só serem marcadas como células de hábitat caso haja uma célula de hábitat vizinha. Para mais detalhes consultar código.
  A regra de vizinhança vale tanto para definição do perfil de fragmentação da matriz, quanto para o cálculo de número de fragmentos.Isso quer dizer que regra de vizinhança NEI8=FALSE, ele para selecionar células de hábitat que sejam vizinhas serão consideradas apenas as quatro células nas direções N, S, L, O. E fragmentos que se conectem apenas por células diagonais serão considerados fragmentos diferentes. 

Warning:
  Warning: Você não inseriu uma matriz binária, portanto a função irá gerar uma matriz com o parÂmetros selecionados.

Author:
  Bruno Travassos-de-Britto
bruno.travassos@gmail.com

Reference:
  Fahrig L. When does fragmentation of breeding habitat affect population survival? Ecol.Model. 1998; 105: 273-92  
  
  Examples:
  #selecione uma matriz binária de nome qualquer
  landscapeGen(minha.matriz,NEI8=T) # Gera uma interface gráfica mostrando o perfil desta matriz e as suas propriedade (Tamanho em número de celulas(TAMX x TAMY), area de cobertura de hábitat (COVER),regra de vizinhança (NEI8), número de fragmentos, tamanho do maior fragmento, tamanho do menor fragmento e tamanho médio dos fragmentos). Retorna um data frame contendo essas informações
  landscapeGen(TAMX=40, TAMY=30, COVER=0.2, FRAG=0.01, NEI8=F) # Gera uma paisagem retangular de lado horizontal 40 e lado vertica 30 (40x30= 1200 células). 20% dessas 1200 células serão de hábitat, o índice de fragmentação será de 0.01, e a regra de vizinhança será 4.