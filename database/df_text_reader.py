'''
## ----------- ------------------
Program Name : df_text_reader.py
Author : Lakshmi Damodara
Date : 25th July 2018

Description:
This program was written to parse an xer file in memory and extract the bundles, activity data from it.
The data is then inserted into various tables as defined by the cct business definitions.
1. The input file in memory is read from various locations for different types of data
   bundles, activities, project data.

2. Then after cleaning up, the data is inserted in tables:
   project, activities, bundles, activity_bundles, activity_data.

3. Output files: Various output is read throughout the program and written to
output.txt - contains all the data in lists
wbs_text - contains the bundles data
activity_data - contains the activity data

## -------------------------------------
'''

import sys
import base64
import io
from datetime import datetime, timedelta
import calendar
import db_utilities as dbu
import psycopg2
import excel_config_reader as ecr


import csv

class ErrorOccured(RuntimeError):
   def __init__(self, mssg):
      self.Message = mssg


## Read the streamed excel file
#print(datetime.datetime.today())

global Filepath
out_Filepath = 'd:\\anaconda3\\kumar\\cct\out_file\\df\\'
in_filepath = 'D:\\Anaconda3\\Kumar\\cct\\input_file\\'

infile = in_filepath + 'df_baseline.xer'
tempOutFile = open(out_Filepath + 'output.txt','w')
actvity_txtFile = open(out_Filepath +'activity_data.txt','w')

global ProjectID
global clientProjectID

#offile=open(outfile,"wb")

# Read the file and get the output from the following string onwards
wbs_id = '%T' + '\t' + 'PROJWBS'
wbs_id_end = '%T' + '\t' + 'ACTVTYPE'
word_task = '%T' + '\t' + 'TASK'
#word_task_end = '%T' + '\t' + 'TASKACTV'
word_task_end = '%T'

word_loc_wbs_id = 0
word_loc_wbs_id_end = 0
word_loc_task = []
word_loc_task_end = 0


wbs_list = []
task_list = []

final_wbs_list = []
final_task_list = []
bundle_list = []
expand_dates_list = []
bundle_dict = {}
holiday_data = []
global phaseID_data, key_value_list, activity_milestone
phaseID_data = []
phases_dict = {}
key_value_list = []
activity_milestone = []


# This section opens the input xer file and locates the various section of the data
# wbs - bundles, tasks - activities etc..
# This location is then passed on to the functions below for reading the data
with open(infile, 'r') as f:
    try:
        #reader = csv.reader(f, dialect='excel', delimiter='\t')
        reader = f.read().split("\n")

        for i,line in enumerate(reader):
            if wbs_id in line: # or word in line.split() to search for full words
                #print("Word \"{}\" found in line {}".format(wbs_id, i+1))
                word_loc_wbs_id = i+1
            if wbs_id_end in line:
                #print("Word \"{}\" found in line {}".format(wbs_id_end, i + 1))
                word_loc_wbs_id_end = i + 1
            if word_task in line:
                #print("Word \"{}\" found in line {}".format(word_task, i + 1))
                word_loc_task.append(i+1)
            if word_task_end in line:
                #print("Word \"{}\" found in line {}".format(word_task_end, i + 1))
                word_loc_task_end = i+1
    except (Exception) as error:
        print(error)
    except (IOError) as ioe:
        print(ioe)

# This function reads the bundle based data based on the starting and ending location
# obtained from the above.
def ReadWriteWBSID():
    try:
        row = []
        # now write the wbs_id data into a file with starting and ending line numbers
        with open(infile, 'r') as f:
            # read the lines from the xer file line by line
            # starting from the locations obtained above
            for line in f.readlines()[word_loc_wbs_id:word_loc_wbs_id_end-1]:
                row.append([line])
                for i in line.split(","): # split the lines based on comma
                    row[-1].append(i)
                    # writing the lines to the external text file
                with open(out_Filepath + 'wbs_file.txt', "a") as myfile:
                    wbs_list.append(line.replace('\t',','))
                    myfile.write(line)
            # remove the first item in the list as it is the column headings
            wbs_list.pop(0)
            #print(wbs_list, file=tempOutFile)

            ## remove quotes and other data from the list and write to final_wbs_list
            for i in range(0,len(wbs_list)):
                replaceSingleQuotes_WBS(wbs_list[i])
        f.close()
        myfile.close()
        print("----- Final WBS List ------------------", file=tempOutFile)
        print(final_wbs_list,file=tempOutFile)
    except (Exception) as error:
        print(error)

