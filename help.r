landscapeGen  		package: nenhum			R documentation

GERA E/OU ANALISA PAISAGENS BIN�RIAS

Description:
  Gera e/ou analisa uma paisagem bidimensional bin�ria, com n�vel de fragmenta��o FRAG.Retorna uma interface gr�fica mostrando o perfil da paisagem e os valores para o n�mero de fragmentos, o tamanho do maior e do menor fragmento e o tamanho m�dio dos fragmentos.

Usage:
  la�ndscapeGen (DATA=NA, TAMX=30, TAMY=30, FRAG=0.5, COVER=0.2, NEI8=FALSE)

Arguments:
  DATA    Matriz bin�ria (0 ou 1). Caso seja deixado em NA a fun��o ir� gerar uma paisagem com os argumentos dados. 
  TAMX    N�mero inteiro definindo o n�mero de c�lulas no eixo x da paisagem. Defini��o desnecess�ria caso DATA uma matriz bin�ria.
  TAMY    N�mero inteiro definindo o n�mero de c�lulas no eixo y da paisagem. Defini��o desnecess�ria caso DATA uma matriz bin�ria.
  FRAG    N�mero entre '0' e '1', n�o incluindo '0' definindo o n�vel de fragmenta��o.Defini��o desnecess�ria caso DATA uma matriz bin�ria
  COVER   N�mero entre '0' e '1' definindo a propor��o da paisagem que ser� considerada como h�bitat.Defini��o desnecess�ria caso DATA uma matriz bin�ria
  NEI8    Vari�vel l�gica definindo a regra de vizinhan�a das c�lulas. TRUE indica que ser�o consideradas vizinhas de uma c�lula x, as c�lulas que estiverem nas oito dire��es cardinais. FALSE indica que somente as c�lulas nas 4 dire��es cardinais ser�o consideradas vizinhas. 

Details:
  O n�vel de fragmenta��o � dado por um algor�timo  modificado do medelo apresentado por Fahrig (1998). Em resumo, quanto maior o n�vel de fragmenta��o maior a probabilidade de as c�lulas de h�bitat serem celecionadas de maneira aleat�ria na paisagem, quanto menor esse valor maior a probabilidade de elas s� serem marcadas como c�lulas de h�bitat caso haja uma c�lula de h�bitat vizinha. Para mais detalhes consultar c�digo.
  A regra de vizinhan�a vale tanto para defini��o do perfil de fragmenta��o da matriz, quanto para o c�lculo de n�mero de fragmentos.Isso quer dizer que regra de vizinhan�a NEI8=FALSE, ele para selecionar c�lulas de h�bitat que sejam vizinhas ser�o consideradas apenas as quatro c�lulas nas dire��es N, S, L, O. E fragmentos que se conectem apenas por c�lulas diagonais ser�o considerados fragmentos diferentes. 

Warning:
  Warning: Voc� n�o inseriu uma matriz bin�ria, portanto a fun��o ir� gerar uma matriz com o par�metros selecionados.

Author:
  Bruno Travassos-de-Britto
bruno.travassos@gmail.com

Reference:
  Fahrig L. When does fragmentation of breeding habitat affect population survival? Ecol.Model. 1998; 105: 273-92  
  
  Examples:
  #selecione uma matriz bin�ria de nome qualquer
  landscapeGen(minha.matriz,NEI8=T) # Gera uma interface gr�fica mostrando o perfil desta matriz e as suas propriedade (Tamanho em n�mero de celulas(TAMX x TAMY), area de cobertura de h�bitat (COVER),regra de vizinhan�a (NEI8), n�mero de fragmentos, tamanho do maior fragmento, tamanho do menor fragmento e tamanho m�dio dos fragmentos). Retorna um data frame contendo essas informa��es
  landscapeGen(TAMX=40, TAMY=30, COVER=0.2, FRAG=0.01, NEI8=F) # Gera uma paisagem retangular de lado horizontal 40 e lado vertica 30 (40x30= 1200 c�lulas). 20% dessas 1200 c�lulas ser�o de h�bitat, o �ndice de fragmenta��o ser� de 0.01, e a regra de vizinhan�a ser� 4.