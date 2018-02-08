*** Settings ***
Library                SSHLibrary


*** Variables ***

${Table1}      ZUTBLCOLPRJ
${Table2}      ZUTBLCOLSPRJ
${Date}      20180208
#${Dir}      /gsbpvt
#${HostIP}    10.251.87.86
#${HostUser}         pvtadm
${Dir}      /gsbiist
${HostIP}    10.251.87.85
${HostUser}         iistadm
${HostPass}         ${HostUser}
${File1}    ${Table1}_${Date}.txt
${LogFile1}    ${Table1}_${Date}.log
${File2}    ${Table2}_${Date}.txt
${LogFile2}    ${Table2}_${Date}.log
${TCGPath}      ${Dir}/spool/extract/TCG
${CBSPathTo}    ${Dir}/spool/extract/TCG/ToCBS
${CBSPathFrom}    ${Dir}/spool/extract/TCG/FromCBS
${FTPPathTo}       TCG/ToCBS
${FTPPathFrom}       TCG/FromCBS
${SCRIPT_FILE_PUT}  put_ftp.txt
${SCRIPT_FILE_RM}  rm_ftp.txt
${FTPIP}  10.20.6.58
${FTPHostUser}  cbsist
