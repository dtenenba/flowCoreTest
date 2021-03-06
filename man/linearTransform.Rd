\name{linearTransform}
\alias{linearTransform}

\title{Create the definition of a linear transformation function to be applied on a data set }
\description{Create the definition of the linear Transformation that will be
  applied on some parameter via the \code{transform} method. 
  The definition of this function is currently  x <- a*x+b
}
\usage{
linearTransform(transformationId="defaultLinearTransform", a = 1, b = 0)
}

\arguments{
  \item{transformationId}{character string to identify the transformation }
  \item{a}{double that corresponds to the multiplicative factor in the equation}
  \item{b}{double that corresponds to the additive factor in the equation}
}
\value{
  Returns an object of class \code{transform}.
}

\author{ N. LeMeur }

\seealso{ \code{\link{transform-class}}, \code{\link{transform}}}
\examples{
samp <- read.FCS(system.file("extdata",
   "0877408774.B08", package="flowCore"))
  linearTrans <- linearTransform(transformationId="Linear-transformation", a=2, b=0)
  dataTransform <- transform(samp,`FSC-H`=linearTrans(`FSC-H`))

}

\keyword{methods}

