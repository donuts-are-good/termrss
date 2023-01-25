#!/usr/bin/env bash

# experiment with reading rss feeds in bash
# for my friend wolf

# MIT license and all that jazz

# make a list of feeds 
# put each feed on a newline
# put it in a file called feeds.txt

# make an array for titles and links
declare -a titles_links

# make in index counter variable to count our iterations
counter=1

# iterate through our list of feeds
while read -r feed; do

  # make a variable for the command to curl this feed in the list
  content=$(curl -s "$feed")

  # make variables for the feed and item title and link of each feed item top link
  feed_title=$(xmlstarlet sel -t -v "//channel/title" -n <(curl -s "$feed"))
  title=$(xmlstarlet sel -t -v "//item[1]/title" -n <(curl -s "$feed"))
  link=$(xmlstarlet sel -t -v "//item[1]/link" -n <(curl -s "$feed"))

  # put this feed item in the array
  titles_links+=("$counter: Feed: $feed_title\n   Title: $title\n   URL: $link")

  # increment our index
  ((counter++))
done < feeds.txt

# print each feed item with the index
echo "Select an article to read:"
for i in "${titles_links[@]}"; do
  echo -e "$i"
done

# ask the user to enter the index number of the feed item they want to read
read -p "Enter the index number: " index_num

# get the feed item they asked for
selected_title_link="${titles_links[index_num-1]}"

# open the link in a suitable terminal browsser
awk '{system("lynx "$3)}' <<< "$selected_title_link"
