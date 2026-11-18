# Orbit — Local Network Collaboration Platform

Orbit is a responsive, installable web workspace for demonstrating project planning, task tracking, team organization and the Git feature-branch / pull-request workflow.

## Features
- Professional responsive dashboard for mobile, tablet and desktop
- Project creation and progress overview
- Task creation, editing, search, status filtering and deletion
- Team member management
- Educational feature branch and pull-request workflow
- Dark mode
- JSON backup download and restore
- CSV task export
- Browser-local persistence and PWA offline app shell

## Run online
Enable GitHub Pages in **Settings → Pages → Deploy from a branch → main → /(root)**:
https://vaghelameetkumar49-hash.github.io/Local-Network-Collaboration-Platform/

## Install on mobile
Open the live site in a supported browser and use the browser menu's **Install app** or **Add to Home screen** option when available.

## Run on a laptop / LAN
1. Download or clone this repository on a laptop.
2. Open a terminal in the project folder.
3. Run `python -m http.server 8000 --bind 0.0.0.0`.
4. Find the laptop's private Wi-Fi IPv4 address.
5. On another device connected to the same Wi-Fi, open `http://LAPTOP-IP:8000`.

A laptop is required to host this LAN server. A phone can access it as a client. GitHub Pages is the public online hosting option.

## Important limitations
This release is a front-end learning prototype. Projects, tasks and members are stored in the current browser's local storage; they are not synchronized between users or devices. Branch and pull-request records are educational simulations and do not create real GitHub branches or pull requests. File sharing, secure login, real-time collaboration and shared database storage are not implemented. These require a backend, authentication and API integration.

## Git learning commands
```bash
git checkout -b feature/my-feature
git add .
git commit -m "Add my feature"
git push -u origin feature/my-feature
```
Then create a real Pull Request on GitHub from the feature branch into `main`.

## Demo data
The workspace starts with sample project data. Avoid entering private or sensitive information. Use the JSON backup control to save or restore the current browser's demo workspace.
