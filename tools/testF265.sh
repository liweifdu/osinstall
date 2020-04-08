#!/bin/bash
#-------------------------------------------------------------------------------
  #
  #  Filename      : testF265
  #  Author        : Huang Leilei
  #  Created       : 2019-02-22
  #  Description   : run f265 automatically
  #
#-------------------------------------------------------------------------------

#--- PARAMETER -------------------------
# directory or file name
#NAME_DIR_SEQ="E:/DOWNLOAD/SEQUENCE/bitDepth_8"
NAME_DIR_SEQ="/mnt/e/DOWNLOAD/SEQUENCE/bitDepth_8"
NAME_LOG_RLT="dump.log"
NAME_LOG_JOB="jobs.log"
NAME_DIR_DUMP="dump"
NAME_DIR_LOAD="load"

# sequence
#  name              frame fps width height depth
LIST_AVAILABLE=(
  "BasketballPass"   501   60  416   240    8
  "BQSquare"         601   60  416   240    8
  "BlowingBubbles"   501   60  416   240    8
  "RaceHorses"       300   60  416   240    8
  "BasketballDrill"  501   60  832   480    8
  "BQMall"           601   60  832   480    8
  "PartyScene"       501   60  832   480    8
  "RaceHorsesC"      300   60  832   480    8
  "FourPeople"       600   60  1280  720    8
  "Johnny"           600   60  1280  720    8
  "KristenAndSara"   600   60  1280  720    8
  "Kimono"           240   60  1920  1080   8
  "ParkScene"        240   60  1920  1080   8
  "Cactus"           500   60  1920  1080   8
  "BasketballDrive"  501   60  1920  1080   8
  "BQTerrace"        601   60  1920  1080   8
  "Traffic"          150   60  2560  1600   8
  "PeopleOnStreet"   150   60  2560  1600   8
)
LIST_SEQ=(
  "BasketballPass"   15    60  416   240    8
  "BQSquare"         15    60  416   240    8
  "BlowingBubbles"   15    60  416   240    8
  "RaceHorses"       15    60  416   240    8
  "BasketballDrill"  15    60  832   480    8
  "BQMall"           15    60  832   480    8
  "PartyScene"       15    60  832   480    8
  "RaceHorsesC"      15    60  832   480    8
  "FourPeople"       15    60  1280  720    8
  "Johnny"           15    60  1280  720    8
  "KristenAndSara"   15    60  1280  720    8
  "Kimono"           15    60  1920  1080   8
  "ParkScene"        15    60  1920  1080   8
  "Cactus"           15    60  1920  1080   8
  "BasketballDrive"  15    60  1920  1080   8
  "BQTerrace"        15    60  1920  1080   8
  "Traffic"          15    60  2560  1600   8
  "PeopleOnStreet"   15    60  2560  1600   8
)

# encoder
LIST_QP=($(seq 22 5 37))
#LIST_QP=14
#LIST_QP=22
SIZE_GOP=1
#SIZE_GOP=2
#SIZE_GOP=500

# dump
KNOB_DUMP_ENC_TOP=0
KNOB_DUMP_RMD_TOP=0
KNOB_DUMP_IME_TOP=0
KNOB_DUMP_FME_TOP=0
KNOB_DUMP_RDO_RES=0
KNOB_DUMP_RDO_REC=0
KNOB_DUMP_RDO_CST=0
KNOB_DUMP_RDO_TOP=0
KNOB_DUMP_ILF_DBF=0
KNOB_DUMP_ILF_SAO=0
KNOB_DUMP_E_C_TOP=0


