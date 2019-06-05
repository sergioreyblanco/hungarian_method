

###############
### Implementation
###############

M <- 10000 #value big enough (change the number in order to suit your needs)

#Auxiliary function

solutionChecking <- function(matrix, solution, costMatrix){
  solutionAux <- solution
  foundSolutions <- list()
  flag_found = FALSE
  counter = 0
  previousDuplicate = -1
  duplicate = anyDuplicated(solutionAux[seq(2, 2*nrow(matrix), by = 2)])
  
  while(duplicate != 0){
    
    for(j in 1:ncol(matrix)){
      if(matrix[duplicate, j] == 0){
        counter = counter + 1
      }
      
      if(matrix[duplicate, j] == 0 && j != solutionAux[2*duplicate]){
        
        s<-solutionAux
        s[2*duplicate] = j
        flag_found = FALSE
        for(p in foundSolutions){
          paux <- as.vector(unlist(p))
          if(all(s == paux) == TRUE){
            flag_found = TRUE
            break
          }
        }
        if(flag_found == FALSE){
          solutionAux <- s
          
          foundSolutions[[length(foundSolutions)+1]] <- list(solutionAux)
          
          break
        }
      } 
      
    }
    
    if(anyDuplicated(solutionAux[seq(2, 2*nrow(matrix), by = 2)]) == 0){
      break
    }
    
    if(counter == 1){
      flag_found = TRUE
    }
    counter = 0
    
    if(flag_found == TRUE){
      
      for(i in 1:nrow(matrix)){
        for(j in 1:ncol(matrix)){
          
          if(matrix[i, j] == 0){
            s<-solutionAux
            s[2*(i-1)+1] <- i
            s[2*(i-1)+2] <- j
            flag_found = FALSE
            for(p in foundSolutions){
              paux<-as.vector(unlist(p))
              if(all(s == paux) == TRUE){
                flag_found = TRUE
                break
              }
            }
            if(flag_found == FALSE){
              solutionAux <- s
              break
            }
          }
        }
        if(flag_found == FALSE){
          break
        }
      }
      foundSolutions[[length(foundSolutions)+1]] <- list(solutionAux)
    }
    
    previousDuplicate = duplicate
    
    duplicate = anyDuplicated(solutionAux[seq(2, 2*nrow(matrix), by = 2)])
    
    if(previousDuplicate == duplicate){
      duplicate <- which(duplicated(solutionAux[seq(2, 2*nrow(matrix), by = 2)], fromLast = TRUE)==TRUE)[1]
    }
  }
  
  solutionValue = 0
  for(k in 1:nrow(A)){
    if(costMatrix[solutionAux[2*k-1],solutionAux[2*k]] != M){
      solutionValue = solutionValue + costMatrix[solutionAux[2*k-1],solutionAux[2*k]]
    }  
  }
  
  return(list("solution" = solutionAux, "cost" = solutionValue))
}



#Main function

