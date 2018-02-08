*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/24

*** Test Cases ***

Insert Sub - Project Code - Trailer is wrong
    [Documentation]
    [Tags]    ZUTBLCOLSPRJ
    Remove file on FTP  ${File2}  ${LogFile2}
    Put file to Host For Run  ${File2}

    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${table2}
    Should Contain  ${output}  INVALID RECORD NUMBER
    file should not exist  ${CBSPathFrom}/${LogFile2}