# This function reads the activity based data based on the starting and ending location
# obtained from the above.
def ReadwriteTASKS():
    try:
        row = []
        wbs_list = []
        with open(infile, 'r') as f:
            for line in f.readlines()[word_loc_task[0]:word_loc_task[1]-1]:
                #print(line,file=tempOutFile)
                row.append([line])
                for i in line.split(","):
                    row[-1].append(i)
                with open(out_Filepath + 'wbs_task.txt', "a") as myfile:
                    wbs_list.append(line.replace('\t', ','))
                    myfile.write(line)
            # remove the first item in the list as it is the column headings
            wbs_list.pop(0)
            #print(wbs_list, file=tempOutFile)

            for i in range(0,len(wbs_list)):
                replaceSingleQuotes_TASK(wbs_list[i])

        f.close()
        myfile.close()
        print("----- Final Task List ------------------", file=tempOutFile)
        print(final_task_list, file=tempOutFile)
    except (Exception, ErrorOccured) as error:
        print(error)


def createPhases():
    try:
        global phaseID_data
        local_phaseID_data = []
        row = []
        local_client_projID = int(clientProjectID)
        # first read the wbs_final_list.
        # Take the 2nd position in the list
        # compare the clientProjectID with the item in the list (2nd position)

        for i in range(0,len(final_wbs_list)):
            row = []
            if local_client_projID == int(final_wbs_list[i][2]):
                row.append(final_wbs_list[i][0])
                row.append(final_wbs_list[i][1])
                row.append(final_wbs_list[i][2])
            local_phaseID_data.append(row)

        phaseID_data = [x for x in local_phaseID_data if x]
        print('-----Phases Final list -------------',file=tempOutFile)
        print(phaseID_data,file=tempOutFile)

        # delete all the lists and variables from memory
        del row
        del local_phaseID_data
        del local_client_projID

    except (Exception) as error:
        print('Error in createPhases() %s:' %error)


def insertPhases():
    try:
        # first read the phaseID_data []
        # then start inserting items into the phases table
        # get database connection
        db_conn = dbu.getConn()
        print("-------Writing PHASES Data to PHASES Table --------------------", file=tempOutFile)
        for i in range(0, len(phaseID_data)):
            lPhaseName = phaseID_data[i][1]
            lPhaseID = phaseID_data[i][0]
            print("----- INSERT Statements for Phases ------------------", file=tempOutFile)
            execSQL = ('insert_phases_data')
            execData = (lPhaseName,None,None,None,None,ProjectID,None,None)
            print(execSQL, execData, file=tempOutFile)
            lCurrentPhaseID = dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]
            #store the db_phaseID along with client wbsID in the phases_dict
            phases_dict.update({lPhaseID: lCurrentPhaseID})

        print('Phases Dictionary :', phases_dict)
    except (Exception) as error:
        print('Error in insertPhases() %s:' %error)



