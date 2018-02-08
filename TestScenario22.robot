*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/22
${FileTMP}    ${Table2}_20180207.txt
${LogTMP}    ${Table2}_20180207.log

*** Test Cases ***

Remove ZUTBLCOLSPRJ_20180207.txt on FTP
    Remove file on FTP  ${File2}  ${LogTMP}

File on FTP ZUTBLCOLSPRJ
    Put file to Host    ${FileTMP}
    Put file to FTP     ${FileTMP}

Get Input File ข้อมูลโครงการย่อย ที่มี ไฟล์ Date ตรงกับวันที่รันFIle
    [Documentation]   Get Input File ข้อมูลโครงการย่อย ที่มี ไฟล์ Date ไม่ตรงกับวันที่รัน File
    [Tags]    ZUTBLCOLSPRJ
    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_GET.sh ${Dir} ${Table2}
    #log To Console      \n${output}
    Should Contain  ${output}  Cannot get ${File2} file
    file should not exist  ${CBSPathTo}/${File2}

