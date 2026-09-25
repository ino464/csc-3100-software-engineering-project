# PATHFINDERS

## Software Requirements Specification

**Instructor:** Lara Nichols-Brown  
**Term:** Fall 2026  
**Section:** CSC-3100-S03-2268

### Engineering Team

1. **Cole Edmonston** - Lead Engineer
2. **Ethan Ikenaga** - Product Owner
3. **Jonah Depaz** - Scrum Master
4. **Tyler Kim** - Tester

### Project Assets

- **GitHub:**
  https://github.com/ino464/CSC-3100-Software-Engineering-Project
- **Deployment:** WIP

### Document History

| Last Date Changed | Who | What Was Changed |
| ----------------- | --- | ---------------- |
|                   |     |                  |

---

# PATHFINDERS

## Software Requirements Specification (SRS)

**Course:** CSC-3100-S03-2268 **Date:** [Submission Date]

---

## Table of Contents

1. [Introduction](#1-introduction)

   - [1.1 Project Purpose](#11-project-purpose)
   - [1.2 Intended Audience](#12-intended-audience)
   - [1.3 Project Scope](#13-project-scope)

2. [User Stories](#2-user-stories)

   - [2.1 User Features](#21-user-features)
   - [2.2 Admin Features](#22-admin-features)

3. [Functional Requirements](#3-functional-requirements)
4. [Non-Functional Requirements](#4-non-functional-requirements)

   - [4.1 Data Integrity and Security](#41-data-integrity-and-security)
   - [4.2 Performance and Usability](#42-performance-and-usability)

5. [System Architecture](#5-system-architecture)

   - [5.1 REST API Endpoints](#51-rest-api-endpoints)
   - [5.2 Database Schema](#52-database-schema)

6. [User Interface](#6-user-interface-ui)

   - [6.1 Wireframes / Mockups](#61-wireframes--mockups)

7. [Data Requirements](#7-data-requirements)

   - [7.1 List of Persistent Data](#71-list-of-persistent-data)

8. [Traceability Matrix](#8-traceability-matrix)
9. [Appendices](#9-appendices)
10. [AI Usage and Disclosure](#10-ai-usage--disclosure-mandatory)

---

## 1. Introduction

### 1.1 Project Purpose

**Problem Statement:** What specific problem are you solving?

This project solves the problem that normal AI chats are hard to
use for brainstorming. When you explore many ideas in one chat,
good ideas get buried and it is difficult to go back to earlier
options. With our visual canvas, users can easily merge ideas,
go back to previous nodes, and find chats easily

### 1.2 Intended Audience

**Target Audience:** Who are the stakeholders?

The main users are people who need help brainstorming and
organizing ideas, such as students, developers, designers,
entrepreneurs, and anyone planning a project or making a
decision.

### 1.3 Project Scope

What is the scope of this project?

We plan to have users create an account, start a brainstorming
session, enter a prompt, and see AI-generated ideas as connected
branches on a visual canvas. They can explore any branch, save
sessions, return to earlier ideas, and mark ideas as useful or
not useful. Other features such as merging ideas can come if
time permits.

---

## 2. User Stories

User stories follow this format:

> As a **[type of user]**, I want to **[action]** so that
> **[value/benefit]**.

### 2.1 User Features

| ID    | Author | User Story                                                                                                                                                                        | Priority |
| ----- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------: |
| US-01 | Jonah  | As a brainstormer/user, I want the system to suggest and automatically create new branches based on a node’s context so that I can explore multiple directions from an idea.      |        1 |
| US-02 | Jonah  | As a brainstormer/user, I want to add new nodes to a selected chat branch using the branch’s existing context so that each idea path develops independently.                      |        1 |
| US-03 | Cole   | As a brainstormer/user, I want to be able to click through all my chat history to easily switch between different idea branches, in order to work through multiple ideas at once. |        1 |
| US-04 | Ethan  | As a returning user, I want to be able to login so that i can continue where I left off                                                                                           |        2 |
| US-05 | Ethan  | As a brainstormer, I want to be able to accept and reject nodes so that I can keep track of my decisions                                                                          |        2 |
| US-06 | Ethan  | As a brainstormer, I would like to return to a previous node so I can reimagine an idea                                                                                           |        2 |
| US-07 | Cole   | As a brainstormer/user, I want to be able to delete/deactivate branches and chats I no longer find useful or helpful in order to keep my work space organized.                    |        2 |
| US-08 | Tyler  | As a brainstormer, I want to be able to put in preferences that the program persists through my brainstorming session so that my likes/dislikes are remembered.                   |        3 |
| US-09 | Cole   | As a brainstormer/user, I want to be able to update the chat names to a relevant idea so that it is easier to reference and is more memorable for myself.                         |        3 |
| US-10 | Jonah  | As a brainstormer/user, I want to be able to export my brainstorm graph so I can share it with other collaborators for later use.                                                 |        3 |
| US-11 | Tyler  | As a teammate of a brainstormer, I want to be able to see and import someone else’s brainstorm graph through some export function in order to be sure we’re on the same page.     |        3 |
| US-12 | Tyler  | As a brainstormer, I want to be able to select two or more nodes and merge them so I can see a combination of my ideas.                                                           |        4 |

### 2.2 Admin Features

Add administrator user stories here, if applicable.

---

## 3. Functional Requirements

The system shall:

| ID    | Requirement                                                    | Priority |
| ----- | -------------------------------------------------------------- | -------: |
| FR-01 | The system shall authenticate users via username and password. |        2 |
| FR-02 | The system shall allow users to store workout information.     |        1 |
| FR-03 | The system shall allow users to search their workout history.  |        3 |
| FR-04 | The system shall allow users to add new workout types.         |        4 |

---

## 4. Non-Functional Requirements

### 4.1 Data Integrity and Security

- **Integrity:** The system shall handle errors and invalid data
  appropriately.
- **Security:** The system shall use bcrypt for password
  hashing.
- **Security:** The system shall use environment variables for
  database credentials.

### 4.2 Performance and Usability

- Add performance requirements here.
- Add usability requirements here.

---

## 5. System Architecture

### 5.1 REST API Endpoints

| Method | URL              | Description                        |
| ------ | ---------------- | ---------------------------------- |
| GET    | `/api/resources` | Fetches a collection of resources. |
| POST   | `/api/resources` | Creates a new resource.            |

Add your planned endpoints based on your REST API design.

### 5.2 Database Schema

Add your MySQL database schema and UML diagram here.

---

## 6. User Interface (UI)

### 6.1 Wireframes / Mockups

Attach or link your wireframes and mockups here.

---

## 7. Data Requirements

### 7.1 List of Persistent Data

List the data that will be stored persistently in the database.

---

## 8. Traceability Matrix

| ID    | Requirement                                                    | Line of Code |
| ----- | -------------------------------------------------------------- | -----------: |
| US-01 | The system shall authenticate users via username and password. |          152 |
| US-02 | The system shall allow users to store workout information.     |          256 |
| US-03 | The system shall allow users to search workout history.        |           46 |
| US-04 | The system shall allow users to add new workout types.         |           45 |

---

## 9. Appendices

Add supporting materials here.

---

## 10. AI Usage & Disclosure (Mandatory)

- **Model(s) Used:** [Example: GPT-4o, Claude 3.5]
- **Prompts Used During Coding:** [Describe prompts or link to a
  record of them.]