#This function reads the result_data and does the following:
#  inserts the activity, start date and end date in activities table
# The second part of the function does the following:
# The activity id, startdate and end date is available from list : expand_date_list[]
# expand_date_list[] is populated from insertActivity()
#   takes the start date, end date and expands all date in between them
# Function reads the total work days from excel_config.ini file and based on the value of [TotalWorkDays]
# it expands the date. If it is 5, then only dates between monday to friday is generated
# if TotalWorkDays is 6, then dates between monday to saturday is generated.
def expandDates():
    try:
        if (len(expand_dates_list)) == 0:
            raise ErrorOccured("Empty result List")

        #get database connection
        db_conn = dbu.getConn()
        # get the total workdays in a week
        tWdays = ecr.getTotalWorkdays()
        planned_hours =8 # assign planned hours per day as 8 hours
        totalRecords = len(expand_dates_list)
        #counter=0
        print("\n",file=actvity_txtFile)
        print("#### Printing insert query for activity_data ######", file=actvity_txtFile)

        ## Truncate temp.activity_data. We will insert rows into this table
        ## and then call a stored function to transfer them into activity_data table
        execSQL = "TRUNCATE TABLE activity_data"
        dbu.executeQuery(db_conn, execSQL)

        for i in range(0,totalRecords):
            activityN = expand_dates_list[i][0]
            startDate = expand_dates_list[i][1]
            TendDate = expand_dates_list[i][2]
            dtDate = datetime.strptime(startDate, '%Y-%m-%d %H:%M')
            enddtDate = datetime.strptime(TendDate, '%Y-%m-%d %H:%M')
            #Now for each activity, expand the dates startDate until end date
            # and insert into the activities_data table
            dd = [dtDate + timedelta(days=x) for x in range((enddtDate - dtDate).days + 1)]

            for d in dd:
                execSQL = "INSERT INTO ACTIVITY_DATA (ACTIVITY_ID,DATE,PLANNED_UNITS) VALUES (%s,%s,%s);"
                # get the weekday
                wDay = getDayofWeek(d)
                dstat = checkIfHoliday(d)
                planned_hours = 8
                if tWdays == '5': # if its a 5 day work week
                    if dstat == 'w': # if its not a holiday
                        if wDay == 0 or wDay == 1 or wDay == 2 or wDay == 3 or wDay == 4: #monday - friday
                            # activities table insert
                            execData = (activityN, d,planned_hours)
                            dbu.executeQueryWithData(db_conn, execSQL, execData)
                            print(execSQL, execData,file=actvity_txtFile)
                            #counter = counter + 1 #comment this line in production
                        elif wDay == 5 or wDay == 6: # if it is a saturday or sunday, insert a NONE for the planned hours
                            planned_hours = None
                            execData = (activityN, d, planned_hours)
                            dbu.executeQueryWithData(db_conn, execSQL, execData)
                            print(execSQL, execData, file=actvity_txtFile)
                            #counter = counter + 1  # comment this line in production
                    elif dstat == 'h': # if it is a holiday, insert a NONE for the planned hours
                        planned_hours = None
                        execData = (activityN, d, planned_hours)
                        dbu.executeQueryWithData(db_conn, execSQL, execData)
                        print(execSQL, execData, file=actvity_txtFile)
                elif tWdays == '6': # if its a 6 day work week : monday to Saturday
                    if dstat == 'w':
                        if wDay == 0 or wDay == 1 or wDay == 2 or wDay == 3 or wDay == 4 or wDay == 5:
                            execData = (activityN, d, planned_hours)
                            dbu.executeQueryWithData(db_conn, execSQL, execData)
                            print(execSQL, execData,file=f)
                            #counter = counter + 1  #comment this line in production
                        elif wDay == 6: # if it is a saturday or sunday, insert a NONE for the planned hours
                            planned_hours = None
                            execData = (activityN, d, planned_hours)
                            dbu.executeQueryWithData(db_conn, execSQL, execData)
                            print(execSQL, execData, file=actvity_txtFile)
                    elif dstat == 'h': # if it is a holiday, insert a NONE for the planned hours
                        planned_hours = None
                        execData = (activityN, d, planned_hours)
                        dbu.executeQueryWithData(db_conn, execSQL, execData)
                        print(execSQL, execData, file=actvity_txtFile)
    except (Exception) as error:
        print("Error in expandDates(): %s" %error)
        print(sys.exc_traceback.tb_lineno)
    except (ErrorOccured) as e:
        print(e.Message)
        print(sys.exc_traceback.tb_lineno)

