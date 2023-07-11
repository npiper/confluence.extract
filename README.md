# Confluence Extract

Based on the article in Asciidoc of how to migrate from Confluence XHTML to Asciidoc.

[Asciidoc migrate from Confluence XHTML to Asciidoc](https://docs.asciidoctor.org/asciidoctor/latest/migrate/confluence-xhtml/)

Concept is to create an Atlassian CLI image with the required setup to do this and perform the migration in one Docker image and process.

## Pre-Requisites

### Docker

#### Build the image

```
docker build -t npiper/bobswift-cli . > output.txt 2>&1
```

#### Setup the Server and Authentication in a Local Env variable

First put your token in an Environment variable called 'CONFLUENCE_TOKEN' we will then refer to it.

In the line below replace 'https://yourdomain.atlassian.net' with your Confluence cloud Wiki URL. The 'confluenceuser@solveapuzzle' with your user email.

```
export details_confluence="confluencecloud -s https://yourdomain.atlassian.net/wiki -u confluencuser@solveapuzzle --token '${CONFLUENCE_TOKEN}'"

```

#### Run the docker image with the environment variable

As per the Bobswift instructions you can then use `$exampleger` or something similar when in Docker to execute using the required authentication and server details you will target the export at.

```
docker run -e examplegear=$details_confluence -v $(pwd):/opt/acli/data -ti npiper/bobswift-cli /bin/bash
```

Example from Bobswift Documentation for JIRA:
```
$ docker run -e examplegear='jira -s https://examplegear.atlassian.net -u anonymous' -ti bobswiftapps/acli:latest /bin/bash
bash-4.4# acli ${examplegear} -a getServerInfo
Jira version: 1001.0.0-SNAPSHOT, build: 100207, time: 10/7/22, 3:33 AM, description: Appfire Example Gear Jira, url: https://examplegear.atlassian.net

```


### Confluence Access and a Personal token

To login and extract the pages or perform the bulk `exportSpace` command needed you will need a Confluence cloud personal access token.


### Confluence Space Permissions

To perform the export of a space using the Bob Swift Atlassian Confluence CLI, you need to have the appropriate permissions within Confluence. The required permissions are as follows:

View Space: You must have permission to view the space you want to export. This permission allows you to access the content and attachments within the space.

Export Space: You need the "Export Space" permission to be able to export the space using the CLI. By default, this permission is granted to the "Confluence Administrators" and "Space Administrators" groups. If you are not a member of these groups, the space administrator or a Confluence administrator can grant you this permission.


## Dockerfile addtions

### Groovy

Groovy is needed to perform some post processing on the exported HTML via a provided script.

### Pandoc

Pandoc is used in the Groovy script to execute conversions.

### Mount a './data' directory

Mounting location for a `./data/ directory so the resultant files can be copied to the working directory of a developer machine or build location for packaging / exporting after the export and script runs.


## Setting up environment variables

```
examplegear='jira -s https://examplegear.atlassian.net -u anonymous'
export deloitte_confluence="confluencecloud -s https://yourconfluence.atlassian.net/wiki -u confluenceuser@solveapuzlledev -token $CONFLUENCE_TOKEN"
```

```
acli confluencecloud --server https://yourconfluence.atlassian.net/wiki --user confluenceuser@solveapuzzledev --token '${CONFLUENCE_TOKEN}' -a getServerInfo
```

## Get Space Info

```
acli confluencecloud --server https://yourconfluence.atlassian.net/wiki --user confluenceuser@solveapuzzledev --token '${CONFLUENCE_TOKEN}' --action getSpace --space DEMO
```

## Get pages in Space

```
acli confluencecloud -s https://yourconfluence.atlassian.net/wiki -u confluenceuser@solveapuzzledev --token '${CONFLUENCE_TOKEN}' --action getPageList --space "DEMO" --columns "" --file ./data/html/out.csv
```

## Export based on CSV Names of pages

Loop over a simple CSV file with just the page name into a HTML page, uses the `out.csv` from the example above as input.

```
while IFS=',' read -r filename; do acli confluencecloud -s https://yourconfluence.atlassian.net/wiki -u confluenceuser@solveapuzzledev --token '${CONFLUENCE_TOKEN}' --action getPageSource --space DEMO --title "${filename}" --file "./data/html/${filename}.html"; done < ./data/html/out.csv 

## Rename the files to strip whitespaces 
find ./html -depth -name '* *' -execdir bash -c 'mv -i "$1" "${1// /}"' bash {} \;


```

## Get Page Source

```
acli confluencecloud --server https://yourconfluence.atlassian.net/wiki --user confluenceuser@solveapuzzledev--token '${CONFLUENCE_TOKEN}' --action getPageSource --space DEMO --id 836010068
```

## Export Space

```
acli confluencecloud --server https://yourconfluence.atlassian.net/wiki --user confluenceuser@solveapuzzledev--token '${CONFLUENCE_TOKEN}' --action exportSpace --space "<space_key>" --file "<export_file_path>"
```

## References

https://hub.docker.com/r/bobswiftapps/acli

https://docs.asciidoctor.org/asciidoctor/latest/migrate/confluence-xhtml/

https://bobswift.atlassian.net/wiki/spaces/CSOAP/pages/91881522/Documentation

https://bobswift.atlassian.net/wiki/spaces/CSOAP/pages/10584066/Examples

https://confluence.atlassian.com/doc/confluence-storage-format-790796544.html

https://confluence.atlassian.com/enterprise/using-personal-access-tokens-1026032365.html
