*** Settings ***

Resource          res/Variable.robot
Resource          res/Keywords.robot

Suite Setup            Open Connection And log In
Suite Teardown         Close All Connections

*** Variables ***
${LocalPath}    file/11

*** Test Cases ***

Execute Command
    [Documentation]    Test Connection and Remove old file
    [Tags]    ZUTBLCOLPRJ
    Remove file on FTP  ${File1}  ${LogFile1}
    Kill Globle DATA  ZCOLPRJ

File on FTP ZUTBLCOLPRJ
    [Documentation]    Upload flie ZUTBLCOLPRJ to ftp sever
    Put file to Host    ${File1}
    Put file to FTP     ${File1}

Get ZUTBLCOLPRJ from FTP Server
    [Documentation]    Get Input File ข้อมูลโครงการ ที่มี ไฟล์ Date ตรงกับวันที่รัน File
    [Tags]    ZUTBLCOLPRJ
    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_GET.sh ${Dir} ${Table1}
    #log To Console      \n${output}
    file should exist  ${CBSPathTo}/${File1}
    ${output2}=      Execute Command  cat ${CBSPathTo}/${File1}
    log To Console      \n${output2}
    Sleep   2s

Insert data to ZUTBLCOLPRJ
    [Documentation]    Run โปรแกรมเพื่ออัพเดทข้อมูลโครงการ กรณีจำนวน Record ตรงตามข้อมูล ใน Trailer
    [Tags]    ZUTBLCOLPRJ
    ${output}=      Execute Command  ${Dir}/Batch/ZTCG_RUN.sh ${Dir} ${Table1}
    #log To Console      \n${output}
    file should exist  ${CBSPathFrom}/${LogFile1}
    ${wc1}=      Execute Command  grep -c 'D|' ${CBSPathFrom}/${LogFile1}
    ${wc2}=      Execute Command  grep -c 'D|' ${CBSPathTo}/${File1}
    Should Be Equal As Integers    ${wc1}   ${wc2}
    Sleep   2s

Count Database ZUTBLCOLPRJ
    [Tags]    ZUTBLCOLPRJ
    [Documentation]    Run โปรแกรมเพื่ออัพเดทข้อมูลโครงการที่มีอยู่แล้ว กรณีที่ ส่งข้อมูลได้ครบถ้วนถูกต้องตรงตาม Format Layout
    Run SQL ZUTBLCOLPRJ
    file should exist  ${CBSPathTo}/${File1}
    #${wc1}=      Execute Command  sed -n '$=' ${CBSPathTo}/${File1}
    ${wc1}=      Execute Command  grep -c '|SUCCESS|' ${CBSPathFrom}/${LogFile1}

    file should exist  ${TCGPath}/${File1}
    ${wc2}=      Execute Command  sed -n '$=' ${TCGPath}/${File1}
    Should Be Equal    ${wc1}   ${wc2}

    ${output}=      Execute Command  cat ${TCGPath}/${File1}
    log To Console      \n${output}

Upload log file ZUTBLCOLPRJ
    [Documentation]    สร้าง Output การอัพเดทโครงการ
    ${rc} =  Execute Command  ${Dir}/Batch/ZTCG_PUT.sh ${Dir} ${Table1}  return_stdout=False   return_rc=True
    Should Be Equal As Integers     ${rc}   0   # succeeded

    ${output}=      Execute Command  cat ${CBSPathFrom}/${LogFile1}
    log To Console      \n${output}
    Sleep   2s


