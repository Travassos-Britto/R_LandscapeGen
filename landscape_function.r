landscapeGen = function(DATA=NA, TAMX=30, TAMY=30, FRAG=0.5, COVER=0.2, NEI8=F) {
  AREA = (TAMX * TAMY)
  
  calcDist = function(i, j) { # Calculate distance between two cells in a matrix
    dX = cells$cellX[i] - cells$cellX[j] # X distance. Cathetus 1
    dY = cells$cellY[i] - cells$cellY[j] # Y distance. Cathetus 2
    dist = sqrt(dX * dX + dY * dY) # cathetus² + cathetus² = hypotenuse² (Pythagorean theorem)
    return(dist) # return the distance
  }
  
  if (is.na(sum(DATA)) == T) { # If a binary matrix is not given, it will generate a matrix with the selected parameters.
    cat("Warning: You did not input a binary matrix, so the function will generate a matrix with the selected parameters.")
    cells = data.frame(X1.AREA=1:(TAMX*TAMY), isVoid=T, cellX=NA, cellY=NA, NFRAG=NA) # Create a dataframe with cells (units of landscape space) as rows and properties of each cell as columns
    for (i in 1:TAMX) { cells$cellX[((i*TAMY)-(TAMY-1)):(i*TAMY)] = i } # Define the x coordinates of each cell
    cells$cellY = 1:TAMY # Define the y coordinates of each cell
    
    # Routine that creates the pattern between habitat and non-habitat cells (matrix)
    while (sum(cells$isVoid) > (AREA - AREA * COVER)) { # While the number of non-habitat cells is greater than total area - habitat area
      ordem = sample(1:AREA) # Shuffle the list of cells
      if (cells$isVoid[ordem[1]] == TRUE) { # If the first cell in the list is non-habitat
        if (runif(1) < FRAG) { # If a random number between 0-1 is less than FRAG
          cells$isVoid[ordem[1]] = F # Then this cell will be a habitat cell
        } else { # Otherwise
          if (NEI8 == T) {
            neighbors = cells$X1.AREA[which(calcDist(ordem[1], cells$X1.AREA) < 2)] # If 8-neighborhood rule is desired, define the 8 neighboring cells based on coordinates.
          } else {
            neighbors = cells$X1.AREA[which(calcDist(ordem[1], cells$X1.AREA) <= 1)] # Otherwise, define the 4 neighboring cells based on coordinates.
          }
          if (sum(cells$isVoid[neighbors] == FALSE) > 0) { cells$isVoid[ordem[1]] = F } # If any of the neighboring cells are habitat, transform the selected cell into a habitat cell
          # Note that higher FRAG increases the probability of habitat cells falling independently on the matrix, while lower FRAG increases the probability of them being aggregated.
        }
      }
    }
  }
  
  if (is.na(sum(DATA)) == F) { # Otherwise
    TAMX = length(DATA[,1]) # Calculate the number of cells in the matrix
    TAMY = length(DATA[1,])
    COVER = table(DATA)[2] / length(DATA) # Calculate the coverage area
    FRAG = NA # Ignore the fragmentation parameter since the matrix is given
    cells = data.frame(X1.AREA = 0, isVoid = 0, cellX = NA, cellY = NA, NFRAG = NA) # Create a dataframe with cells (units of landscape space) as rows and properties of each cell as columns
    
    # Routine to fill the cells dataframe with information from the given matrix
    for (i in 1:length(DATA[,1])) {
      for (j in 1:length(DATA[1,])) {
        cells = rbind(cells, c(length(cells$X1.AREA), DATA[i,j], i, j, NA)) # Add cell properties with coordinates i,j to the cells dataframe
      }
    }
    cells$isVoid = as.logical(cells$isVoid == 0) # Convert the binary vector to a logical vector
    cells = cells[-1,] # Remove the phantom row created in the dataframe
  }
  
  Nfrags = 0 # Set a counter for the number of fragments to be generated
  fragsize = NA # Set a counter for the size of the fragments to be generated
  
  # Routine that counts the fragments
  while (sum(is.na(cells[which(cells$isVoid == F),]$NFRAG)) > 0) { # While there are habitat cells without fragment identity
    Nfrags = Nfrags + 1 # Increment fragment count
    
    cells.mataNF = cells[which(is.na(cells$NFRAG) == T & cells$isVoid == F),] # Create a dataframe with habitat cells without fragment identity
    lista = cells.mataNF[1,] # Put the first cell of this dataframe in a list
    
    i = 0 # Set a counter i
    
    while (i != length(lista$X1.AREA)) { # While the counter i is not equal to the length of the list
      i = i + 1
      
      if (NEI8 == F) { 
        neighbor = cells.mataNF[which(calcDist(lista$X1.AREA[i], cells.mataNF$X1.AREA[]) == 1),] # With 4-neighborhood rule, define the four neighbors of this cell that are habitat cells and have no fragment identity
      } else {
        neighbor = cells.mataNF[which(calcDist(lista$X1.AREA[i], cells.mataNF$X1.AREA[]) == 1 | calcDist(lista$X1.AREA[i], cells.mataNF$X1.AREA[]) == sqrt(2)),] # With 8-neighborhood rule, same as above.
      }
      lista = rbind(lista, neighbor) # Add these neighbors to the list dataframe
      lista$NFRAG = Nfrags # Set the fragment identity for all these cells as Nfrags counter
      cells[lista$X1.AREA,] = lista # Replace specific cells in the main cells dataframe with the cells from the list dataframe, which now have a fragment identity
      cells.mataNF = cells[which(is.na(cells$NFRAG) == T & cells$isVoid == F),] # The list of cells without fragment identity is now smaller
      if (i == length(lista$X1.AREA)) { # If the counter i equals the length of the list dataframe (meaning all cells of this fragment have been identified)
        fragsize = c(fragsize, length(lista$X1.AREA)) # Then add the number of cells in this fragment to the fragsize list
      }
    }
  }
  
  Nfrags = max(cells$NFRAG, na.rm=T) # The number of fragments is equal to the largest number representing the fragment identity
  Max_Size = max(fragsize, na.rm=T) # The maximum value in the fragsize list is the number of cells in the largest fragment
  Min_Size = min(fragsize, na.rm=T) # The minimum value in the fragsize list is the number of cells in the smallest fragment
  Mean_Size = mean(fragsize, na.rm=T) # The average of the fragsize list is the mean size of the fragments
  
  Landscape.DATA = data.frame(1, "AREA" = AREA, "FRAG" = FRAG, "COVER" = COVER, "NEI8" = NEI8) # Construct a data frame to store landscape data.
  # Add the above values to the landscape data frame
  Landscape.DATA = cbind(Landscape.DATA, Nfrags)
  Landscape.DATA = cbind(Landscape.DATA, Max_Size)
  Landscape.DATA = cbind(Landscape.DATA, Min_Size)
  Landscape.DATA = cbind(Landscape.DATA, Mean_Size)
  
  titulo = paste("AREA=", TAMX, " X ", TAMY, " | ", "COVER=", COVER, " | ", "FRAG=", FRAG, " | ", "NEI8=", NEI8) # Interface title
  result = paste("Number of fragments=", Nfrags, "\n", "Larger size=", Max_Size, "\n", "Smaller size=", Min_Size, "\n", "Mean size=", Mean_Size) # Interface result
  plot(NA, main=titulo, xlab=result, ylab=NA, xlim=c(0, TAMX), ylim=c(0, TAMY), xaxt="n", yaxt="n") # Plot an empty graph without axes, with x and y axis size equal to the landscape sides
  
  # Routine to draw each of the landscape cells
  for (i in cells$X1.AREA) { # For all cells in the cells dataframe
    if (cells$isVoid[i] == T) {
      rect(col="pink", border=NA, xright=cells$cellX[i], xleft=cells$cellX[i]-1, ytop=cells$cellY[i], ybottom=cells$cellY[i]-1) # If the cell is non-habitat, draw a square without border and without fill from coordinate x,y to lower left diagonal
    } else {
      rect(border=NA, xright=cells$cellX[i], xleft=cells$cellX[i]-1, ytop=cells$cellY[i], ybottom=cells$cellY[i]-1, col="green") # Otherwise, draw a square without border and with green color from coordinate x,y to lower left diagonal
    }
  }
  
  cells$NFRAG = as.character(cells$NFRAG) # Reclassify the cell identities as characters
  for (i in cells$X1.AREA) {
    text(labels=cells$NFRAG[i], cells$cellX[i]-.5, cells$cellY[i]-.5, cex=0.5) # Write the fragment identity of each cell inside the squares
  }
  
  return(Landscape.DATA) # Return the data frame with landscape information.
}