#check if the given date is a holiday or a working day
def checkIfHoliday(dDate):
    try:
        dtString = datetime.strftime(dDate,'%Y-%m-%d')
        if dtString in holiday_data:
            dayStatus = 'h'
            return dayStatus
        else:
            dayStatus = 'w'
            return dayStatus
    except (Exception) as error:
        print("Error in checkIfHoliday() %s" %error)

# this function accepts the date as an argument
# and returns the day of the date. Mon =1, tue=2, wed=3 ....sat=6, sun=0
def getDayofWeek(ddDate):
    try:
        strDate = str(ddDate)
        ddDate = datetime.strptime(strDate, "%Y-%m-%d %H:%M:%S")
        wkday = calendar.weekday(ddDate.year, ddDate.month, ddDate.day)
        return wkday
    except (Exception) as error:
        print("Error in getDayofWeek(): %s" %error)


# This function reads the list of holidays from the holidays table and
# populates the holiday_data list
def readHolidays():
    try:
        # get database connection
        db_conn = dbu.getConn()
        stProc = "SELECT holiday from holidays"
        m_row = dbu.executeQueryRes(db_conn, stProc)

        # Reading the data fetched from the database
        for row in m_row:
            if row[0] != None:
               dtDate = row[0].strftime('%Y-%m-%d')
               holiday_data.append(dtDate)
    except (Exception) as error:
        print ("Error in readHolidayExcel(): %s" %error)
    except (ErrorOccured) as e:
        print (e)

#-------- Utility functions ---------------

# This function is to make sure the bundle name does not have any commas in them.
# If there are any commas, it is treated as a separate string and all the
# elements in the list gets shifted one position.
# As we read the xer file in the task section, there are 27 columns.
# If there are more than 65 columns, then it is assumed that the Task name has commas and a
# separate element has been created. So this function, removes the commas and concats the Task name
def replaceSingleQuotes_WBS(txt):
    local_wbs_list = []
    for row in csv.reader(txt.splitlines()):
        diff = len(row) - 27
        local_wbs_list.append(row[1])
        if len(row) == 27:
            local_wbs_list.append(row[10])
            local_wbs_list.append(row[12])
            local_wbs_list.append(row[6])
        elif len(row) != 27 :
            LName = row[10]
            endIndex = 10 + diff
            parentId = row[endIndex + 2]
            for i in range(11, endIndex + 1):
                LName = LName + "" + row[i]
            local_wbs_list.append(LName)
            local_wbs_list.append(parentId)
            local_wbs_list.append(row[6])

    final_wbs_list.append(local_wbs_list)


# This function is to make sure the Task name does not have any commas in them.
# If there are any commas, it is treated as a separate string and all the
# elements in the list gets shifted one position.
# As we read the xer file in the task section, there are 65 columns.
# If there are more than 65 columns, then it is assumed that the Task name has commas and a
# separate element has been created. So this function, removes the commas and concats the Task name
def replaceSingleQuotes_TASK(txt):
    try:
        local_task_list = []
        #print(txt)
        for row in csv.reader(txt.splitlines()):
            local_task_list.append(row[1])
            local_task_list.append(row[3])
            if len(row) == 65 :
                local_task_list.append(row[16])
                local_task_list.append(row[21])
                local_task_list.append(row[23])
                local_task_list.append(row[29])
                local_task_list.append(row[30])
                local_task_list.append(row[31])
                local_task_list.append(row[32])
                local_task_list.append(row[34])
                local_task_list.append(row[35])
                local_task_list.append(row[36])
                local_task_list.append(row[37])
                local_task_list.append(row[38])
                local_task_list.append(row[39])
                local_task_list.append(row[11])
                local_task_list.append(row[15])
            elif len(row) != 65:
                diff = len(row) - 65
                LName = row[16]
                endIndex = 16 + diff
                for i in range(17, endIndex + 1):
                    LName = LName + "" + row[i]
                local_task_list.append(LName)
                local_task_list.append(row[21+diff])
                local_task_list.append(row[23+diff])
                local_task_list.append(row[29+diff])
                local_task_list.append(row[30+diff])
                local_task_list.append(row[31+diff])
                local_task_list.append(row[32+diff])
                local_task_list.append(row[34+diff])
                local_task_list.append(row[35+diff])
                local_task_list.append(row[36+diff])
                local_task_list.append(row[37+diff])
                local_task_list.append(row[38+diff])
                local_task_list.append(row[39+diff])
                local_task_list.append(row[11])
                local_task_list.append(row[15])

        final_task_list.append(local_task_list)
    except (Exception,ErrorOccured) as error:
        print(error)


