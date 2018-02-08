*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/21

*** Test Cases ***

Execute Command
    [Documentation]    Test Connection and Remove old file
    ${output}=    Execute Command    echo Hello SSHLibrary!
    Should Be Equal    ${output}    Hello SSHLibrary!
    Remove file on FTP  ${File2}  ${LogFile2}
    Kill Globle DATA  ZCOLSPRJ
    #${output2}=      Execute Command    /cbs/bin/sql.sh /gsbpvt ${sql} ${xxx}
    #log To Console      \n${output2}\n

File on FTP ZUTBLCOLSPRJ
    [Documentation]    Upload flie ZUTBLCOLSPRJ to ftp sever
    Put file to Host    ${File2}
    Put file to FTP     ${File2}

Get File ZUTBLCOLSPRJ from FTP Server
    [Tags]    ZUTBLCOLSPRJ
    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_GET.sh ${Dir} ${Table2}
    #log To Console      \n${output}
    file should exist  ${CBSPathTo}/${File2}
    ${output2}=      Execute Command  cat ${CBSPathTo}/${File2}
    log To Console      \n${output2}
    Sleep   2s

Insert data to ZUTBLCOLSPRJ
    [Tags]    ZUTBLCOLSPRJ
    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${Table2}
    file should exist  ${CBSPathFrom}/${LogFile2}

    ${wc1}=      Execute Command  grep -c 'D|' ${CBSPathFrom}/${LogFile2}
    ${wc2}=      Execute Command  grep -c 'D|' ${CBSPathTo}/${File2}
    Should Be Equal As Integers     ${wc1}   ${wc2}
    file should exist  ${CBSPathFrom}/${LogFile2}
    Sleep   2s

Count Database ZUTBLCOLSPRJ
    [Documentation]    Compare log and database ZUTBLCOLSPRJ
    Run SQL ZUTBLCOLSPRJ
    file should exist  ${CBSPathTo}/${File2}
    #${wc} =    Execute Command  sed -n '$=' ${CBSPathTo}/${File2}
    ${wc}=      Execute Command  grep -c '|SUCCESS|' ${CBSPathFrom}/${LogFile2}

    file should exist  ${TCGPath}/${File2}
    ${wc7} =    Execute Command  sed -n '$=' ${TCGPath}/${File2}

    Should Be Equal     ${wc7}  ${wc}

    ${output} =    Execute Command  cat ${TCGPath}/${File2}
    log To Console      \n${output}

Upload log file ZUTBLCOLSPRJ
    [Tags]    ZUTBLCOLSPRJ
    [Documentation]    Upload file ZUTBLCOLSPRJ to ftp

    ${rc} =  Execute Command  ${Dir}/Batch/ZTCG_PUT.sh ${Dir} ${Table2}  return_stdout=False   return_rc=True
    Should Be Equal As Integers     ${rc}   0   # succeeded

    ${output}=      Execute Command  cat ${CBSPathFrom}/${LogFile2}
    log To Console      \n${output}
    Sleep   2s


