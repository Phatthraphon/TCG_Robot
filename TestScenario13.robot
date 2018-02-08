*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/13
${KeyGBL}       ZCOLPRJ

*** Test Cases ***

Insert Project Code is null
    [Documentation]    Run โปรแกรมเพื่ออัพเดทข้อมูลโครงการใหม่ กรณีไม่ส่งข้อมูล Project ID
    [Tags]    ZUTBLCOLPRJ
    Remove file on FTP  ${File1}  ${LogFile1}
    Kill Globle DATA    ${KeyGBL}
    Put file to Host For Run  ${File1}  ${LocalPath}

    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${table1}
    Should Contain  ${output}  Run procedure in profile complete

    file should exist  ${CBSPathFrom}/${LogFile1}
    ${output}=       Execute Command  cat ${CBSPathFrom}/${LogFile1}
    Should Contain  ${output}  invalid format

    Run SQL ZUTBLCOLPRJ
    file should exist  ${TCGPath}/${File1}
    ${output}=      Execute Command  sed -n '$=' ${TCGPath}/${File1}
    #log To Console      \n${output}
    Should be empty    ${output}


