# Orbit — Local Network Collaboration Platform

A responsive, installable web app for demonstrating team collaboration, project tracking and the Git feature-branch / pull-request workflow. Works in modern mobile and desktop browsers.

## Features
- Responsive dashboard for phones, tablets and laptops
- Create projects, tasks and team members
- Update task status
- Demonstration branch and pull-request workflow
- Browser local storage for demo data
- PWA manifest and service worker for app-like installation and offline shell

## Run online
Enable GitHub Pages in **Settings → Pages → Deploy from a branch → main → /(root)**. Then open:
https://vaghelameetkumar49-hash.github.io/Local-Network-Collaboration-Platform/

## Run on a laptop / LAN
1. Download or clone this repository on a laptop.
2. Open a terminal in the project folder.
3. Run `python -m http.server 8000 --host 0.0.0.0`.
4. Find the laptop's private Wi-Fi IPv4 address (for example `192.168.1.5`).
5. On another device connected to the same Wi-Fi, open `http://192.168.1.5:8000` (replace with the laptop's actual address). Allow the server through the laptop firewall if prompted.

A laptop is required to host this LAN server. A phone can access it as a client. GitHub Pages is the public online hosting option.

## Important limitations
This is a front-end learning prototype. Projects, tasks and members are stored in each browser's local storage, so data is not shared or synchronized between devices. Branches and pull requests shown in the app are educational demo records; they do not create real GitHub branches or pull requests. Real multi-user collaboration requires a backend/database and GitHub API integration.

## Git learning commands
```bash
git checkout -b feature/my-feature
git add .
git commit -m "Add my feature"
git push -u origin feature/my-feature
```
Then open GitHub and create a Pull Request from your feature branch into main.

## Demo
No login is required. Use sample data or add your own test entries. Avoid entering private or sensitive information.
