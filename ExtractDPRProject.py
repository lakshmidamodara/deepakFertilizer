'''
File Name      : df_dpr_parser.py
Author Name    : Lakshmi Damodara
Creation Date  : 25/28/2018
Version        : 1.0
Description    :
     This program reads the dpr files of deepak fertilizer and loads in the respective tables of cct
Output File
1. Based on the number of activities, respective files are written in the output directory
2. The output directory can be configured on excel_file_config.ini file

'''


from datetime import datetime, timedelta
import xlrd
import sys
import psycopg2
import calendar
import db_utilities as dbu
import excel_config_reader as ecr


#setting global variables
global projectID
global phaseID

print('##-------------------- ---------------------------------........')
print('##---Program: df_df_parser.py..........................')
print(datetime.today())
print('##-----------------------------------------------------........')

#outFilepath = 'c:\\temp\\deepak\\DPRfiles\\'
inFilepath = 'c:\\temp\\deepak\\'
inputFilename = inFilepath + 'FInalPlan.xlsx'

# open the excel sheet using the xlrd library
#wb = xlrd.open_workbook(file_contents=excelData.getvalue())
wb = xlrd.open_workbook(inputFilename)
#get all the sheetnames from the excel sheet in a list
sheetNames = wb.sheet_names()
sheetIndex = 0

## All the data should be read off of sheet CCT
## Finding the sheet index so it can be used in the methods
for i in range(0, len(sheetNames)):
    if sheetNames[i] == 'CCT':
        sheetIndex = i
        break

activeSheet = wb.sheet_by_index(sheetIndex)

def getProjectAndPhaseData():
    try:
        print('Reading project info')

        ## Get project info and insert it into the database
        global projectID, phaseID
        projectName = activeSheet.cell_value(2,1).split(":")[1]
        projectID = insertProjectData(projectName)

        ## Get phase information and insert it into the database
        db_conn = dbu.getConn()
        phaseName = activeSheet.cell_value(4,1).split(":")[1]
        execSQL = ('insert_phases_data')
        execData = (phaseName, projectID)
        print(execSQL, execData)
        phaseID = dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]
        db_conn.close()
    except (Exception) as error:
        print(datetime.now(),error)
        raise

## This method reads all the Bundles and activities from CCT
## This data will be inserted into bundles, bundle_activities and activities
def getBundlesAndActivities():
    try:
        row_count = wb.sheet_by_index(sheetIndex).nrows
        db_conn = dbu.getConn()

        ## Get Parent bundle inserted
        bundleName = activeSheet.cell_value(3, 1).split(":")[1]
        execSQL = ('insert_bundles_data')
        execData = (None, bundleName, projectID, None, phaseID, None)
       # print(execSQL, execData)
       # parentBundleID = dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]
        bundleID = 0

        parentBundleID = None
        for i in range(7, row_count):
            if( activeSheet.cell_value(i,1) == 'Grand Total'):  ## End of activities
                break
            if( activeSheet.cell_value(i,1).find('Total') == -1 ):   ## Ignore rows that are sub totals
                ## Check to see if the row is a bundle or activity
                ## If its a bundle insert into bundles database
                if activeSheet.cell_value(i,2) == '':
                    ## This is a bundle
                    execSQL = ('insert_bundles_data')
                    clientBundleID = str(activeSheet.cell_value(i,0))
                    bundleName = activeSheet.cell_value(i,1)
                    execData = (parentBundleID, bundleName, projectID, None, phaseID, clientBundleID)
                    print(execSQL, execData)
                    bundleID = dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]
                    continue

                ## Get activities and tie them to bundles
                clientActivityID = str(activeSheet.cell_value(i,0))
                activityName = activeSheet.cell_value(i,1)

                plannedStart = None
                plannedEnd = None
                if ( activeSheet.cell_value(i,2) != 'NA' ):
                    plannedStart = xlrd.xldate.xldate_as_datetime(activeSheet.cell_value(i,2), wb.datemode).strftime('%Y%m%d')
                if (activeSheet.cell_value(i, 3) != 'NA'):
                    plannedEnd = xlrd.xldate.xldate_as_datetime(activeSheet.cell_value(i,3), wb.datemode).strftime('%Y%m%d')

                ##Get units ID
                unitName = activeSheet.cell_value(i,4)
                execSQL = ('insert_units_data')
                execData = (unitName, None)
                print(execSQL, execData)
                unitID = dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]

                plannedUnits = activeSheet.cell_value(i, 5)
                if plannedUnits == '' or plannedUnits == 'NA':
                    plannedUnits = 0

                actualUnits = activeSheet.cell_value(i, 6)
                if actualUnits == '' or actualUnits == 'NA':
                    actualUnits = 0

                execSQL = ('insert_activities_data')
                execData = (activityName, unitID, None, None, None, phaseID, projectID,
                            plannedUnits, plannedStart, plannedEnd, unitName, None, None,
                            clientActivityID, None, None, None, None, None, None, None)
                print(execSQL, execData)
                activityID = dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]

                ## Insert into bundle_activities
                execSQL = ('insert_bundle_activities_data')
                execData = (bundleID, activityID)
                print(execSQL, execData)
                dbu.fetchStoredFuncRes(db_conn, execSQL, execData)[0]
                ## Now insert into activity_data
                insertActivityData(activityID, plannedStart, plannedEnd, plannedUnits, actualUnits)
    except (Exception) as error:
        print(datetime.now(), error)
        raise