# This function inserts the values into the Activity, Activity_bundles table
def insertActivity():
    try:
        print("\n", file=tempOutFile)
        db_conn = dbu.getConn()
        # first remove empty list from result_data i.e, if there are empty rows in the excel
        totalRec = len(final_task_list)

        for i in range(1, totalRec):
            local_list = []

            localProjectID = ProjectID[0]
            activityId_temp = final_task_list[i][0]
            activity_taskCode = final_task_list[i][16]

            #getting the dbPhaseID based on the client activity
            phaseID_activityID = findPhaseValue(activityId_temp)

            activityExternalID = int(activityId_temp)
            bundleID = final_task_list[i][1]
            activity_name_temp = final_task_list[i][2]
            activityName = activity_name_temp
            actualStDate = final_task_list[i][5]
            actualEndDate = final_task_list[i][6]
            plannedStDate = final_task_list[i][13]
            plannedEndDate = final_task_list[i][14]
            total_planned_units_temp = float(final_task_list[i][4])
            total_planned_units = round(total_planned_units_temp)

            #Find out if the activity is a mileStone
            isMileStone = findIfMileStone(activityId_temp)

            # If the Actual StartDate and Actual EndDate are null [29],[30]
            # then take late StartDate and late EndDate [31],[32]
            if actualStDate == "":
                actualStDate = None
            if actualEndDate == "":
                actualEndDate = None
            if plannedStDate == "":
                plannedStDate = None
            if plannedEndDate == "":
                plannedEndDate = None

            print("----- INSERT Statements for activities() ------------------", file=tempOutFile)
            execSQL = ('insert_activities_data')
            execData = (activityName,None,None,None,None,phaseID_activityID,localProjectID,total_planned_units,
                        plannedStDate,plannedEndDate, None,actualStDate,actualEndDate,None,None,activity_taskCode,
                        None,isMileStone,None,None,None)
            print(execSQL, execData, file=tempOutFile)
            lCurrentActivityID = dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]
            local_list.append(lCurrentActivityID)
            local_list.append(plannedStDate)
            local_list.append(plannedEndDate)

            # contains the db_activityID, planned start date and planned end date
            # This list is used for expanding dates into the activity_data table
            # This list will be used by expandDates()
            expand_dates_list.append(local_list)

            #Now get the db_bundle id from the dictionary and insert into the corresponding bundle_activity table
            db_BundleID = bundle_dict.get(bundleID)

            # Bundle activities table insert
            print("----- INSERT Statements for BUNDLE_ACTIVITIES ------------------", file=tempOutFile)
            execSQL = "INSERT INTO BUNDLE_ACTIVITIES (ACTIVITY_ID,BUNDLE_ID) VALUES (%s,%s);"
            execData = (lCurrentActivityID, db_BundleID)
            print(execSQL, execData, file=tempOutFile)
            dbu.executeQueryWithData(db_conn, execSQL, execData)

    except(Exception) as error:
        print("Error in insertActivity:%s" %error)
    except (psycopg2) as dberror:
        print(dberror)

# This function is called from insertProjectData()
def getProjectID():
    try:
        global ProjectID
        global clientProjectID
        #first get the project name and check if project exists
        clientProjectID = final_wbs_list[0][0]
        local_project_name = final_wbs_list[0][1]
        IsProjectFlag = final_wbs_list[0][3]
        if IsProjectFlag == 'Y':
            ProjectID = insertProjectData(local_project_name)
        #elif IsProjectFlag == 'N':
        #    # Go through the final_wbs_list and find the project Node flag

    except (Exception) as error:
        print ("Error in reading Project Table(): %s" %error)

