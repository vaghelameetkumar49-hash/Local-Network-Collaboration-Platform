# Mini Project Report: Local Network Collaboration Platform

## 1. Introduction
Orbit is a responsive web-based workspace prototype that demonstrates how a small team can organize projects, tasks and a Git-based collaboration process.

## 2. Objectives
- Build a web interface usable on mobile and laptop screens.
- Demonstrate hosting a website on a laptop over a local Wi-Fi network.
- Understand Git branches, commits, pushes and pull requests.
- Practice organizing team members, projects and tasks.

## 3. Technologies
HTML5, CSS3, JavaScript, Browser Local Storage, Progressive Web App manifest, Service Worker and Git/GitHub.

## 4. Modules
1. Overview dashboard: project, task, member and pull-request counts.
2. Projects: create and track projects.
3. Tasks: add tasks and cycle their status.
4. Team: add team member names and roles.
5. Git workflow: create sample feature branches and pull requests.

## 5. Local Network Setup
The project can be served from a laptop using Python's built-in HTTP server:
```bash
python -m http.server 8000 --host 0.0.0.0
```
Other devices on the same Wi-Fi can visit the laptop's private IPv4 address on port 8000. The exact address depends on the local network.

## 6. Testing
- Opened the interface at narrow and wide screen sizes.
- Created project, task, member, branch and pull-request demo entries.
- Reloaded the page to confirm browser-local data persistence.
- Confirmed navigation between dashboard modules.

## 7. Limitations
The current version is a front-end prototype. Data is stored locally per browser and is not synchronized. Git branch and pull-request entries are simulations; actual Git operations happen in the GitHub repository. A shared backend and authentication are required for real-time multi-user collaboration.

## 8. Future Scope
Add a server-side database, secure user authentication, live updates, file uploads, actual GitHub API integration and access control.

## 9. Conclusion
Orbit provides a practical starting point for learning responsive web development, LAN hosting and collaborative Git workflows.