*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/21
${PRJPath}    file/11

*** Test Cases ***

Execute Command
    [Documentation]    Test Connection and Remove old file
    Remove file on FTP  ${File2}  ${LogFile2}
    Kill Globle DATA  ZCOLSPRJ
    #${output2}=      Execute Command    /cbs/bin/sql.sh /gsbpvt ${sql} ${xxx}
    #log To Console      \n${output2}\n
Execute Command2
    Kill Globle DATA    ZCOLPRJ
    Put file to Host For Run  ${File1}  ${PRJPath}
    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${table1}

File on FTP ZUTBLCOLSPRJ
    [Documentation]
    Put file to Host    ${File2}
    Put file to FTP     ${File2}

Get File ZUTBLCOLSPRJ from FTP Server
    [Documentation]    Get Input File ข้อมูลโครงการย่อย ที่มี ไฟล์ Date ตรงกับวันที่รัน File
    [Tags]    ZUTBLCOLSPRJ
    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_GET.sh ${Dir} ${Table2}
    #log To Console      \n${output}
    file should exist  ${CBSPathTo}/${File2}
    ${output2}=      Execute Command  cat ${CBSPathTo}/${File2}
    log To Console      \n${output2}
    Sleep   2s

Insert data to ZUTBLCOLSPRJ
    [Documentation]   Run โปรแกรมเพื่ออัพเดทข้อมูลโครงการย่อย กรณีจำนวน Record ไม่ตรงตามข้อมูล ใน Trailer
    [Tags]    ZUTBLCOLSPRJ
    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${Table2}
    file should exist  ${CBSPathFrom}/${LogFile2}

    ${wc1}=      Execute Command  grep -c 'D|' ${CBSPathFrom}/${LogFile2}
    ${wc2}=      Execute Command  grep -c 'D|' ${CBSPathTo}/${File2}
    Should Be Equal As Integers     ${wc1}   ${wc2}
    file should exist  ${CBSPathFrom}/${LogFile2}
    Sleep   2s

Count Database ZUTBLCOLSPRJ
    [Documentation]    Run โปรแกรมเพื่ออัพเดทข้อมูลโครงการย่อยที่มีอยู่แล้ว กรณีที่ ส่งข้อมูลได้ครบถ้วนถูกต้องตรงตาม Format Layout
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
    [Documentation]    สร้าง Output การอัพเดทโครงการย่อย

    ${rc} =  Execute Command  ${Dir}/Batch/ZTCG_PUT.sh ${Dir} ${Table2}  return_stdout=False   return_rc=True
    Should Be Equal As Integers     ${rc}   0   # succeeded

    ${output}=      Execute Command  cat ${CBSPathFrom}/${LogFile2}
    log To Console      \n${output}
    Sleep   2s