#--- MAIN BODY -------------------------
#--- INIT ---
# prepare directory
mkdir -p $NAME_DIR_DUMP
rm -rf $NAME_DIR_DUMP/*
#printf "\n\n" > $NAME_LOG_RLT.bak

# note down the current time
timeBgnAll=$(date +%s)

#--- LOOP SEQUENCE ---
cntSeq=0
numSeq=${#LIST_SEQ[*]}
while [ $cntSeq -lt $numSeq ]
do
  # extract parameter
  NAME_SEQ=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  NUMB_FRA=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  DATA_FPS=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  SIZE_FRA_X=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  SIZE_FRA_Y=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  DATA_PXL_WD=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  FILE_SEQ="$NAME_DIR_SEQ/$NAME_SEQ/$NAME_SEQ"

  # log
  echo ""
  echo "processing $FILE_SEQ ..."

  # note down the current time
  timeBgnCur=$(date +%s)

  #--- LOOP QP (ENCODE) ---
  cntQp=0
  numQp=${#LIST_QP[*]}
  while [ $cntQp -lt $numQp ]
  do
    # extract parameter
    DATA_QP=${LIST_QP[ $((cntQp + 0)) ]}
    PREF_DUMP=$NAME_DIR_DUMP/${NAME_SEQ}_${DATA_QP}/
    PREF_LOAD=$NAME_DIR_LOAD/${NAME_SEQ}_${DATA_QP}/

    # update counter
    cntQp=$((cntQp + 1))

    # log
    echo "    qp $DATA_QP launched ..."

    # make directory
    mkdir $NAME_DIR_DUMP/${NAME_SEQ}_${DATA_QP}
    echo "\`define SIZE_FRA_X    'd$SIZE_FRA_X" >> ${PREF_DUMP}dut_setting.vh
    echo "\`define SIZE_FRA_Y    'd$SIZE_FRA_Y" >> ${PREF_DUMP}dut_setting.vh
    echo "\`define NUMB_FRA      'd$NUMB_FRA"   >> ${PREF_DUMP}dut_setting.vh
    echo "\`define SIZE_GOP      'd$SIZE_GOP"   >> ${PREF_DUMP}dut_setting.vh
    echo "\`define DATA_QP       'd$DATA_QP"    >> ${PREF_DUMP}dut_setting.vh

    # encode
    ./f265                                      \
      --filename         $FILE_SEQ.yuv          \
      --frame_per_second $DATA_FPS              \
      -f                 $NUMB_FRA              \
      -w                 $SIZE_FRA_X            \
      -h                 $SIZE_FRA_Y            \
      -g                 $SIZE_GOP              \
      -q                 $DATA_QP               \
      -c                 "./f265_encode.cfg"    \
      --dump-prefix      $PREF_DUMP             \
      --load-prefix      $PREF_LOAD             \
      --dump_enc_top     $KNOB_DUMP_ENC_TOP     \
      --dump_rmd_top     $KNOB_DUMP_RMD_TOP     \
      --dump_ime_top     $KNOB_DUMP_IME_TOP     \
      --dump_fme_top     $KNOB_DUMP_FME_TOP     \
      --dump_rdo_res     $KNOB_DUMP_RDO_RES     \
      --dump_rdo_rec     $KNOB_DUMP_RDO_REC     \
      --dump_rdo_cst     $KNOB_DUMP_RDO_CST     \
      --dump_rdo_top     $KNOB_DUMP_RDO_TOP     \
      --dump_ilf_dbf     $KNOB_DUMP_ILF_DBF     \
      --dump_ilf_sao     $KNOB_DUMP_ILF_SAO     \
      --dump_e_c_top     $KNOB_DUMP_E_C_TOP     \
    > "${PREF_DUMP}f265.log" &
  done

  # wait
  numJob=1
  while [ $numJob -ne 0 ]
  do
    sleep 1
    timeEnd=$(date +%s)
    printf "    delta time: %d min %d s; run time: %d min %d s (jobs: %d)        \r"    \
      $(((timeEnd-timeBgnCur) / 60                        ))                            \
      $(((timeEnd-timeBgnCur) - (timeEnd-timeBgnCur)/60*60))                            \
      $(((timeEnd-timeBgnAll) / 60                        ))                            \
      $(((timeEnd-timeBgnAll) - (timeEnd-timeBgnAll)/60*60))                            \
      $(jobs | wc -l)
    jobs > $NAME_LOG_JOB
    numJob=$(cat $NAME_LOG_JOB | wc -l)
    grep 127 $NAME_LOG_JOB
  done
  rm $NAME_LOG_JOB
  timeEnd=$(date +%s)
  printf "    delta time: %d min %d s; run time: %d min %d s                   \n"    \
    $(((timeEnd-timeBgnCur) / 60                        ))                            \
    $(((timeEnd-timeBgnCur) - (timeEnd-timeBgnCur)/60*60))                            \
    $(((timeEnd-timeBgnAll) / 60                        ))                            \
    $(((timeEnd-timeBgnAll) - (timeEnd-timeBgnAll)/60*60))

  #--- LOOP QP (CHECK) ---
  cntQp=0
  numQp=${#LIST_QP[*]}
  while [ $cntQp -lt $numQp ]
  do
    # extract parameter
    DATA_QP=${LIST_QP[ $((cntQp + 0)) ]}
    PREF_DUMP="$NAME_DIR_DUMP/${NAME_SEQ}_${DATA_QP}/"

    # update counter
    cntQp=$((cntQp + 1))

    # calculate md5
    md5sum ${PREF_DUMP}f265.hevc

    # decode
    ffmpeg -i ${PREF_DUMP}f265.hevc -v 0 ${PREF_DUMP}f265.tmp.yuv

    # compare
    flgDif=$(diff -q ${PREF_DUMP}f265.tmp.yuv ${PREF_DUMP}f265.yuv)

    # remove yuv
    if [ "$flgDif" != "" ]
    then
      echo $flgDif
    else
      rm -rf ${PREF_DUMP}f265.tmp.yuv ${PREF_DUMP}f265.yuv
    fi
  done

  # update info
  ./extractData.py
done
