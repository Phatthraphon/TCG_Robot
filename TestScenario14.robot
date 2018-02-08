*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/14

*** Test Cases ***

Insert Project Code - Trailer is wrong
    [Documentation]
    [Tags]    ZUTBLCOLPRJ
    Remove file on FTP  ${File1}  ${LogFile1}
    Put file to Host For Run  ${File1}

    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${table1}
    Should Contain  ${output}  INVALID RECORD NUMBER
    file should not exist  ${CBSPathFrom}/${LogFile1}


