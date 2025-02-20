# Udemy Project 7

- [Udemy Project 7](#udemy-project-7)
  - [Introduction to the problem](#introduction-to-the-problem)
  - [Diagram showing my automation workflow](#diagram-showing-my-automation-workflow)
  - [Detailed steps](#detailed-steps)
  - [Blockers](#blockers)
  - [What I learnt](#what-i-learnt)
  - [Benefits I personally saw from the project](#benefits-i-personally-saw-from-the-project)

## Introduction to the problem

- We have a Sparta test app that uses Node JS v20
- This has a front page and a */posts* page
- We will be using a 2-tier app such that the app is on one VM/EC2 instance, and MongoDB (our database server) is on the other
- The **goal of this project** is to automate the deployment of this 2-tier app using a **script file** for each VM/EC2 that provisions it with all the required dependencies without needing user input, both via the **User Data** option when creating the VMs/EC2s and as a script file that can be run on the VMs/EC2s
  - These two scripts should also be idempotent (i.e. work the same when run multiple times on the same VM/EC2)
- To further automate this setup, we also then want to **create images** of the two VMs/EC2s that have been provisioned by the scripts
  - We will use one smaller ***run-app-only.sh* script** on the app VM/EC2 created from this image to get the app running each time

## Diagram showing my automation workflow

o A diagram showing your automation workflow for this project.

  § At the very least, this should include manual deployment, Bash scripting, user data, and images, along with how one led to the other

  § You could also include:

    · how `run-app-only.sh` script fits into the picture

    · how it is possible to speed up the automation process if you are limited on time (i.e. think about at which stage images could be used)

## Detailed steps

o Detailed steps on what you did and why

## Blockers

o Blockers – Suggestion: what was the issue, reason for the issue, solution

## What I learnt

o What you learnt

## Benefits I personally saw from the project

o Benefits you saw personally from the project













o Detailed steps on what you did and why

o Blockers – Suggestion: what was the issue, reason for the issue, solution

o What you learnt

o Benefits you saw personally from the project