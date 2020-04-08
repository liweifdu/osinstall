#!/bin/bash

#--- PARAMETER -------------------------
# directory or file name
NAME_LOG_JOB="$$.log"
NAME_DIR_LOAD="/home/liwei/Desktop/dump"
NAME_SIM="sim"
CHECK_DAT="check_data"

# sequence
#  name              frame fps width height depth
LIST_AVAILABLE=(
  "BasketballPass"   10   60  416   240    8
  "BQSquare"         10   60  416   240    8
  "BlowingBubbles"   10   60  416   240    8
  "RaceHorses"       10   60  416   240    8
  "BasketballDrill"  10   60  832   480    8
  "BQMall"           10   60  832   480    8
  "PartyScene"       10   60  832   480    8
  "RaceHorsesC"      10   60  832   480    8
  "FourPeople"       10   60  1280  720    8
  "Johnny"           10   60  1280  720    8
  "KristenAndSara"   10   60  1280  720    8
  "Kimono"           10   60  1920  1080   8
  "ParkScene"        10   60  1920  1080   8
  "Cactus"           10   60  1920  1080   8
  "BasketballDrive"  10   60  1920  1080   8
  "BQTerrace"        10   60  1920  1080   8
  "Traffic"          10   60  2560  1600   8
  "PeopleOnStreet"   10   60  2560  1600   8
)
LIST_SEQ=(
  "BasketballPass"
  "BQSquare"
  "BlowingBubbles"
  "RaceHorses"
  "BasketballDrill"
  "BQMall"
  "PartyScene"
  "RaceHorsesC"
  "FourPeople"
  "Johnny"
  "KristenAndSara"
  "Kimono"
  "ParkScene"
  "Cactus"
  "BasketballDrive"
  "BQTerrace"
  "Traffic"
  "PeopleOnStreet"
)

# encoder
LIST_QP=($(seq 22 5 37))

#--- MAIN BODY -------------------------
# note down the current time
timeBgnAll=$(date +%s)

#--- LOOP SEQUENCE ---
cntSeq=0
numSeq=${#LIST_SEQ[*]}
while [ $cntSeq -lt $numSeq ]
do
  # extract parameter
  NAME_SEQ=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))

  # log
  echo ""
  echo "processing $NAME_SEQ ..."

  # note down the current time
  timeBgnCur=$(date +%s)

  #--- LOOP QP (ENCODE) ---
  cntQp=0
  numQp=${#LIST_QP[*]}
  while [ $cntQp -lt $numQp ]
  do
    # extract parameter
    DATA_QP=${LIST_QP[ $((cntQp + 0)) ]}
    PREF_DUMP=${NAME_SEQ}_${DATA_QP}
    PREF_LOAD=$NAME_DIR_LOAD/${NAME_SEQ}_${DATA_QP}

    # update counter
    cntQp=$((cntQp + 1))

    # log
    echo "    qp $DATA_QP launched ..."

    # make directory
    cp ${NAME_SEQ}_${DATA_QP}/cabac.log /home/liwei/Desktop/refer/${NAME_SEQ}_${DATA_QP}.log
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
  done
  rm $NAME_LOG_JOB
  timeEnd=$(date +%s)
  printf "    delta time: %d min %d s; run time: %d min %d s                   \n"    \
    $(((timeEnd-timeBgnCur) / 60                        ))                            \
    $(((timeEnd-timeBgnCur) - (timeEnd-timeBgnCur)/60*60))                            \
    $(((timeEnd-timeBgnAll) / 60                        ))                            \
    $(((timeEnd-timeBgnAll) - (timeEnd-timeBgnAll)/60*60))

done