# This function is run initially to make sure that project data is available in the
# projects table. If project is not present, then it inserts the project data.
# The project id is then stored in the global ProjectID variable for other
# functions to use them
def insertProjectData(prjName):
    try:
        # get database connection
        db_conn = dbu.getConn()
        stProc = "SELECT ID from PROJECTS WHERE NAME='%s'" %prjName
        #m_row = dbu.executeQueryRes(db_conn, stProc)[0]
        m_row = dbu.executeQueryRes(db_conn, stProc)
        if len(m_row) >0:
            return m_row[0]
        else:
            print("----- INSERT Statements for New Project ------------------", file=tempOutFile)
            execSQL = ('insert_project_data')
            execData = (prjName, None, None, None,None,None, None, None)
            print(execSQL,execData,file=tempOutFile)
            prjID = dbu.fetchStoredFuncRes(db_conn, execSQL,execData)[0]
            print(prjID)
            return prjID

    except (Exception, psycopg2.DatabaseError) as error:
        print("Database Error %s " % error)
        raise

# This function inserts the values into the bundles table.
# After insertion, it obtains the bundle id from the database and stores in the global
# bundles_dict which is then used by insertActivities() function to obtain the
# db bundle id
def insertBundlesData():
    try:
        # get database connection
        db_conn = dbu.getConn()
        lParentBundleID = None
        print("-------Writing WBS Data to Bundles Table --------------------",file=tempOutFile)
        for i in range (0, len(final_wbs_list)):
            lPhaseID = None
            local_bundle_list = []
            lBundleID = final_wbs_list[i][0]
            lBundleName = final_wbs_list[i][1]

            # create a list with client_bundleid,bundle_name & database created bundleID
            local_bundle_list.append(lBundleID)

            # Get the phaseID from key_value_list : contains db_phaseID, client_taskID, client_bundlesID
            lPhaseID = findPhaseValue(lBundleID)

            #Get the phase id to be inserted into the bundle table from phases_dict
            #if lBundleID in phases_dict:
            #    lPhaseID = phases_dict[lBundleID]

            print("----- INSERT Statements for Bundles ------------------", file=tempOutFile)
            execSQL = ('insert_bundles_data')
            execData = (lParentBundleID,lBundleName,ProjectID,None,lPhaseID)
            print(execSQL, execData,file=tempOutFile)
            #print(execSQL, execData)
            # inserting the bundles into the bundles table
            lCurrentBundleID = dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]
            local_bundle_list.append(lCurrentBundleID) # this is the current bundleid from database query
            lParentBundleID = lCurrentBundleID
            bundle_list.append(local_bundle_list)
            # update the bundle_dictionary which will be read for inserting bundle_activities data
            bundle_dict.update({lBundleID:lCurrentBundleID})

            # ------------ Code for inserting data into BUNDLE_PHASES -----------------
            # Since phaseID is part of bundles table, we are not inserting any data in BUNDLE_PHASES table
            # The below code is left back, in case in future, data needs to be inserted
            # --------------------------------------------------------------------------------------------

            #if lBundleID in phases_dict:
            #    print("----- INSERT Statements for BUNDLE_PHASES ------------------", file=tempOutFile)
            #    execSQL = "INSERT INTO BUNDLE_PHASES (BUNDLE_ID, PHASE_ID) VALUES (%s,%s);"
            #    execData = (lBundleID,phases_dict[lBundleID])
            #    print(execSQL, execData, file=tempOutFile)
            #    dbu.executeQueryWithData(db_conn, execSQL, execData)

        print('-------------Bundle List ----------------------',file=tempOutFile)
        print(bundle_list,file=tempOutFile)

        print('-------------Bundle Dictionary ----------------------', file=tempOutFile)
        print(bundle_dict, file=tempOutFile)
    except (Exception, psycopg2.DatabaseError) as error:
        print("Database Error in insertBundlesData() %s " % error)
        raise

