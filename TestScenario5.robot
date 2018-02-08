*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/05
${KeyGBL}       ZCOLPRJ

*** Test Cases ***

Insert Project Code over five digit
    [Documentation]    Compare data ZUTBLCOLPRJ include header
    [Tags]    ZUTBLCOLPRJ
    Copy File and Insert    ${File1}  ${LogFile1}  ${Table1}

    file should exist  ${CBSPathFrom}/${LogFile1}
    ${output}=       Execute Command  cat ${CBSPathFrom}/${LogFile1}
    Should Contain  ${output}  REJECT

    Run SQL ZUTBLCOLPRJ
    file should exist  ${TCGPath}/${File1}
    ${output}=      Execute Command  sed -n '$=' ${TCGPath}/${File1}
    #log To Console      \n${output}
    Should be empty    ${output}


