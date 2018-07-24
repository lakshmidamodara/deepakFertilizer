import sys
import base64
import io
from datetime import datetime, timedelta
import calendar
import db_utilities as dbu
import psycopg2

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

global ProjectID

#offile=open(outfile,"wb")

# Read the file and get the output from the following string onwards
wbs_id = '%T' + '\t' + 'PROJWBS'
wbs_id_end = '%T' + '\t' + 'ACTVTYPE'
word_task = '%T' + '\t' + 'TASK'
word_task_end = '%T' + '\t' + 'TASKACTV'
word_task_resource_id = '%T' + '\t' + 'TASKRSRC'
word_task_resource_end = '%T' + '\t' + 'UDFVALUE'

word_loc_wbs_id = 0
word_loc_wbs_id_end = 0
word_loc_task = []
word_loc_task_end = 0
word_loc_task_resource_id = 0
word_loc_task_resource_end = 0

wbs_list = []
task_list = []

final_wbs_list = []
final_task_list = []
final_activity_resource_list = []
bundle_list = []

bundle_dict = {}

with open(infile, 'r') as f:
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
        if word_task_resource_id in line:
            #print("Word \"{}\" found in line {}".format(word_task_resource_id, i + 1))
            word_loc_task_resource_id = i+1
        if word_task_resource_end in line:
            #print("Word \"{}\" found in line {}".format(word_task_resource_end, i + 1))
            word_loc_task_resource_end = i+1

    #print(word_loc_task)

def ReadWriteWBSID():
    row = []
    # now write the wbs_id data into a file with starting and ending line numbers
    with open(infile, 'r') as f:
        for line in f.readlines()[word_loc_wbs_id:word_loc_wbs_id_end-1]:
            #print(line,file=tempOutFile)
            row.append([line])
            for i in line.split(","):
                row[-1].append(i)
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


def ReadwriteTASKS():
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
        ## remove quotes and other data from the list and write to final_wbs_list

        for i in range(0,len(wbs_list)):
            replaceSingleQuotes_TASK(wbs_list[i])

    f.close()
    myfile.close()
    print("----- Final Task List ------------------", file=tempOutFile)
    print(final_task_list, file=tempOutFile)

#-------- Utility functions ---------------

def processString(row,diff):
    LList = {}
    LName = row[10]
    endIndex = 10 + diff
    parentId = row[endIndex+2]
    for i in range (11, endIndex+1):
        LName = LName + "" + row[i]
    dict = {'Name': LName, 'Parent': parentId}
    return dict

def replaceSingleQuotes_WBS(txt):
    local_wbs_list = []
    for row in csv.reader(txt.splitlines()):
        diff = len(row) - 27
        local_wbs_list.append(row[1])
        if len(row) == 27:
            local_wbs_list.append(row[10])
            local_wbs_list.append(row[12])
        elif len(row) != 27 :
            LName = row[10]
            endIndex = 10 + diff
            parentId = row[endIndex + 2]
            for i in range(11, endIndex + 1):
                LName = LName + "" + row[i]
            local_wbs_list.append(LName)
            local_wbs_list.append(parentId)

    final_wbs_list.append(local_wbs_list)

def replaceSingleQuotes_TASK(txt):
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

    final_task_list.append(local_task_list)

