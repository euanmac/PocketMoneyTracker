#  Pocketmoney Tracker

### Object Model

User
-UserTask
    -Task
        -TaskId

-Completions
    -Completion
        -TaskId

-Weeks
    -Week
        -TaskId
        -isPaid


### Week
Week is only created when the user completes / locks a week
Stores the tasks which were  completed along with 


### Edit Task
Task is only partially editable. Fields that can be edited are:
-Description
-Image

Task is editable even if week is complete as description and image are non critical fields
Value / Mandatory cannot be changed
Task can be deletable if no completions ever
Task archivable if no completions for current week

How to "unarchive" a task  - from user profile screen?



