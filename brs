#!/usr/bin/env python

from subprocess import call
import sqlite3
import random 
import sys 

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

def getRandom(bookmarks):
    return random.randrange(len(bookmarks))-1 

def calllink(bookmarks, i=0, token="", porn=False):
    i = len(bookmarks) > i and i or 0 
    link = bookmarks[i]
    if ( (porn == False and isPorn(link[0]+link[1]))
    or (porn == True and isPorn(link[0]+link[1]) == False)):
        return calllink(bookmarks, i+1, getToken(link), porn)

    if token in link[0]:
       return calllink(bookmarks, i+1, getToken(link), porn)

    print link[1] + link[0]
    r = raw_input("OK? [None:n Quit:q]") 
    if r == "n" or token in link[0]:
       return calllink(bookmarks, i+1, getToken(link), porn)
    elif r == "q":
       return  
    else:
       return ask_and_call(link[1], link[0]) 

def getToken(text):
    return text[0][0:16]

def isPorn(w):
    return "xvideo" in w.lower() 

def filter(bookmarks, word):
    return [ x for x in bookmarks if word.lower() in x[1].lower()] 
    
def ask_and_call(title, link): 
    print title 
    raw_input("Open ?[None:n] ") != "n" and call(["open",link])

def get(arr, i):
    return len(arr) > i and arr[i] or ""

print sys.argv

if(raw_input("what you wanna do? [random:r][search:s]") == "r"):
    calllink(bookmarks, -1, "",  get(sys.argv,1) == "porn")
else:
    [ ask_and_call(x[1], x[0]) for x in filter(bookmarks, raw_input("word: ")) ]
