# A function to find the optimal threshold that should be used to split a node
find.cut.point <- function(X, y, x.ix, k, w = NULL)
{
  recheck = 0
  n = nrow(X)
  p = ncol(X)
  
  # If no weights passed, set them all to one
  if (is.null(w))
  {
    w = rep(1,n)
  }
  n.total = sum(w)
  
  # Split into chunks
  #q = unique(quantile(x.ix, c(1:(k)/(k+1))))
  q = seq(min(x.ix), max(x.ix), length.out = k)
  k = length(q)
  q = c(-Inf, q, Inf)
  
  # Form the sufficient statistic set
  XtX = list()
  Xty = list()
  yty = rep(0,k+1)
  n.s = rep(0,k+1)
  
  XtX.left  = matrix(0,p,p)
  Xty.left  = matrix(0,p,1)
  XtX.right = matrix(0,p,p)
  Xty.right = matrix(0,p,1)
  yty.left  = 0
  yty.right = 0
  
  b.left  = matrix(0,p,k)
  b.right = matrix(0,p,k)
  
  RSS.left = matrix(0,k,1)
  RSS.right = matrix(0,k,1)
  RSS  = matrix(0,k,1)
  
  n.left = 0
  n.right = n.total
  
  # Build a weight matrix
  W = matrix(rep(w,p),n,p)
  
  for (i in 1:(k+1))
  {
    ix = which( x.ix>=q[[i]] & x.ix<q[[i+1]] )
    
    if(length(ix) == 1){
      XtX[[i]] = crossprod(t(as.matrix(X[ix,]*w[ix])), t(as.matrix(X[ix,])))
      Xty[[i]] = t(t(X[ix,]*y[ix]*w[ix]))
    }else{
      XtX[[i]] = crossprod(X[ix,]*W[ix,],X[ix,])
      Xty[[i]] = crossprod(X[ix,],w[ix]*y[ix])
    }
    
    yty[i] = sum(y[ix]^2*w[ix])
    
    XtX.right = XtX.right + XtX[[i]]
    Xty.right = Xty.right + Xty[[i]] 
    yty.right = yty.right + yty[i]
    
    n.s[i] = sum(w[ix])
  }
  
  # Do the partitioning
  for (i in 1:k)
  {
    XtX.left = XtX.left + XtX[[i]]
    Xty.left = Xty.left + Xty[[i]]
    yty.left = yty.left + yty[i]
    n.left   = n.left + n.s[i]
    
    XtX.right = XtX.right - XtX[[i]]
    Xty.right = Xty.right - Xty[[i]]
    yty.right = yty.right - yty[i]
    n.right   = n.right - n.s[i]
    
    if((n.left > ncol(X)) & (n.right > ncol(X))){ 
      
      tryCatch({
        b.left[,i]  = solve(XtX.left, Xty.left, tol = 1e-30)
        b.right[,i] = solve(XtX.right, Xty.right, tol = 1e-30)
        
        # Compute the RSS
        RSS.left[i] = yty.left -2*t(b.left[,i])%*%Xty.left + t(b.left[,i]) %*% XtX.left %*% b.left[,i]
        RSS.right[i] = yty.right -2*t(b.right[,i])%*%Xty.right + t(b.right[,i]) %*% XtX.right %*% b.right[,i]
      },error = function(e) {
        recheck <<- recheck + 1
        b.left[,i] <<- Inf
        b.right[,i] <<- Inf
        RSS.left[i] <<- Inf
        RSS.right[i] <<- Inf
      })
    }else{
      b.left[,i]  = Inf
      b.right[,i] = Inf
      RSS.left[i] = Inf
      RSS.right[i] = Inf
    }
  }
  
  # Find the best split and return it
  cutpoint.penalty = log(k)
  
  RSS  = RSS.left + RSS.right
  I = which.min(RSS)
  
  # Create a "linear model"
  r.left = list()
  r.left$beta0 <- 0 
  r.left$beta <- b.left[1:(p),I] 
  r.left$RSS = RSS.left[I]
  r.left$n = sum(n.s[1:I])
  
  class(r.left) = "my.lm"  
  
  r.right = list()
  r.right$beta0 <- 0 
  r.right$beta <- b.right[1:(p),I] 
  r.right$RSS = RSS.right[I]
  r.right$n = sum(n.s[(I+1):length(n.s)])
  
  class(r.right) = "my.lm"  
  
  
  return(list(I = I, 
              cut.point = q[I+1],
              n.left = r.left$n,
              n.right = r.right$n,
              b.left = b.left[,I],
              b.right = b.right[,I],
              RSS.left = RSS.left[I],
              RSS.right = RSS.right[I],
              RSS = RSS,
              cutpoint.penalty = cutpoint.penalty,
              left.model = r.left,
              right.model = r.right,
              ix.left = x.ix<=q[[I+1]],
              q = q[2:(length(q)-1)],
              need_recheck = recheck
  ))
}


predict_my_lm <- function (rv, X)
{
  if (!is(rv, "my.lm"))
  {
    stop("This predict method requires a my.lm object")
  }
  
  X %*% rv$beta + rv$beta0
}