def insertProjectData(prjName):
    try:
        db_conn = dbu.getConn()
        execSQL = ('insert_project_data')
        execData = (prjName, None, None, None,None,None, None, None)
        print(execSQL, execData)
        prjID = dbu.fetchStoredFuncRes(db_conn, execSQL,execData)[0]
        db_conn.close()
        return prjID
    except (Exception, psycopg2.DatabaseError) as error:
        print(datetime.now(),"Database Error %s " % error)
        print(sys.exc_traceback.tb_lineno)
        raise

def insertActivityData(activityID, plannedStart, plannedEnd, plannedUnits, actualUnits):
    try:
        db_conn = dbu.getConn()
        tWdays = ecr.getTotalWorkdays()
        execSQL = """delete from activity_data ad 
                                              using activities a where ad.activity_id = '{a_id}'
                                              and a.project_id = '{id}';"""
        execSQL = execSQL.format(a_id=activityID, id=projectID)
        dbu.executeQuery(db_conn, execSQL)

        if (plannedStart == None or plannedEnd == None):
            execSQL = "INSERT INTO ACTIVITY_DATA (ACTIVITY_ID,PLANNED_UNITS,ACTUAL_UNITS) VALUES (%s,%s,%s);"
            execData = (activityID, plannedUnits, actualUnits)
            dbu.executeQueryWithData(db_conn, execSQL, execData)
            return

        execSQL = "INSERT INTO ACTIVITY_DATA (ACTIVITY_ID,DATE,PLANNED_HOURS) VALUES (%s,%s,%s);"

        dtDate = datetime.strptime(plannedStart, '%Y%m%d')
        enddtDate = datetime.strptime(plannedEnd, '%Y%m%d')
        # Now for each activity, expand the dates startDate until end date
        # and insert into the activities_data table
        dd = [dtDate + timedelta(days=x) for x in range((enddtDate - dtDate).days + 1)]

        workingDayCount = 0
        planned_hours = 8

        for d in dd:
            # execSQL = ('insert_activity_data_data'
            wDay = getDayofWeek(d)
            dt = datetime.date(d)

            if wDay == 0 or wDay == 1 or wDay == 2 or wDay == 3 or wDay == 4:  # monday - friday
                planned_hours = 8
                workingDayCount = workingDayCount + 1
            elif wDay == 5 or wDay == 6:  # if it is a saturday or sunday, insert a NONE for the planned hours
                planned_hours = None

            execData = (activityID, d, planned_hours)
            dbu.executeQueryWithData(db_conn, execSQL, execData)

        # First calculate for planned units
        dailyPlannedUnits = 0
        if plannedUnits != 0 and workingDayCount != 0:
            dailyPlannedUnits = (plannedUnits / workingDayCount)

        # Next calculate for Actual Units
        dailyActualUnits = 0
        if actualUnits != 0 and workingDayCount != 0:
            dailyActualUnits = (actualUnits / workingDayCount)

        planned_hours = 8
        execSQL = "UPDATE ACTIVITY_DATA SET PLANNED_UNITS=%s, ACTUAL_UNITS=%s WHERE ACTIVITY_ID=%s AND" \
                  " PLANNED_HOURS=%s;"
        execData = (dailyPlannedUnits, dailyActualUnits, activityID, planned_hours)
        dbu.executeQueryWithData(db_conn, execSQL, execData)

    except (Exception) as error:
        print(datetime.now(), error)
        raise

def getDayofWeek(ddDate):
    try:
        strDate = str(ddDate)
        ddDate = datetime.strptime(strDate, "%Y-%m-%d %H:%M:%S")
        wkday = calendar.weekday(ddDate.year, ddDate.month, ddDate.day)
        return wkday
    except (Exception) as error:
        print(datetime.now(),"Error in getDayofWeek(): %s" %error)
        print(sys.exc_traceback.tb_lineno)

getProjectAndPhaseData()
getBundlesAndActivities()