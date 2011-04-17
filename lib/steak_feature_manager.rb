# SteakFm


# feature
# for no multiline
# ((^.*#+.*\n)+\n?)?(^.*@+.*\n)?^[ \t]*feature ".*"(,\s".*")?\sdo
#as same but simpler
# ((^.*#+.*\n)+\n?)?(^.*@+.*\n)?^[ \t]*feature.*\sdo


# scenario have duty regex
# ((^.*#+.*\n)+\n?)?(^.*@+.*\n)?^[ \t]*scenario ".*".*do\b(.*?\n?)+end
