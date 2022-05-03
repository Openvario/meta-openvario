__author__ = 'timo'

from git import Repo
import re
import string
import argparse
import datetime

# path to repository
path_to_repo = "T:/code_temp/git_repo"
# tags searched in commits
keywords = {"bf": "Fixed Bugs", "nf": "New Feature", "ki": "Known issues"}

content = {}

# create repo object
repo = Repo(path_to_repo)

def get_keywords_in_commits(repo, keywords ,revA, revB="head"):

    # get commits between two releases
    com_range = revA + "..." + revB
    print("Getting content between commits: " + com_range)
    com_between_rel = list(repo.iter_commits(com_range))

    # iterate over defined keywords
    for key in keywords:
        # create key in result dict
        content[key] = []
        # iterate over all commits
        for c in com_between_rel:
            #print("Message: " + c.message)
            if re.search(key,c.message):
                pattern = key + "'(.*)'"
                result = re.findall(pattern, c.message)
                for hit in result:
                    print(keywords[key] + ": " + hit)
                    content[key].append(hit)
    return (content)

def create_text_file(content, filename):
    try:
        fobj = open(filename,"w")
        print("file open")
    except:
        print("File ERROR")

    for key in content:
        fobj.write(key + ":\n")
        for string in content[key]:
            fobj.write(" - " + string + "\n")
    fobj.close()


def create_latex_file(content, release, keywords, filename):
    class LaTeXTemplate(string.Template):
        delimiter = "%%"
    temp = ""
    latex_strings = {}
    # convert date
    rel_date = datetime.datetime(int(release[:2])+2000, 1, 1) + datetime.timedelta(int(release[-3:]))
    print("Release Date: " + rel_date.strftime('%b %d, %Y'))
    # create latex strings
    for token in keywords:
        latex_strings[token] = []
        if len(content[token]) is not 0:
            temp = "\\begin{itemize}\n"
            for issue in content[token]:
                temp = temp + "\item " + issue + "\n"
            temp = temp + "\end{itemize}\n"
            latex_strings[token] = temp
        else:
            latex_strings[token] = "- none -\n"

    with open("release_tmpl.tex","r") as template:
        data = template.read()

        target_doc = filename
        with open(target_doc, "w") as page:
            s = LaTeXTemplate(data)
            page.write(s.substitute(nf=latex_strings['nf'], bf=latex_strings['bf'], ki=latex_strings['ki'],
                                    release=release, rel_date=rel_date.strftime('%b %d, %Y')))
        page.close()
    template.close()


#main begin
parser = argparse.ArgumentParser(description='Generate Release notes site for OpenVario.org')
parser.add_argument('firstcommit', metavar="FIRSTCOMMIT", help="Specifiy the starting COMMIT of this release")
parser.add_argument('--release', metavar="RELEASE",
                    default=datetime.datetime.now().strftime('%y%j'), help="Specify the Release number")
parser.add_argument('--last-commit', dest='lastcommit', default="head", help="Specifiy the last COMMIT of this release (default=head)")
args = parser.parse_args()

#getting content from git
content = get_keywords_in_commits(repo,keywords, args.firstcommit, args.lastcommit)

#create_text_file(content, "test.txt")

#create latex file from template
create_latex_file(content, args.release, keywords, "release_" + args.release + ".tex")







