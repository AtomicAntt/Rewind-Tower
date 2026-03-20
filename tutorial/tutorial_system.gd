extends Node

# This is an autoload with the only purpose of being a signal connection LOL

## A specific tutorial UI should be listening to this with a correct String.
signal complete(what: String)

## This gets emitted from the tutorial UI that just had a valid complete to be listened by the TutorialManager, which will make the next tutorial UI visible.
signal resume
