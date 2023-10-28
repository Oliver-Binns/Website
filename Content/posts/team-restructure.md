---
date: tbc
title: Why we’re restructuring our teams
image: tbc
tags: Management
---

I recently posted on Twitter about how we’re restructuring our teams from a separate mobile and backend team into cross-disciplinary feature teams. In this blog post I am going to explain our aims as we undertake this change, some of the issues we are trying address and even some of the challenges we’re think we will face and how we’re planning to mitigate them. 

## Current Problems

A majority of the work we do revolves around changes that require input from multiple disciplines.
This is true of both new work and maintenance. 
When we build a new feature in our mobile app, we do the work for both iOS and Android.
Often this will require new backend APIs to be built and, since our infrastructure is written in code, sometimes these will even require help from AWS platform specialists.
When each of these different specialisms sit in different teams, it requires a lot of upfront planning to ensure dependencies are met in the correct order, and if anything goes wrong we would have to replan multiple teams' roadmaps.

![Team Structure diagram. A discovery team with arrows for Features 1, 2 and 3 pointing at three other teams: backend, mobile and platform. The discovery team contains a tech lead, product managers, business analysts, performance analyst, user researcher and designers. The backend team contains a tech lead, typescript developers and automation QA. The mobile team contains a tech lead, Android developers, iOS developers, automation QA and manual QA. The platform team contains a tech lead and platform developers.](/images/team-restructure-before.png)

Expert overload - due to no distribution of responsibilities in a more top-down hierarchy
Communication overheads - many of our leads spent too much time in meetings
Dependency management: especially when things are picked up mid-sprint

> _"Business people and developers must work together daily throughout the project."_
> 
> — Principles behind the Agile Manifesto, [agilemanifesto.org](http://agilemanifesto.org/principles.html)

Business / Product team members currently sit outside the teams, this makes communication more difficult (not in spirit of agile)

Bikeshedding when cross-team communication is about complex features rather than common ground: lack of focus

## Our Aims

Empower individuals to take responsibility over their feature
Empower teams to own their end-to-end
Team Leads are an escalation path to support the team, not to micromanage the team

## Things we want to avoid
Our teams have raised concerns about loss of responsibility
Complete siloing of our different disciplines: Android Catchup
Lack of support for less senior team members
Over-defining the team ways of working: individuals and interactions over processes and tools

## Opportunities
Ability to learn a new language and stack
More leadership opportunities for our team: delegating responsibility into the team. Discipline leadership opportunities.

## The Future
We’ve put a lot of thought into this and we think this is going to be a huge improvement to the way our teams work. We’re going to trial it for a few sprints and see what happens. We’ll keep an eye out for feedback from our teams in their retros, and work to address any problems.