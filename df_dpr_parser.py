'''
File Name      : df_dpr_parser.py
Author Name    : Lakshmi Damodara
Creation Date  : 25/28/2018
Version        : 1.0
Description    :
     This program reads the dpr files of deepak fertilizer and loads in the respective tables of cct


'''

import datetime
import xlrd
import sys

#setting global variables
global sheetNames

print('##-------------------- ---------------------------------........')
print('##---Program: df_df_parser.py..........................')
print(datetime.datetime.today())
print('##-----------------------------------------------------........')

#outFilepath = 'c:\\temp\\deepak\\DPRfiles\\'
inFilepath = 'c:\\temp\\deepak\\DPRfiles\\'
inputFilename = inFilepath + 'Civil_AR Eng_DPR 09.07.2018.xlsx'

# open the excel sheet using the xlrd library
#wb = xlrd.open_workbook(file_contents=excelData.getvalue())
wb = xlrd.open_workbook(inputFilename)
#get all the sheetnames from the excel sheet in a list
sheetNames = wb.sheet_names()

def readBillOfQuantitySheet():
    try:
        print('Reading and Writing Bill of Quantity')
        project = ""
        phase = ""
        billOfQuantity = []
        #get the sheet with Qty .plan
        #first get the index of the sheet from sheetNames
        sheetIndex = 0
        sheetName = 'Qty .plan'
        #sheetName = 'work report'

        for i in range(0,len(sheetNames)):
            if sheetNames[i] == sheetName:
                sheetIndex = i
                break

        # go to the active sheet - Qty .plan
        activeSheet = wb.sheet_by_index(sheetIndex)
        #get the total rows in the sheet
        row_count = wb.sheet_by_index(sheetIndex).nrows
        column_count = wb.sheet_by_index(sheetIndex).ncols

        #getting the project, phase and vendor details from the sheet - Qty .plan
        project = activeSheet.cell_value(4,0)
        phase = activeSheet.cell_value(5,0)
        vendor = activeSheet.cell_value(6,0)

        print(project)
        print(phase)
        print(vendor)

        j=1 # reading the column
        for i in range(13, row_count):
            dataList = []
            for j in range(1,12):
                dataList.append(activeSheet.cell_value(i, j))
            # Final BIllofQuantity List
            billOfQuantity.append(dataList)

        print(billOfQuantity)
        print('##### Finished :- Bill of Quantity')
    except (Exception) as error:
        print(datetime.now(),error)

def readMachinerySheet():
    try:
        print('Reading and Writing Machinery Sheet')
        machinery = []
        #get the sheet with Qty .plan
        #first get the index of the sheet from sheetNames
        sheetIndex = 0
        sheetName = 'machinery'
        #sheetName = 'work report'

        for i in range(0,len(sheetNames)):
            if sheetNames[i] == sheetName:
                sheetIndex = i
                break

        # go to the active sheet - Qty .plan
        activeSheet = wb.sheet_by_index(sheetIndex)
        #get the total rows in the sheet
        row_count = wb.sheet_by_index(sheetIndex).nrows
        column_count = wb.sheet_by_index(sheetIndex).ncols

        j=1 # reading the column
        for i in range(8, row_count):
            dataList = []
            for j in range(1,column_count):
                dataList.append(activeSheet.cell_value(i, j))
            # Final Machinery List
            machinery.append(dataList)

        print(machinery)
        print('Finished : Machinery Sheet')
    except (Exception) as error:
        print(datetime.now(),error)

readBillOfQuantitySheet()
readMachinerySheet()