# this function is called from : createActivityPhases()
# This function just inverts the key,value pair of phase_dict
# Then creates a list of the dictionary phase_dict{}
def createKeyValueListOfPhases():
    try:
        local_phases_dict = phases_dict
        # first invert the key, value pair of the phases dictionary
        inv_map = {v: k for k, v in local_phases_dict.items()}

        key_list = list(inv_map.keys())
        value_list = list(inv_map.values())

        # first create a list of list from the key, value pair
        # eg) [[6,'1234'][7,'45645']]
        j = 0
        global  key_value_list

        for i in range(0, len(key_list)):
            local_list = []
            local_list.append(key_list[i])
            local_list.append(value_list[j])
            j = j + 1
            key_value_list.append(local_list)
        #print(len(key_value_list), key_value_list)

    except (Exception) as error:
        print('Error in createKeyValueListOfPhases()', error)


def createActivityPhases():
    try:

        # first get the wbs_final_list and task_final_list
        # first create a list of list : key value of dictionary
        # Calling function createKeyValueListOfPhases()
        createKeyValueListOfPhases()
        print(key_value_list)

        local_wbs_list = final_wbs_list
        local_task_list = final_task_list

        # now equate the wbs id and parent id to form the chain and update the key_value_list
        for i in range(0, len(final_wbs_list)):
            for j in range(0,len(key_value_list)):
                if final_wbs_list[i][2] in key_value_list[j]:
                    key_value_list[j].append(final_wbs_list[i][0])

        # now write the task list and key value list for getting the activity and phaseid
        for i in range(0, len(final_task_list)):
            for j in range(0,len(key_value_list)):
                if final_task_list[i][1] in key_value_list[j]:
                    key_value_list[j].append(final_task_list[i][0])

        # The key_value_list contans - db_phaseID, client phaseIDs and client TaskID
        # all grouped together based on db_phaseID which is the first element in
        # key_value_list[]

        print('--------------- PhaseID with TaskID and WBS_ID--------------------',file=tempOutFile)
        print(key_value_list,file=tempOutFile)

        #findPhaseValue('1010190')

    except (Exception) as error:
        print('Error occured in createActivityPhases:', error)


#This function returns the phaseId once the client activity id is passed
# This function is called mainly from insertActivity() to get the phaseID from the cliend ActivityID
def findPhaseValue(val):
    for i in range(0,len(key_value_list)):
        if val in key_value_list[i]:
            #print(key_value_list[i][0], val)
            return key_value_list[i][0]

#This function returns 1 if the task id is a mileStone : TT_FinMile or TT_Mile
# This function is called mainly from insertActivity() to get the is_Milestone for activities table
def findIfMileStone(val):
    if val in activity_milestone:
        #print(key_value_list[i][0], val)
        return 1
    else:
        return 0

# This function takes the final_task_list and creates a list of task which is a milestone: TT_FinMile or TT_Mile
# this data is captured in the final_task_list of item[15]
def createMileStone():
    try:
        global  activity_milestone
        # get the final_task_list
        for i in range(0,len(final_task_list)):
            # parse through each list and see whether it is a milestone
            # if it is a mile stone - TT_FinMile or TT_Mile, then insert the activity into the activity_milestone list
            if final_task_list[i][15] == "TT_FinMile":
                activity_milestone.append(final_task_list[i][0])
            if final_task_list[i][15] == "TT_Mile":
                activity_milestone.append(final_task_list[i][0])

        print("\\n",file=tempOutFile)
        print('----------MileStone Activities ---------------', file=tempOutFile)
        print(activity_milestone,file=tempOutFile)

    except (Exception) as error:
        print('Error in createMileStone():', error)

# Function calls inorder
ReadWriteWBSID()
ReadwriteTASKS()
readHolidays()
getProjectID()
createPhases()
insertPhases()
createActivityPhases()
insertBundlesData()
createMileStone()
insertActivity()
expandDates()

# -- End of Program ---#