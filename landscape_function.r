

landscapeGen = function(DATA=NA,TAMX=30,TAMY=30, FRAG=0.5, COVER=0.2, NEI8=F)
{
  AREA=(TAMX*TAMY)
  calcDist=function(i,j)# calcula distância entre duas células de uma matriz
  {
    dX=cells$cellX[i]-cells$cellX[j] # distancia em x. cateto1
    dY=cells$cellY[i]-cells$cellY[j] # distancia em y. cateto2
    dist=sqrt(dX*dX+dY*dY) # cateto² + cateto²= hipotenusa² (pitágoras)
    return(dist) #retorna a distância
  }

  if(is.na(DATA)==T) # se não for dada uma matriz binária ele irá gerar uma matriz com os dados abaixo
  {
  cat("Warning: Você não inseriu uma matriz binária, portanto a função irá gerar uma matriz com o parÂmetros selecionados.")
  cells=data.frame(X1.AREA=1:(TAMX*TAMY), isVoid=T, cellX=NA, cellY=NA, NFRAG=NA) #cria um dataframe com as células (unidades de espáço da paisagem) sendo as linhas e as colunas as propriedades de cada celula
  for (i in 1:TAMX){cells$cellX [((i*TAMY)-(TAMY-1)):(i*TAMY)] = i} # define as coordenadas x de cada célula
  cells$cellY=1:TAMY # define as coordenadas y de cada célula.

 #rotina que cria o padrão entre células de hábitat e não-hábitat (matriz)
  while(sum(cells$isVoid)>(AREA-AREA*COVER)) #enquanto o número de células de não-habitat for maior do que área total - a área de hábitat
    {
      ordem=sample(1:AREA) # sorteia a lista de células
      if (cells$isVoid[ordem[1]]==TRUE) # se a primeira célula da lista for de não hábitat
        {
          if(runif(1)<FRAG) # se um número aleatório entre 0-1 for menos que FRAG
            {
              cells$isVoid[ordem[1]]=F #então essa célula será de hábitat
            }
          else # caso contrário
            {
              if (NEI8==T){neighbors=cells$X1.AREA[which(calcDist(ordem[1],cells$X1.AREA)<2)]} # se se quer regra de vizinhança = 8,  define quem são as 8 células vizinhas com base nas coordenadas.
              else {neighbors=cells$X1.AREA[which(calcDist(ordem[1],cells$X1.AREA)<=1)]} #caso contrário, define quem são as 4 células vizinhas com base nas coordenadas
              if(sum(cells$isVoid[neighbors]==FALSE)>0){cells$isVoid[ordem[1]]=F} # se alguma das células vizinhas for de hábitat, transforme a célula selecionada em célula de hábitat
              #note que se o FRAG for alto, maior a probabilidade de as células de hábitat cairem independentes uma da outra na matriz,
              # e quanto menor maior a probabilidade de elas somente caírem agregadas.
            }
        }
    }
}
else # caso contrário
{
  TAMX=length(DATA[,1])# calcula o número de células na matriz
  TAMY=length(DATA[1,])
  COVER=table(DATA)[2]/length(DATA) # calcula a área de cobertura
  FRAG=NA # desconsidera o parametro de fragmentação já que a matriz não será criada
  cells=data.frame(X1.AREA=0, isVoid=0, cellX=NA, cellY=NA, NFRAG=NA) #cria um dataframe com as células (unidades de espáço da paisagem) sendo as linhas e as colunas as propriedades de cada celula
  # rotina para preencher o data frame cells com as informações das céluas da matriz dada
  for (i in 1:length(DATA[,1]))
  {
    for (j in 1:length(DATA[1,]))
    {
      cells=rbind(cells, c(length(cells$X1.AREA),DATA[i,j],i,j,NA)) #adiciona ao dataframe cells as propriedades das celulas de cordenadas i,j
    }
  }
  cells$isVoid=as.logical(cells$isVoid==0) #tranforma o vetor de binário em um vetor lógico
  cells=cells[-1,] #apaga a linha fantásma criada no dataframe
}

    Nfrags=0 #define um contador para o número de fragmentos que irão ser gerados
    fragsize=NA # define um contador para o tamanho dos fragmentos que serão gerados 
   
 # rotina que faz a contagem dos fragmentos
  while(sum(is.na(cells[which(cells$isVoid==F),]$NFRAG))>0) #enquanto o número de células de hábitat não tiver identidade de fragmento
   {
    
     Nfrags=Nfrags+1 # número de fragmento +1
     
   
     cells.mataNF=cells[which(is.na(cells$NFRAG)==T & cells$isVoid==F),] # crie um data frame com as céluas de hábitat sem identidade
     lista=cells.mataNF[1,] #coloque a primeira célula desse data frame em uma lista
     
     i=0 #crie um contador i
    
     while (i!=length(lista$X1.AREA)) #enquanto o contador i for diferente do comprimento da lista
      {
       
        i=i+1
        
        if(NEI8==F){neighbor=cells.mataNF[which(calcDist(lista$X1.AREA[i],cells.mataNF$X1.AREA[])==1),]} #com regra de vizinhança 4, defina os quatro vizinhos dessa célula que são de hábitat e não têm identidade de fragmento
        else{neighbor=cells.mataNF[which(calcDist(lista$X1.AREA[i],cells.mataNF$X1.AREA[])==1 | calcDist(lista$X1.AREA[i],cells.mataNF$X1.AREA[])==sqrt(2)),]} # com regra de vizinhança 8, idem ao de cima.
        lista=rbind(lista,neighbor) #adicione ao dataframe lista esses vizinhos
        lista$NFRAG=Nfrags # defina a identidade de célula de todas essas células como o contador Nfrag
        cells[lista$X1.AREA,]=lista # substitua as células específicas do dataframe principal de células pelas células do dataframe list,as quais receberam uma identidade de célula
        cells.mataNF=cells[which(is.na(cells$NFRAG)==T & cells$isVoid==F),] #a lista de células sem identidade agora é menor
        if(i==length(lista$X1.AREA)) #se o contador i é igual ao comprimento do dataframe lista (querendo dizer que as células desse fragmento já foram todas identificadas)
          {
          fragsize=c(fragsize,length(lista$X1.AREA)) # então a lista fragsize recebe o número de células que este fragmento possui.
        }
      }
    
   }

  Nfrags=max(cells$NFRAG, na.rm=T) # o número de fragmentos é igual ao maior número representando a identidade dos fragmentos
  Max_Size=max(fragsize,na.rm=T) #o valor máximo na lista fragsize é o número de células do maior fragmento
  Min_Size=min(fragsize,na.rm=T) #o valor mínimo na lista fragsize é o número de células do menor fragmento
  Mean_Size=mean(fragsize,na.rm=T) #a média da lista fragsize é o tamanhomédio dos fragmentos
  
  Landscape.DATA=data.frame(1,"AREA"=AREA,"FRAG"=FRAG,"COVER"=COVER,"NEI8"=NEI8) #constrói data frame onde os dados da paisagem serão armazenados.
 #adiciona os valores acima no dataframe com os dados da paisagem 
 Landscape.DATA=cbind(Landscape.DATA,Nfrags) 
  Landscape.DATA=cbind(Landscape.DATA,Max_Size)
  Landscape.DATA=cbind(Landscape.DATA,Min_Size)
  Landscape.DATA=cbind(Landscape.DATA,Mean_Size)
  #
  titulo=paste("AREA=",TAMX," X ",TAMY," | ", "COVER=",COVER," | ", "FRAG=", FRAG," | ", "NEI8=",NEI8) #título da interface
  result=paste("Number of fragments=",Nfrags,"\n", "Larger size=",Max_Size, "\n","Smaller size=",Min_Size,"\n", "Mean size=",Mean_Size) #resultado na interface
  plot(NA,main=titulo, xlab=result, ylab=NA,xlim=c(0,TAMX),ylim=c(0,TAMY), xaxt="n",yaxt="n") # plota um gráfico vazio e sem eixos, com o tamanho do eixo x e y iguais aos lados da paisagem
 
 #rotina que desenha cada uma das células da paisagem  
 for(i in cells$X1.AREA) # para todas as células no dataframe cells
    {
      if (cells$isVoid[i]==T){rect(col="pink",border=NA,xright=cells$cellX[i],xleft=cells$cellX[i]-1,ytop=cells$cellY[i],ybottom=cells$cellY[i]-1)} # se a célula i for de não hábitat desenho um quadrado sem borda e sem preenchimento da cordenada x,y para diagonal esquerda inferior
      else {rect(border=NA, xright=cells$cellX[i],xleft=cells$cellX[i]-1,ytop=cells$cellY[i],ybottom=cells$cellY[i]-1, col="green")} # caso contrário, desenho um quadrado sem borda e de cor verde a partir da cordenada x,y para diagonal esquerda inferior
    }
  
  cells$NFRAG=as.character(cells$NFRAG) # reclassifica a identidade das células como charactere
  for(i in cells$X1.AREA){text(labels=cells$NFRAG[i],cells$cellX[i]-.5,cells$cellY[i]-.5,cex=0.5)} # escreva a identidade de fragmento de cada célula dentro dos quadrados

  return(Landscape.DATA) # retorne o data frame com as informações da paisagem. 
}

