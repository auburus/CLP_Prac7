# Sample K-Means #
This is a project that helped learning the implementation of the K-Means algorithm,
with the difference of also calculating the covariance matrix of each
cluster, and use it through the [mahalanobis distance](https://en.wikipedia.org/wiki/Mahalanobis_distance)
to decide which elements belongs to each cluster.

### Installation ###
To install this repo, clone it and open the directory with matlab or octave (yes,
it's octave's compatible :blush:).
```
git clone https://jordi_nonell@bitbucket.org/jordi_nonell/clp-kmeans.git
```

## Basic usage ##
There are two "basic" uses of this program, one to check that the clustering
kind of works, and another one to colour compress an image to N colors.

#### Check clustering ####
Type the following in the octave/matlab console.
```
[Db, C] = CLP_getDb(1000);
[Cent, Labels, Variances] = CLP_KMeans(Db, C);
```
The first line generates a random set of points gaussian distributed, among
C gaussians.
The second line, groups this points of the `Db` into `C` clusters. Of course, you
can check diferents values of `C` in this line to observe diferent responses.
In the `CLP_KMeans` function, there is a parameter called `threshold` which
decides the minimum variability of centroids to say it has converged. (In this
case it should have a value of `0.000001` or similar).

This will show two plots, the first one being the db points, each which it's cluster
color, and in red the centroids position during all the iterations of the algorthm.

#### Clusterize image ####
Type the following in the octave/matlab console:
``` 
[Db, Width] = CLP_dbFromImg("icon-sync.png");
[Cent, Labels, Variances] = CLP_KMeans(db, 4);
[Image] = CLP_ImgFromLabels(Cent, Labels, Width);
```
Remind to change the CLP_KMeans `threshold` parameter to something more or less
big, like `1`.

This will plot 4 images, the first 3 with only the R, the G or the B bytes, and
the last one is the original image, where each pixel's color has been changed
for the cluster centroid colour.
