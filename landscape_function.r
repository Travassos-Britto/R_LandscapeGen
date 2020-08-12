

landscapeGen = function(DATA=NA,TAMX=30,TAMY=30, FRAG=0.5, COVER=0.2, NEI8=F)
{
  AREA=(TAMX*TAMY)
  calcDist=function(i,j)# calcula dist�ncia entre duas c�lulas de uma matriz
  {
    dX=cells$cellX[i]-cells$cellX[j] # distancia em x. cateto1
    dY=cells$cellY[i]-cells$cellY[j] # distancia em y. cateto2
    dist=sqrt(dX*dX+dY*dY) # cateto� + cateto�= hipotenusa� (pit�goras)
    return(dist) #retorna a dist�ncia
  }

  if(is.na(DATA)==T) # se n�o for dada uma matriz bin�ria ele ir� gerar uma matriz com os dados abaixo
  {
  cat("Warning: Voc� n�o inseriu uma matriz bin�ria, portanto a fun��o ir� gerar uma matriz com o par�metros selecionados.")
  cells=data.frame(X1.AREA=1:(TAMX*TAMY), isVoid=T, cellX=NA, cellY=NA, NFRAG=NA) #cria um dataframe com as c�lulas (unidades de esp��o da paisagem) sendo as linhas e as colunas as propriedades de cada celula
  for (i in 1:TAMX){cells$cellX [((i*TAMY)-(TAMY-1)):(i*TAMY)] = i} # define as coordenadas x de cada c�lula
  cells$cellY=1:TAMY # define as coordenadas y de cada c�lula.

 #rotina que cria o padr�o entre c�lulas de h�bitat e n�o-h�bitat (matriz)
  while(sum(cells$isVoid)>(AREA-AREA*COVER)) #enquanto o n�mero de c�lulas de n�o-habitat for maior do que �rea total - a �rea de h�bitat
    {
      ordem=sample(1:AREA) # sorteia a lista de c�lulas
      if (cells$isVoid[ordem[1]]==TRUE) # se a primeira c�lula da lista for de n�o h�bitat
        {
          if(runif(1)<FRAG) # se um n�mero aleat�rio entre 0-1 for menos que FRAG
            {
              cells$isVoid[ordem[1]]=F #ent�o essa c�lula ser� de h�bitat
            }
          else # caso contr�rio
            {
              if (NEI8==T){neighbors=cells$X1.AREA[which(calcDist(ordem[1],cells$X1.AREA)<2)]} # se se quer regra de vizinhan�a = 8,  define quem s�o as 8 c�lulas vizinhas com base nas coordenadas.
              else {neighbors=cells$X1.AREA[which(calcDist(ordem[1],cells$X1.AREA)<=1)]} #caso contr�rio, define quem s�o as 4 c�lulas vizinhas com base nas coordenadas
              if(sum(cells$isVoid[neighbors]==FALSE)>0){cells$isVoid[ordem[1]]=F} # se alguma das c�lulas vizinhas for de h�bitat, transforme a c�lula selecionada em c�lula de h�bitat
              #note que se o FRAG for alto, maior a probabilidade de as c�lulas de h�bitat cairem independentes uma da outra na matriz,
              # e quanto menor maior a probabilidade de elas somente ca�rem agregadas.
            }
        }
    }
}
else # caso contr�rio
{
  TAMX=length(DATA[,1])# calcula o n�mero de c�lulas na matriz
  TAMY=length(DATA[1,])
  COVER=table(DATA)[2]/length(DATA) # calcula a �rea de cobertura
  FRAG=NA # desconsidera o parametro de fragmenta��o j� que a matriz n�o ser� criada
  cells=data.frame(X1.AREA=0, isVoid=0, cellX=NA, cellY=NA, NFRAG=NA) #cria um dataframe com as c�lulas (unidades de esp��o da paisagem) sendo as linhas e as colunas as propriedades de cada celula
  # rotina para preencher o data frame cells com as informa��es das c�luas da matriz dada
  for (i in 1:length(DATA[,1]))
  {
    for (j in 1:length(DATA[1,]))
    {
      cells=rbind(cells, c(length(cells$X1.AREA),DATA[i,j],i,j,NA)) #adiciona ao dataframe cells as propriedades das celulas de cordenadas i,j
    }
  }
  cells$isVoid=as.logical(cells$isVoid==0) #tranforma o vetor de bin�rio em um vetor l�gico
  cells=cells[-1,] #apaga a linha fant�sma criada no dataframe
}

    Nfrags=0 #define um contador para o n�mero de fragmentos que ir�o ser gerados
    fragsize=NA # define um contador para o tamanho dos fragmentos que ser�o gerados 
   
 # rotina que faz a contagem dos fragmentos
  while(sum(is.na(cells[which(cells$isVoid==F),]$NFRAG))>0) #enquanto o n�mero de c�lulas de h�bitat n�o tiver identidade de fragmento
   {
    
     Nfrags=Nfrags+1 # n�mero de fragmento +1
     
   
     cells.mataNF=cells[which(is.na(cells$NFRAG)==T & cells$isVoid==F),] # crie um data frame com as c�luas de h�bitat sem identidade
     lista=cells.mataNF[1,] #coloque a primeira c�lula desse data frame em uma lista
     
     i=0 #crie um contador i
    
     while (i!=length(lista$X1.AREA)) #enquanto o contador i for diferente do comprimento da lista
      {
       
        i=i+1
        
        if(NEI8==F){neighbor=cells.mataNF[which(calcDist(lista$X1.AREA[i],cells.mataNF$X1.AREA[])==1),]} #com regra de vizinhan�a 4, defina os quatro vizinhos dessa c�lula que s�o de h�bitat e n�o t�m identidade de fragmento
        else{neighbor=cells.mataNF[which(calcDist(lista$X1.AREA[i],cells.mataNF$X1.AREA[])==1 | calcDist(lista$X1.AREA[i],cells.mataNF$X1.AREA[])==sqrt(2)),]} # com regra de vizinhan�a 8, idem ao de cima.
        lista=rbind(lista,neighbor) #adicione ao dataframe lista esses vizinhos
        lista$NFRAG=Nfrags # defina a identidade de c�lula de todas essas c�lulas como o contador Nfrag
        cells[lista$X1.AREA,]=lista # substitua as c�lulas espec�ficas do dataframe principal de c�lulas pelas c�lulas do dataframe list,as quais receberam uma identidade de c�lula
        cells.mataNF=cells[which(is.na(cells$NFRAG)==T & cells$isVoid==F),] #a lista de c�lulas sem identidade agora � menor
        if(i==length(lista$X1.AREA)) #se o contador i � igual ao comprimento do dataframe lista (querendo dizer que as c�lulas desse fragmento j� foram todas identificadas)
          {
          fragsize=c(fragsize,length(lista$X1.AREA)) # ent�o a lista fragsize recebe o n�mero de c�lulas que este fragmento possui.
        }
      }
    
   }

  Nfrags=max(cells$NFRAG, na.rm=T) # o n�mero de fragmentos � igual ao maior n�mero representando a identidade dos fragmentos
  Max_Size=max(fragsize,na.rm=T) #o valor m�ximo na lista fragsize � o n�mero de c�lulas do maior fragmento
  Min_Size=min(fragsize,na.rm=T) #o valor m�nimo na lista fragsize � o n�mero de c�lulas do menor fragmento
  Mean_Size=mean(fragsize,na.rm=T) #a m�dia da lista fragsize � o tamanhom�dio dos fragmentos
  
  Landscape.DATA=data.frame(1,"AREA"=AREA,"FRAG"=FRAG,"COVER"=COVER,"NEI8"=NEI8) #constr�i data frame onde os dados da paisagem ser�o armazenados.
 #adiciona os valores acima no dataframe com os dados da paisagem 
 Landscape.DATA=cbind(Landscape.DATA,Nfrags) 
  Landscape.DATA=cbind(Landscape.DATA,Max_Size)
  Landscape.DATA=cbind(Landscape.DATA,Min_Size)
  Landscape.DATA=cbind(Landscape.DATA,Mean_Size)
  #
  titulo=paste("AREA=",TAMX," X ",TAMY," | ", "COVER=",COVER," | ", "FRAG=", FRAG," | ", "NEI8=",NEI8) #t�tulo da interface
  result=paste("Number of fragments=",Nfrags,"\n", "Larger size=",Max_Size, "\n","Smaller size=",Min_Size,"\n", "Mean size=",Mean_Size) #resultado na interface
  plot(NA,main=titulo, xlab=result, ylab=NA,xlim=c(0,TAMX),ylim=c(0,TAMY), xaxt="n",yaxt="n") # plota um gr�fico vazio e sem eixos, com o tamanho do eixo x e y iguais aos lados da paisagem
 
 #rotina que desenha cada uma das c�lulas da paisagem  
 for(i in cells$X1.AREA) # para todas as c�lulas no dataframe cells
    {
      if (cells$isVoid[i]==T){rect(col="pink",border=NA,xright=cells$cellX[i],xleft=cells$cellX[i]-1,ytop=cells$cellY[i],ybottom=cells$cellY[i]-1)} # se a c�lula i for de n�o h�bitat desenho um quadrado sem borda e sem preenchimento da cordenada x,y para diagonal esquerda inferior
      else {rect(border=NA, xright=cells$cellX[i],xleft=cells$cellX[i]-1,ytop=cells$cellY[i],ybottom=cells$cellY[i]-1, col="green")} # caso contr�rio, desenho um quadrado sem borda e de cor verde a partir da cordenada x,y para diagonal esquerda inferior
    }
  
  cells$NFRAG=as.character(cells$NFRAG) # reclassifica a identidade das c�lulas como charactere
  for(i in cells$X1.AREA){text(labels=cells$NFRAG[i],cells$cellX[i]-.5,cells$cellY[i]-.5,cex=0.5)} # escreva a identidade de fragmento de cada c�lula dentro dos quadrados

  return(Landscape.DATA) # retorne o data frame com as informa��es da paisagem. 
}

