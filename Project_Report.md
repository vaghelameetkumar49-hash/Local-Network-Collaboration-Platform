# Mini Project Report: Local Network Collaboration Platform

## 1. Introduction
Orbit is a responsive web-based workspace prototype that demonstrates how a small team can organize projects, tasks and a Git-based collaboration process through a clean dashboard.

## 2. Objectives
- Build a modern web interface usable on mobile and laptop screens.
- Demonstrate serving a website over a local Wi-Fi network.
- Understand Git branches, commits, pushes and pull requests.
- Practice organizing team members, projects and tasks.
- Provide useful browser-based productivity features.

## 3. Technologies
HTML5, CSS3, JavaScript, Browser Local Storage, Progressive Web App manifest, Service Worker and Git/GitHub.

## 4. Modules and Features
1. **Overview dashboard:** project, open-task, member and pull-request summary.
2. **Projects:** create projects and view progress.
3. **Tasks:** add, edit, search, filter, update status and delete tasks.
4. **Team:** add and remove team member records.
5. **Git workflow:** create sample feature branches and pull-request records.
6. **Workspace utilities:** dark mode, JSON backup/restore and CSV task export.
7. **Responsive interface:** layouts adapt to mobile, tablet and desktop screens.

## 5. Local Network Setup
The project can be served from a laptop using Python's built-in HTTP server:
```bash
python -m http.server 8000 --bind 0.0.0.0
```
Other devices connected to the same Wi-Fi can visit the laptop's private IPv4 address on port 8000. The exact address depends on the local network.

## 6. Testing
- Navigate between all workspace modules.
- Create projects, tasks, team members, branches and pull-request demo records.
- Edit and filter tasks; change task status and delete records.
- Switch between light and dark themes.
- Export task data as CSV and download a JSON workspace backup.
- Reload the page to confirm browser-local persistence.
- Check responsive layout on narrow and wide screens.

## 7. Limitations
The current version is a front-end prototype. Data is stored locally per browser and is not synchronized between users or devices. Git branch and pull-request entries are simulations; they do not execute actual GitHub operations. File sharing, authentication and a shared database are not included.

## 8. Future Scope
Add secure authentication, a server-side database, real-time updates, file uploads, access control and GitHub API integration for real branch and pull-request operations.

## 9. Conclusion
Orbit provides a practical learning platform for responsive web development, browser storage, LAN hosting and collaborative Git workflows.