assignmentSolver <- function(costMatrix){
  A <- costMatrix
  
  #Step 1: calculation fo reduced matrix
  
  #the minimum of each row is calculated and they are subtracted
  min = 10*M
  for(i in 1:nrow(A)){
    for(j in 1:ncol(A)){
      if(A[i, j] < min){
        min = A[i, j]
      }
    }
    A[i,] <- A[i,]-min
    
    min = 10*M
  }
  
  #the minimum of each column is calculated and they are subtracted
  min = 10*M
  for(j in 1:ncol(A)){
    for(i in 1:nrow(A)){
      if(A[i, j] < min){
        min = A[i, j]
      }
    }
    A[,j] <- A[,j]-min
    
    min = 10*M
  }
  
  while(TRUE){  
    #Step 2: zero strikethrough cross out  
    assignedRows <- list()
    assignedZeros <- list()
    alreadyCrossout <- list()
    for(i in 1:nrow(A)){
      for(j in 1:ncol(A)){
        if(A[i, j] == 0 && ((i-1)*ncol(A)+j) %in% alreadyCrossout == FALSE){
          assignedZeros <- c(assignedZeros, ((i-1)*ncol(A)+j))
          assignedRows <- c(assignedRows, i)
          if((i+1) < nrow(A)){
            for(k in (i+1):nrow(A)){
              if(A[k, j] == 0  && ((k-1)*ncol(A)+j) %in% alreadyCrossout == FALSE){
                alreadyCrossout<-c(alreadyCrossout, ((k-1)*ncol(A)+j))
              }
            }
          }
          
          break;
        }
      }
    }
    
    rowMarks <- list()
    columnMarks <- list()
    for(i in 1:nrow(A)){
      if(i %in% assignedRows == FALSE){
        rowMarks <- c(rowMarks, i)
      }
    }
    
    for(i in rowMarks){
      for(j in 1:ncol(A)){
        if(A[i, j] == 0 && j %in% columnMarks == FALSE){
          columnMarks <- c(columnMarks, j)
        }
      }
    }
    for(i in columnMarks){
      for(j in 1:nrow(A)){
        if(((j-1)*nrow(A)+i) %in% assignedZeros && j %in% rowMarks == FALSE){
          rowMarks <- c(rowMarks, j)
        }
      }
    }
    
    rowLines <- list()
    columnLines <- list()
    columnLines <- columnMarks
    for(i in 1:nrow(A)){
      if(i %in% rowMarks == FALSE){
        rowLines <- c(rowLines, i)
      }
    }
    
    if(length(rowLines) + length(columnLines) == nrow(A)){
      break;
    }else{
      #Step 3: reduced matrix is updated
      min = M
      for(i in 1:nrow(A)){
        for(j in 1:ncol(A)){
          if(A[i, j] < min && i %in% rowLines == FALSE && j %in% columnLines == FALSE){
            min = A[i, j]
          }
        }
      }
      for(i in 1:nrow(A)){
        for(j in 1:ncol(A)){
          if(i %in% rowLines == FALSE && j %in% columnLines == FALSE){
            A[i, j] <- A[i, j] - min
          } else if(i %in% rowLines == TRUE && j %in% columnLines == TRUE){
            A[i, j] <- A[i, j] + min
          } else if(i %in% rowLines == TRUE && j %in% columnLines == FALSE){
            A[i, j] <- A[i, j]
          } else if(i %in% rowLines == FALSE && j %in% columnLines == TRUE){
            A[i, j] <- A[i, j]
          }
        }
      }
    }
  }  
  
  #Step 4: selection of the solution
  solution <- c()
  for(i in 1:nrow(A)){
    for(j in 1:ncol(A)){
      if(A[i, j] == 0){
        solution <- c(solution, i, j)
        break
      }
    }
  }
  
  list <- solutionChecking(A, solution, costMatrix)
  
  return(list)
}



############
### Example 1
############

A<-matrix(nrow=5,ncol=5)
A[1,]<-c(-M, -M, 6, 4, 3)
A[2,]<-c(8, 6, 3, 7, 9)
A[3,]<-c(10, 10, 6, 9, 9)
A[4,]<-c(5, 5, 7, 2, 4)
A[5,]<-c(-M, -M, -M, -M, -M)
A<-A*(-1)
A


############
### Example 2
############

A<-matrix(nrow=5,ncol=5)
A[1,]<-c(4, 8, 8, 7, -M)
A[2,]<-c(9, 4, 8, 8, -M)
A[3,]<-c(4, 5, 4, 7, -M)
A[4,]<-c(6, 8, 10, 9, -M)
A[5,]<-c(8, 7, 5, 5, -M)
A<-A*(-1)
A

############
### Example 3
############

A<-matrix(nrow=5,ncol=5)
A[1,]<-c(2,3,5,1,4)
A[2,]<-c(-1,1,3,6,2)
A[3,]<-c(-2,4,3,5,0)
A[4,]<-c(1,3,4,1,4)
A[5,]<-c(7,1,2,1,2)
A



############
### Execution
############

assignmentSolver(A)
