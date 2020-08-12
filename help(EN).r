LandscapeGen package:-- R documentation

GENERATES AND / OR ANALYSIS BINARY LANDSCAPES

Description:
  Generates and/or analyzes a two-dimensional binary landscape, with FRAG fragmentation level. Returns a graphical interface displaying the landscape profile and the values for the number of fragments, the size of the largest and smallest fragments and the average size of the fragments.

Use:
  laçndscapeGen (DATA = NA, TAMX = 30, TAMY = 30, FRAG = 0.5, COVER = 0.2, NEI8 = FALSE)

Arguments:
  DATE Binary matrix (0 or 1). If NA, a function will generate a landscape with the given arguments.
  TAMX Integer defining the number of cells on the x-axis of the landscape. Definition is not necessary if DATE is a binary matrix.
  TAMY Integer defining the number of cells on the axis and the landscape. Definition is not necessary if DATE is a binary matrix.
  FRAG Number between '0' and '1', not including '0' defining the level of fragmentation.Definition is not necessary if DATA a binary matrix
  COVER Number between '0' and '1' defining a proportion of the landscape that will be considered as habitat. Definition is not necessary if DATE is a binary matrix
  NEI8 Logical variable defining the cell neighborhood rule. TRUE indicates that the eight neihboring cells will be considered neighbors of an specific cell. FALSE indicates that only four neighboring cells will be considered neighbors.

Details:
  The level of fragmentation is given by a modified algorithm presented by Fahrig (1998). In summary, the higher the level of fragmentation the greater the probability of habitat cells being randomly created in the landscape, the lower this value the greater the likelihood that they will only be marked as habitat cells if there is a neighboring habitat cell. For more details see code.
  The neighborhood rule applies both to defining the matrix fragmentation profile and to calculating the number of fragments. This means that the neighborhood rule NEI8 = FALSE, it to select neighboring habitat cells will be considered only as four cells in the N, S, L, O cells. And fragments that connect only by diagonal cells treat different fragments.

Warning:
  Warning: You did not enter a binary matrix, so a function will generate a landscape with the selected parameters.

Author:
  Bruno Travassos-Britto
bruno.travassos@gmail.com

reference:
  Fahrig L. When does fragmentation of the breeding habitat affect population survival? Ecol.Model. 1998; 105: 273-92
  
  Examples:
  #select a binary matrix of any name
  landscapeGen (my.matrix, NEI8 = T) # Generates a graphical interface showing the profile of this matrix and how its property (Size in number of cells (TAMX x TAMY), habitat coverage area (COVER), neighborhood rule (NEI8 ), number of fragments, size of the largest fragment, size of the smallest fragment and average size of the fragments). Returns a data frame containing this information
  landscapeGen (TAMX = 40, TAMY = 30, COVER = 0.2, FRAG = 0.01, NEI8 = F) # Generates a rectangular landscape with horizontal side 40 and vertical side 30 (40x30 = 1200 cells). 20% of these 1200 cells will be habitats, the fragmentation index will be 0.01, and the neighborhood rule will be 4.
