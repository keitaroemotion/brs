#!/usr/bin/env python

from subprocess import call
import sqlite3
import random 

bookmark_dir = "/Users/keisugano/Library/Application Support/Firefox/Profiles/u0tbyzbw.default"
dbpath = "%s/places.sqlite" % bookmark_dir

def puts(e):
   print("%s | %s" % (e[0][0:20], e[1]))
   return e    

def getRecords(dbpath):
   return connect(dbpath).execute("select url, moz_places.title from moz_places join moz_bookmarks where moz_places.title=moz_bookmarks.title")

def connect(dbpath):
   return sqlite3.connect(dbpath)

bookmarks = [ puts(x) for x in getRecords(dbpath)]

def calllink(bookmarks):
    link = bookmarks[random.randrange(len(bookmarks)-1)] 
    print link[1]
    r = raw_input("OK? [None:n Quit:q]") 
    if r == "n":
       return calllink(bookmarks)
    elif r == "q":
       return  
    else:
       return ask_and_call(link[1], link[0])

def filter(bookmarks, word):
    return [ x for x in bookmarks if word.lower() in x[1].lower()] 
    
def ask_and_call(title, link): 
    raw_input("Open %s?[None:n] " % title) != "n" and call(["open", link])

if(raw_input("what you wanna do? [random:r][search:s]") == "r"):
    calllink(bookmarks)
else:
    res = filter(bookmarks, raw_input("word: "))
    [ ask_and_call(x[1], x[0]) for x in res ]


    
