Linux Screen Time proposal
Overview: A Linux version of iOS Screen Time feature. Keep track of usage on applications, websites, etc. Let the users set the limit of time they should spend on an application or web domain and shutdown the application or blocking the domain when users pass the limit. Also, if the user is working continuously too long, send them a notification telling them to take some rest.

Purpose: Nowadays people do many works on a computer, but there are tons of more interesting things to do on a computer that can distract the user from getting the work done. This small program can help users to do their jobs more effectively and tell them to get rest when necessary. This project is interesting to do because we think this is useful to many people who might find it difficult to focus on the work on hand entirely.

Expected workload distribution among group members: Not clear.

Project plan:
•    Get the time the users spend on each application, domain, and graph the usage.
•    Categorize applications, domains.
•    Build interactive UI, which can let users customize their plan of using computer.
•    Give this program permission to shutdown applications or limit the resource used by         
       applications.
Tools needed: proc file system, cgroup, python matplot, Linux kernel module
Programming Language: C, Python, Bash.

Expected challenges:
•    How to permit program to access usage, shutdown application, and blocking domains.
•    How to let the program run on the background and run without significantly affecting computer performance.
•    How to categorize applications, domains.
•    How to prevent users from easily disable this program.

Weekly Plan:
1.    Track resources and Kernel Hello World
2.    Use cgroup to isolate specific applications from the whole system.
3.    Set a fundamental limit on the applications.
--------------midterm presentation-------------------
5    Categorize applications and website
6    Basic customizability structure.
7    GUI

