##ASSIGNMENT 2 - CACHING A FUNCTION
##===========================================
##caching <- storing data for a future use
##efficient way of writing R functions as
##using this method prevents
##duplication where vectors may be reused
##===========================================
##what is an invertible matrix
##http://en.wikipedia.org/wiki/Invertible_matrix
##===========================================




##function called makeCacheMatrix
#================================
##where vector x is defined as a matrix

makeCacheMatrix <- function(x = matrix()) {

	##initialising the vector x
	x <- NULL
	
		##create the matrix x with 2 rows, 2 columns
		##containing the number 1 to 4
		x <- matrix(1:4, nrow = 2, ncol = 2)

			##print matrix to screen
			x
}

##function called cacheSolve
#================================
##where the matrix x is reversed

cacheSolve <- function(x, ...) {

##summon the matrix x from memory
x <- x

	##has the matrix x been cached?
	if(!is.null(x) {
		message("getting cached matrix")
		return(x)
	}
	
		##reverse the matrix x	
		solve(x)

			##print matrix to screen
			x		
}


