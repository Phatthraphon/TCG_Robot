*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/23
${KeyGBL}       ZCOLSPRJ

*** Test Cases ***

Insert Sub - Project Code is Null
    [Documentation]    Compare data ZUTBLCOLPRJ include header
    [Tags]    ZUTBLCOLSPRJ

    Remove file on FTP  ${File2}  ${LogFile2}
    Kill Globle DATA    ${KeyGBL}
    Put file to Host For Run  ${File2}

    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${table2}
    Should Contain  ${output}  Run procedure in profile complete

    file should exist  ${CBSPathFrom}/${LogFile2}
    ${output}=       Execute Command  cat ${CBSPathFrom}/${LogFile2}
    Should Contain  ${output}   invalid format

    Run SQL ZUTBLCOLSPRJ
    file should exist  ${TCGPath}/${File2}
    ${output}=      Execute Command  sed -n '$=' ${TCGPath}/${File2}
    #log To Console      \n${output}
    Should be empty    ${output}

