# Dovico API

## `/Employees`
### Query myself
Query : `GET /Employees/me`

Response :
~~~json
{
  "Employees": [
    {
      "ID": "860",
      "FirstName": "Theophile",
      "LastName": "Helleboid",
      "GetItemURI": "https://api.dovico.com/Employees/860/?version=5"
    }
  ]
}
~~~

## `/TimeEntries`
### Get Time Entries for one employee
Query `GET TimeEntries/Employee/860`

Response:
~~~json
{
  "TimeEntries": [
    {
      "ID":         "T4d5ba65f-9ebc-4587-a72c-8243b2612a2b",
      "Sheet":      {"ID":"0", "Status":"N", "RejectedReason":""},
      "Client":     {"ID":"0", "Name":"[None]", "GetItemURI":"N/A"},
      "Project":    {"ID":"1269", "Name":"Non-Project Related", "GetItemURI":"https://api.dovico.com/Projects/1269/?version=5"},
      "Task":       {"ID":"482", "Name":"Other", "GetItemURI":"https://api.dovico.com/Tasks/482/?version=5"},
      "Employee":   {"ID":"860", "Name":"Helleboid, Theophile", "GetItemURI":"https://api.dovico.com/Employees/860/?version=5"},
      "Date":       "2017-01-02",
      "StartTime":  "0900",
      "StopTime":   "1600",
      "TotalHours": "7",
      "Description":"",
      "Billable":   "T",
      "Charge":     "0",
      "ChargeCurrency": {"ID":"-1", "Symbol":"£", "GetItemURI":"N/A"},
      "OTCharge":   "1",
      "Wage":       "0",
      "WageCurrency":{"ID":"-1", "Symbol":"£", "GetItemURI":"N/A"},
      "OTWage":     "1",
      "Prorate":    "0",
      "Integrate":  "",
      "CustomFields":[]
    }
  ],
  "PrevPageURI": "N/A",
  "NextPageURI": "N/A"
}
~~~

### Create a new TimeEntry
Query `POST /TimeEntries/`
Body :
~~~json
[
  {
    "ProjectID":  "1297",
    "TaskID":     "4917",
    "EmployeeID": "111",
    "Date":       "2011-06-01",
    "TotalHours": "1"
  }
]
~~~


## `/Assignments`
### Get a list of Assignments (ie, projects)
Query: `GET /Assignments`

Response
~~~json
{
  "Assignments": [
    {
      "AssignmentID": "P1238",
      "ItemID":       "1238",
      "Name":         "C004 - iOS Optimisation",
      "StartDate":    "2017-01-04",
      "FinishDate":   "2018-01-04",
      "EstimatedHours":"N/A",
      "TimeBillableByDefault":"N/A",
      "ExpensesBillableByDefault":"T",
      "Charge":       "N/A",
      "ChargeCurrency":{"ID":"N/A", "Symbol":"N/A", "GetItemURI":"N/A"},
      "Wage":         "N/A",
      "WageCurrency": {"ID":"N/A", "Symbol":"N/A", "GetItemURI":"N/A"},
      "Prorate":      "N/A",
      "ETC":          "N/A",
      "Hide":         "N/A",
      "GetAssignmentsURI":"https://api.dovico.com/Assignments/P1238/?version=5",
      "GetItemURI":"https://api.dovico.com/Projects/1238/?version=5"
    }
  ]
}
~~~

### Get a list of task linked to a Project (ie Task)
Query: `GET /Assignements/P1238`

Response
~~~json
{
  "Assignments": [
    {
      "AssignmentID": "T32197",
      "ItemID":       "100",
      "Name":         "Core Development",
      "StartDate":    "N/A",
      "FinishDate":   "N/A",
      "EstimatedHours":"N/A",
      "TimeBillableByDefault":"N/A",
      "ExpensesBillableByDefault":"N/A",
      "Charge":       "N/A",
      "ChargeCurrency": {"ID":"N/A", "Symbol":"N/A", "GetItemURI":"N/A"},
      "Wage":         "N/A",
      "WageCurrency":   {"ID":"N/A", "Symbol":"N/A", "GetItemURI":"N/A"},
      "Prorate":      "N/A",
      "ETC":          "N/A",
      "Hide":         "N/A",
      "GetAssignmentsURI":"https://api.dovico.com/Assignments/T32197/?version=5",
      "GetItemURI":   "https://api.dovico.com/Tasks/100/?version=5"}],
      "PrevPageURI":  "N/A",
      "NextPageURI":  "N/A"
    }
  ]
 }
~~~
