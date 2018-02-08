*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/07
${KeyGBL}       ZCOLPRJ

*** Test Cases ***

Insert Project Code - Tailer is wrong
    [Documentation]
    [Tags]    ZUTBLCOLPRJ
    Remove file on FTP  ${File1}  ${LogFile1}
    Put file to Host For Run  ${File1}
    Kill Globle DATA    ${KeyGBL}

    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${table1}
    Should Contain  ${output}  INVALID RECORD NUMBER
    file should not exist  ${CBSPathFrom}/${LogFile1}

    Run SQL ZUTBLCOLPRJ
    file should exist  ${TCGPath}/${File1}
    ${output}=      Execute Command  sed -n '$=' ${TCGPath}/${File1}
    #log To Console      \n${output}
    Should be empty    ${output}

