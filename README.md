
# NOTE: This is the repository for the local desktop UI (no functionality) built using QT Quick for the service
Development mostly done on it, work has to be completed on the background service, find its repository [here](https://github.com/ezzedineozone/Sync-Service)

# ProjectSync
This project, i aim to build an application that handles file syncs, backups locally and for the cloud on windows. It will be essentially a [background service](https://github.com/ezzedineozone/Sync-Service), with a [deskop UI](https://github.com/ezzedineozone/Sync-Service-Ui) that controls it. but the end product will have both included and setup automatically for simplicity.

# Architechture
Two main parts, [the UI](https://github.com/ezzedineozone/Sync-Service-Ui) for ease of use by the users, and a [background service](https://github.com/ezzedineozone/Sync-Service) that handles the business logic. communicating with each other over the local network on a TCP socket. this ensure that (if needed) you can easily build a web UI for it.

# Goal features of the project
- unidirectional or bidirectional file syncing
- Local and or cloud through different cloud services like google drive, mega or one drive
- Lightweight and customizable
- Background service that is indepdendent from the UI that runs in the background, but is controlled through said UI

# Completed Features of the UI
- Connects to the service automatically and gets all the sync tasks and displays them
- View all current sync tasks, local or cloud, with their progress bar, status and all info necessary
- Add sync tasks and remove them from the service
- Sort tasks based on their different attributes using the custom made table

# Upcoming features for the UI
- Pause and unpause sync tasks as they are active
- Edit sync tasks dynamically (soon)
- Display errors for the user with suggested ways of handling them

Quick snippet of the UI development as of 4-12-2024


![image](https://github.com/user-attachments/assets/8d515d8a-dce6-4690-8efa-08a2b606c1e9)




