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
When each of these different specialisms sit in different teams, it requires a lot of upfront planning to ensure dependencies are met in the correct order, and if anything goes wrong we would have to replan multiple teams’ roadmaps.

![Team Structure diagram. A discovery team with arrows for Features 1, 2 and 3 pointing at three other teams: backend, mobile and platform. The discovery team contains a tech lead, product managers, business analysts, performance analyst, user researcher and designers. The backend team contains a tech lead, typescript developers and automation QA. The mobile team contains a tech lead, Android developers, iOS developers, automation QA and manual QA. The platform team contains a tech lead and platform developers.](../../Images/team-restructure-before.png)
*Our Old Team Structure — Teams are split by discipline*

When there are more members of each specialism (i.e. Android developers) in a larger mobile team, we try and give them unrelated pieces of work to avoid merge conflicts in the code that is being written.
This means there are multiple features or pieces of work being delivered in parallel by the team.
Unless we clearly assign team members to a particular feature, this can result in a lot of communication overheads and redudancy.
For example, the whole team often end up invited to meetings for **every single** feature when only a single developer is needed to provide guidance.

Alternatively, it may be the tech lead or a single individual that takes on the responsibility in all meetings, which results in a very top-down hierarchy where the team as a whole does not feel empowered.
What’s more, this can result in expert overload where the team accumulates more knowledge because they are at the centre of everything, resulting in them becoming indispensible in all situations.
This is a vicious cycle because as they are now indispensible and they will gain even more knowledge — until they burn out and the team comes to a standstill.

> _"Business people and developers must work together daily throughout the project."_
> 
> — Principles behind the Agile Manifesto, [agilemanifesto.org](http://agilemanifesto.org/principles.html)

While agile principles state that business people and developers must work together daily, our old team structure did not encourage this behaviour.
Since product managers and business analysts did not sit inside our teams, they were not required to attend our regular scrum ceremonies including the daily stand-up.
We also encountered the similar communication barriers here, where it was not always clear which product manager or business analyst was responsible for a given feature.

Finally, since all our team members were constantly context switching between different features, it was difficult for them to focus for long enough to gain a deep understanding of each of them.
When this happens, we see the [Law of triviality](https://en.wikipedia.org/wiki/Law_of_triviality) begin to take effect.
This is more colloquially known as ‘bikeshedding’ from the example where nuclear power-plant designers don’t understand enough detail about the reactor plans so decide to ensure there is a design for the bikeshed.

## Our Aims

![Team Structure diagram. A discovery team with arrows for feature 1 pointing at feature team 1, feature 2 pointing at feature team 2, and feature 3 pointing at feature team 3. The discovery team contains a tech lead, product managers, performance analyst, user researcher and designers. Each of the three feature teams contains a tech lead, product manager, business analyst and Android, iOS, Typescript and Platform developers as well as automation and manual QA.](../../Images/team-restructure-after.png)
*Our New Team Structure — Teams are split by business domain*

When restructuring our teams, we wanted to solve as many of these irritations as possible.
We created each of our teams around an end-to-end component of our app, with full ownership of their component.
We have drawn the lines between the teams responsibilities with the aim of minimising cross-team dependencies.
We wanted to ensure they have all skills to be able to successfully manage this _within_ the team, including making day-to-day decisions on maintenance and any enhancements.
We’re hoping that this will enable the team to have a full understanding of their area and current work without being distracted by work going on in other parts of the app.
Our leadership team should be an escalation path for the team to use at their discretion when problems arise.
They are not there to micromanage the team or step in to make decisions on the team’s behalf.

## Things we want to avoid

Spreading members of each specialism across multiple teams could result in these people becoming isolated and not feeling sufficiently supported in their work.
We’re aware that some of our less experienced developers are now the most senior developer of their particular specialism in their respective teams.
We’ve attempted to mitigate this by putting them alongside a more experienced developer from another specialism.
As part of this, we’re encouraging our senior developers to have a basic knowledge of the whole stack, not just their own code – after all general engineering principles should carry across these specialisms.

Our teams have raised concerns about loss of responsibility
Complete siloing of our different disciplines: Android Catchup

Over-defining the team ways of working: individuals and interactions over processes and tools

## Opportunities
Ability to learn a new language and stack
More leadership opportunities for our team: delegating responsibility into the team. Discipline leadership opportunities.

## The Future
We’ve put a lot of thought into this and we think this is going to be a huge improvement to the way our teams work. We’re going to trial it for a few sprints and see what happens. We’ll keep an eye out for feedback from our teams in their retros, and work to address any problems.
