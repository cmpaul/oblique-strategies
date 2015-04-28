# oblique-strategies package

A tiny Atom package for developer inspiration.

[![Build Status](https://travis-ci.org/cmpaul/oblique-strategies.svg?branch=master)](https://travis-ci.org/cmpaul/oblique-strategies)

![After a few seconds of inactivity, a randomized strategy will be displayed as a notification.](https://raw.githubusercontent.com/cmpaul/oblique-strategies/master/demo.gif)

## What
Politely displays a random strategy for overcoming programming blocks if it detects keyboard inactivity across all Atom editors.

## How
* Download the [Atom editor](https://atom.io)
* Install the [oblique-strategies package](https://atom.io/packages/oblique-strategies)
* Configure the package to your liking:
  * *Enable on load* - Checked if the package should load automatically.
  * *Sticky strategies* - Checked if strategies should not auto-dismiss.
  * *Randomize strategies* - Checked if strategies should be displayed in random order.
  * *Inactivity trigger* - Number of seconds of inactivity before a strategy will be displayed.
  * *Strategies list* - A comma-separated list of strategies that will be used instead of the default strategies that come with this package.

  ![Package configuration](https://raw.githubusercontent.com/cmpaul/oblique-strategies/master/settings.gif)

## Why
In 1975, Brian Eno and Peter Schmidt created a deck of cards printed with aphorisms designed to be drawn at random for help breaking through creative blocks. (They've since gone through many iterations.)

In April of 2015, I ran across Kevin Lawler's [Prompts for Programmers](http://kevinlawler.com/prompts) and took it as a call to action. This Atom plugin is the result of that action.
