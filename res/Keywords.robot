*** Settings ***
Resource          Variable.robot

*** Keywords ***

Open Connection And Log In
   Open Connection    ${HostIP}     #encoding=iso8859_11
   Login    ${HostUser}    ${HostPass}

Put file to Host
    [Arguments]    ${file}
    #file should not exist  ${TCGPath}/${file}
    Put File  ${LocalPath}/${file}     ${TCGPath}
    file should exist  ${TCGPath}/${file}
    Sleep   1s

Put file to FTP
    [Arguments]    ${file}
    Start Command   echo "lcd ${TCGPath}" > ${TCGPath}/${SCRIPT_FILE_PUT}
    Start Command   echo "put ${TCGPath}/${file} ${FTPPathTo}/${file}" >> ${TCGPath}/${SCRIPT_FILE_PUT}
    Start Command   echo "exit" >> ${TCGPath}/${SCRIPT_FILE_PUT}
    Start Command   sftp -b ${TCGPath}/${SCRIPT_FILE_PUT} ${FTPHostUser}@${FTPIP}
    Sleep   1s

Remove file on FTP
    [Arguments]    ${file}  ${logFile}
    Start Command   echo "rm ${FTPPathTo}/${file}" > ${TCGPath}/${SCRIPT_FILE_RM}
    Start Command   echo "rm ${FTPPathFrom}/${logFile}" >> ${TCGPath}/${SCRIPT_FILE_RM}
    Start Command   echo "exit" >> ${TCGPath}/${SCRIPT_FILE_RM}
    Start Command   sftp -b ${TCGPath}/${SCRIPT_FILE_RM} ${FTPHostUser}@${FTPIP}
    Start Command   rm ${TCGPath}/${file}
    Start Command   rm ${CBSPathTo}/${file}
    Start Command   rm ${CBSPathFrom}/${logFile}
    Start Command   rm ${TCGPath}/${file}
    Start Command   rm ${TCGPath}/${SCRIPT_FILE_RM}
    Start Command   rm ${TCGPath}/${SCRIPT_FILE_PUT}
    Sleep   1s

Kill Globle DATA
    [Arguments]    ${Key}
    #Access to GTM
    Write      dm
    Write   k ^UTBL("${Key}")
    Read until  GTM>
    Write   H

Run SQL ZUTBLCOLPRJ
    #Access to GTM
    Write      dm
    Write      D EXPORT^SQLOADER("select PROJCD,DESC from ZUTBLCOLPRJ","${TCGPath}/${File1}",0,124,1)
    Read until  GTM>
    Write   H

Run SQL ZUTBLCOLSPRJ
    #Access to GTM
    Write      dm
    Write      D EXPORT^SQLOADER("select PROJCD,SUBCD,DESC,STARTDT,ENDDT,MAXALOC from ZUTBLCOLSPRJ","${TCGPath}/${File2}",0,124,1)
    Read until  GTM>
    Write   H

Copy File and Insert
    [Documentation]    Copy file to ftp and run get file and insert data to table
    [Arguments]    ${file}  ${logFile}  ${table}
    Remove file on FTP  ${file}  ${logFile}
    Kill Globle DATA    ${KeyGBL}
    Put file to Host    ${file}
    Put file to FTP     ${file}
    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_GET.sh ${Dir} ${table}
    #log To Console      \n${output}
    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${table}
    #log To Console      \n${output}
