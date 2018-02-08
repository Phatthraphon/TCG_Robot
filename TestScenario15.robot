*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/15

*** Test Cases ***

Insert File 0 (Project)
    [Documentation]
    [Tags]    ZUTBLCOLPRJ
    Remove file on FTP  ${File1}  ${LogFile1}
    Put file to Host For Run  ${File1}

    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${table1}
    Should Contain  ${output}  Run procedure in profile complete
    file should exist  ${CBSPathFrom}/${LogFile1}
    ${output}=      Execute Command  cat ${CBSPathFrom}/${LogFile1}
    Should Contain  ${output}  T|0

