library(tidyr)

n <- 25000000 # Number of ratings to import
s <- 2000000 # Number of random ratings to export
max_users <- 0 # Maximum number of users to be used
max_movies <- 0 # Maximum number of movies

# Retrieve raw ratings from csv
cat("Importing data...\n")
setwd("/home/naoise/Cáipéisí/Maynooth/Postdoc/Data")
cc <- c("integer", "integer", "numeric", "NULL")
tmovieRatings <- read.csv("raw_ratings.csv", header=T, nrows=n, colClasses=cc)
colnames(tmovieRatings) <- c("user", "movie", "rating")
cat("Data Imported\n")

# Select which ratings to be used
sel <- sort(sample(1:n, s))
movieRatings <- tmovieRatings[sel,]
movieRatings[,"rating"] <- as.integer(2*movieRatings[,"rating"]) # Reset ratings to integers
cat("Data randomly selected\n")

cat("Re-assigning user and movie ids\n")
# Re-assign user ids to ensure no empties
id = 0
while (sum(movieRatings[,"user"] > id) > 0)
{
  i = min(movieRatings[movieRatings[,"user"] >= id, "user"])
  if (i > id)
  {
    movieRatings[movieRatings[,"user"] == i, "user"] = id
  }
  id = id+1
}

# Remove users if max is specified
if (max_users > 0 && max(movieRatings[,"user"] > max_users))
{
  removeUsers = (movieRatings[,"user"] < max_users)
  movieRatings = movieRatings[removeUsers,]
}

cat("Users done, continuing to movies\n")

# Re-assign movie ids to ensure no empties
id = 0
while (sum(movieRatings[,"movie"] > id) > 0)
{
  i = min(movieRatings[movieRatings[,"movie"] >= id, "movie"])
  if (i > id)
  {
    movieRatings[movieRatings[,"movie"] == i,"movie"] = id
  }
  id = id+1
}

# Remove movies if max is specified
if (max_movies > 0 && max(movieRatings[,"movie"] > max_movies))
{
  movieRatings = movieRatings[movieRatings[,"movie"] < max_movies,]
}

# Re-assign user ids again to ensure no empties
id = 0
while (sum(movieRatings[,"user"] > id) > 0)
{
  i = min(movieRatings[movieRatings[,"user"] >= id, "user"])
  if (i > id)
  {
    movieRatings[movieRatings[,"user"] == i, "user"] = id
  }
  id = id+1
}

cat("Writing data...\n")
write(movieRatings[, "rating"], "ratings.txt", ncolumns=s)
write(movieRatings[, "user"], "users.txt", ncolumns=s)
write(movieRatings[, "movie"], "movies.txt", ncolumns=s)
cat("All done\n")
