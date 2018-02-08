*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/12

*** Test Cases ***

Get Input File ข้อมูลโครงการ ที่มี ไฟล์ Date ไม่ตรงกับวันที่รัน File
    [Tags]    ZUTBLCOLPRJ
    Remove file on FTP  ${File1}  ${LogFile1}

    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_GET.sh ${Dir} ${Table1}
    #log To Console      \n${output}
    Should Contain  ${output}  Cannot get ${File1} file
    file should not exist  ${CBSPathTo}/${File1}