def insertActivity():
    try:
        print("\n", file=tempOutFile)
        db_conn = dbu.getConn()
        activity_dict = {}
        # first remove empty list from result_data i.e, if there are empty rows in the excel
        totalRec = len(final_task_list)

        for i in range(0, totalRec):
            activityId_temp = final_task_list[i][0]
            bundleID = final_task_list[i][1]
            activity_name_temp = final_task_list[i][2]
            activityName = activityId_temp + '-' + activity_name_temp
            actualStDate = final_task_list[i][5]
            actualEndDate = final_task_list[i][6]
            plannedStDate = final_task_list[i][13]
            plannedEndDate = final_task_list[i][14]
            total_planned_units_temp = float(final_task_list[i][4])
            total_planned_units = round(total_planned_units_temp)

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

            '''
            # activities table insert
            execSQL = "INSERT INTO ACTIVITIES (NAME,PROJECT_ID,PLANNED_START,PLANNED_END,TOTAL_PLANNED_UNITS) VALUES (%s,%s,%s,%s,%s);"
            execData = (activityName,ProjectID,actualStDate,actualEndDate,total_planned_units)
            print("----- INSERT Statements for Task List ------------------", file=tempOutFile)
            print(execSQL,execData,file=tempOutFile)
            dbu.executeQueryWithData(db_conn, execSQL, execData)
            '''

            print("----- INSERT Statements for activities ------------------", file=tempOutFile)
            execSQL = ('insert_activities_data')
            execData = (activityName,None,None,None,None,None,ProjectID,total_planned_units,plannedStDate,plannedEndDate,None,actualStDate,actualEndDate, None)
            print(execSQL, execData, file=tempOutFile)
            lCurrentActivityID = dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]

            #Now get the db_bundle id from the dictionary and insert into the corresponding bundle_activity table
            db_BundleID = bundle_dict.get(bundleID)

            # Bundle activities table insert
            execSQL = "INSERT INTO BUNDLE_ACTIVITIES (ACTIVITY_ID,BUNDLE_ID) VALUES (%s,%s);"
            execData = (lCurrentActivityID, db_BundleID)
            print("----- INSERT Statements for Task List ------------------", file=tempOutFile)
            print(execSQL, execData, file=tempOutFile)
            dbu.executeQueryWithData(db_conn, execSQL, execData)

    except(Exception) as error:
        print("Error in insertActivity:%s" %error)


def getLocalBundleID(keyValue):
    localValue = bundle_dict.get(keyValue)
    return localValue

def getProjectID():
    try:
        #first get the project name and check if project exists
        local_projectName = final_wbs_list[0][1]
        local_projectId = insertProjectData(local_projectName)
        print(local_projectId)
        global ProjectID
        ProjectID = local_projectId

    except (Exception) as error:
        print ("Error in reading Project Table(): %s" %error)


def insertProjectData(prjName):
    try:
        # get database connection
        db_conn = dbu.getConn()
        stProc = "SELECT ID from PROJECTS WHERE NAME='%s'" %prjName
        m_row = dbu.executeQueryRes(db_conn, stProc)[0]
        #numHolidays = len(m_row)
        if len(m_row) > 0:
            return m_row[0]
        else:
            print("----- INSERT Statements for New Project ------------------", file=tempOutFile)
            execSQL = ('insert_project_data')
            execData = (prjName, None, None, None,None,None, None, None)
            print(execSQL,execData,file=tempOutFile)
            prjID = dbu.fetchStoredFuncRes(db_conn, execSQL,execData)[0]
            return prjID

    except (Exception, psycopg2.DatabaseError) as error:
        print("Database Error %s " % error)
        raise


def insertBundlesData():
    try:
        # get database connection
        db_conn = dbu.getConn()
        lParentBundleID = None
        print("-------Writing WBS Data to Bundles Table --------------------",file=tempOutFile)
        for i in range (0, len(final_wbs_list)):
            local_bundle_list = []
            lBundleID = final_wbs_list[i][0]
            Local_lBundleName = final_wbs_list[i][1]
            lBundleName = lBundleID + "-" + Local_lBundleName
            # create a list with client_bundleid,bundle_name & database created bundleID
            local_bundle_list.append(lBundleID)

            print("----- INSERT Statements for Bundles ------------------", file=tempOutFile)
            execSQL = ('insert_bundles_data')
            execData = (lParentBundleID,lBundleName,ProjectID,None)
            print(execSQL, execData,file=tempOutFile)
            lCurrentBundleID = dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]
            #lCurrentBundleID = 101
            local_bundle_list.append(lCurrentBundleID) # this is the current bundleid from database query
            lParentBundleID = lCurrentBundleID
            bundle_list.append(local_bundle_list)
            # update the bundle_dictionary which will be read for inserting bundle_activities data
            bundle_dict.update({lBundleID:lCurrentBundleID})

        print('-------------Bundle List ----------------------',file=tempOutFile)
        print(bundle_list,file=tempOutFile)
    except (Exception, psycopg2.DatabaseError) as error:
        print("Database Error in insertBundlesData() %s " % error)
        raise


ReadWriteWBSID()
ReadwriteTASKS()
getProjectID()
insertBundlesData()
insertActivity()

