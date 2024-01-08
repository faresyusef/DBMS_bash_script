#! /usr/bin/bash
shopt -s extglob
export LC_COLLATE=C

if [[ -e ~/myDatabase ]]
then
   cd ~/myDatabase
   echo "DBMS is ready"
else
   mkdir ~/myDatabase
   cd ~/myDatabase
   echo "DBMS is created successfully "
fi

PS3="enter your option : "
select option in CreateDB ListDB DropDB Connect_to_DB 
do

         #This Is The First Option [ 1- CreateDB ]

case $option in 
"CreateDB")
read -p "Please Enter Database Name: " DBNAME 

if [ -z $DBNAME ]
then
    echo "Please Enter Database Name Again: "
elif [ -e $DBNAME ]
then
    echo "Database Name Is Already Exist"

elif [[ $DBNAME =~ ^[a-zA-Z][a-zA-Z0-9] ]]
then
    mkdir $DBNAME
    echo "Database Is Created Successfuly"
else
   echo "Name Is Incorrect Please Try Again"
fi
;;

         #This Is The Second Option [ 2-ListDB ]      

"ListDB")
if [[ -z ~/myDatabase ]]
then
    echo "There Is No Data_Bases In This Directory"
else
    echo "The Data_Bases That Are Available In This Directory :  "
    ls -F | grep /

fi
;;

         # This Is The Third Option [ 3-DropDB ]

"DropDB")
read -p "Are you sure you want to drop Data base(y/n): " check
if [[ "y" =~ ${check} ]]
then 
    echo "All Data Dases Are : "
    ls -F | grep /
    read -p "Which One You Want To Drop :  " drop_db
    if [[ -d ${drop_db} ]]
    then 
       if [ "$(ls -A ${drop_db})" ]
       then  
          rm -r ${drop_db}
          echo "${drop_db} Has a Contents Is Dropped Sucessfully"
       else
          rmdir ${drop_db}
          echo "${drop_db} Is Dropped Sucessfully"
       fi
    else
       echo "Selected Data Base Is Not Found !!!"
      echo "Please Try Again" 

    fi
else 
    echo "Action Is Canceled"

fi
;;

         # The Fourth Option Is [ 4-Connect_to_DB ]

"Connect_to_DB")
read -p "Please Enter The Data Base Name to Connect to : " conn_db
if [[ -d ${conn_db} ]]
then
    cd ${conn_db}
    echo "Connected Sucessfullly"

         # Choose Option From The  List 

    echo "Choice Option >>> "
    select option2 in create_Table list_tables drop_table select_from_table insert_into_table delet_from_table update_table
    do
    case ${option2} in

         # The First Option Is [ 1-Create Table ]
 
    "create_table")
    read -p "Please Enter Table Name: " table_name
    if [[ -e ${table_name} ]]                                                                          
    then 
        echo "This Table Already Exist"
    elif [[ ${table_name} =~ ^[a-zA-Z][a-zA-Z0-9] ]]                               
    then 
       touch ${table_name}
       touch ${table_name}"metadata"
       echo "${table_name} table Created Successfully"
       echo "${table_name}\"metadata\" Are Created Successfully"
    else
       echo "Not Valid Name, Name Must Begin With Character "            
    fi

        #function of inserting meta_data
                                                                                     
    function insert_metadata(){                                     
    declare -i colum_num
    read -p "Enter The Number Of Expected Colum : " colum_num
    echo ${colum_num} >> ./${table_name}"metadata"
    let y=${colum_num}
    for i in `seq 1 $y `
    do
    read -p "Enter The Name Of The Colum \"$i\": " colum_name
    echo -n ${colum_name} >> ./${table_name}"metadata"
    echo -n ":" >> ./${table_name}"metadata"

    read -p "Enter The Colum Data Type \"$i\": " colum_type
    echo -n ${colum-type} >> ./${table_name}"metadata"
    echo -n ":" >> ./${table_name}"metadata"

    read -p "This Colum \"$i\" Accept Null or Not :  " acc_null
    echo ${acc_null} >> ./${table_name}"metadata"
    done 
    }
    insert_metadata
    ;;

         # The Second Option is [2-List_table]

    "list_tables")
    if [[ -z ~/myDatabase/${conn_db} ]]
    then
       echo "There Is No Table Found"
    else 
       cd  ~/myDatabase/${conn_db}
       echo "The Entire Tables In Choosen Database : "
       ls -F | grep -v /
    fi
    ;;

         # The Third Option is [3-Drop_table]
 
    drop_table) 
    if [[ -z ${conn_db} ]]
    then 
       echo "Empty Directory"
    else
       read -p "Enter The Table You Want To Drop : " drop_table
       if [[ -f ~/myDatabase/${conn_db}/${drop_table} ]]
       then 
          rm '~/myDatabase/${conn_db}/${drop_table}' '~/myDatabase/${conn_db}/${drop_table}"metadata"'
          echo "The Table Is Deleted sucessfully"
       else
          echo "File Not_Found !! "
       fi
    fi
    ;;

        # The Fourth Option is [4-Update_table]

    "update_table")
     read -p  "Enter Table Name: " table_name
     if ! [ -f $table_name ]
     then
        echo "Table Not_Found !! "
     else                                
        read -p "Enter Col Name: " col_name
        testcol=$(awk '{if(NR==2){for(i=1;i<=NF;i++){if($i=="'$col_name'")print i+1}}}' ~/myDatabase/${conn_db}/${table_name})
        if [[ $testcol == "" ]]
        then
           echo "Column Not_Found !! "
        else
           read -p "Enter PK " pk
           checkpk=$(awk '{if($1=='$pk') print NR }' ~/myDatabase/${conn_db}/${table_name})
           if [[ ${checkpk} == "" ]]
           then
               echo "This PK Is Not_Found !! "
            else
               read -p "Enter New_value :  " newvalue
               prevvalue=$(awk  '{if(NR=='$checkpk') print $'$testcol'}' ~/myDatabase/${conn_db}/${table_name} )
               sed -i "${checkpk}s/$prevvalue/$newvalue/" ~/myDatabase/${conn_db}/${table_name}
           fi                                                      	
        fi
      fi
      ;;

         # The Fifth Option is [-5 Select_From_Table]

      "select_from_table")   
      select option3 in  select_all select_col select_row
      do
      case $option3  in

         # Select_All Column Option         

      "select_all") 
      read -p  "Enter Table Name : " table_name
      if ! [ -f $table_name ]
      then
        echo "Table Not_found"
        exit;
      else
          cat $table_name
      fi
      exit;
      ;;

         #Select Specific Column
     
     "select_col") 	 
     read -p  "Enter Table Name: " table_name
     if ! [ -f $table_name ]
     then
        echo "Table Not_Found"
     exit;
     else                                
        read -p "Enter Col Name :  " col_name
        typeset -i testcol
        testcol=$(awk '{if(NR==2){for(i=1;i<=NF;i++){if($i=="'$col_name'")print i+1}}}' ~/myDatabase/${conn_db}/${table_name})
           if [[ $testcol == "" ]]
           then
              echo "Column Not_Found"
           else
              cat $table_name | cut -d ' ' -f $testcol
           fi
           exit;
       fi
       exit 
       ;;

         # Select Specific Row
    
     "select row") 
     read -p  "Enter Table Name: " table_name
     if ! [ -f $table_name ]
     then
        echo "Table Not_Found"
     exit;
     else                                
        read -p "Enter PK" pk
        checkpk=$(awk '{if($1=='$pk') print NR }' ./$table_name )
        echo "$checkpk"
        sed -n "${checkpk}p" ./$table_name
    fi
    exit;
    ;;
      
     *) echo "wrong choice"
     exit;
     ;;

         # The Option number 6 [-6 Insert_Into_Table ]
 
     "insert_into_table")
     read -p "Please Enter the Table Name: " table_name

     typeset -i fields
     fields="$(head -1 ~/myDatabase/${conn_db}/${table_name} | cut -d ' ' -f 1 )"
     let y=$fields-1
     read -p "Insert The Value Of The PK " pk
     present="$(cut -d ' ' -f 1 ~/myDatabase/${conn_db}/${table_name} | grep "$pk" )"
     if [ ${present} == 0 ]
     then
       if [[ $pk =~ ^[0-9]*[0-9] ]]
       then
         echo -n "$pk" >> ~/myDatabase/${conn_db}/${table_name}
         echo -n " " >> ~/myDatabase/${conn_db}/${table_name}

      else 
         echo "Invalid PK"
         exit
      fi
    else 
     echo "Primary Key Already Exist"
     exit
  fi

    for i in $(seq 1 $y)
    do
      read -p "Insert The Next Field " input
      dtype="$(head -3 ~/myDatabase/${conn_db}/${table_name} | cut -d ' ' -f $i | tail -1)"

      if [[ ( $dtype == "int" && $input =~ ^[0-9]*[0-9] )  || $dtype == "string" ]]
      then
         echo -n "$input" >> ~/myDatabase/${conn_db}/${table_name}
         echo -n " " >> ~/myDatabase/${conn_db}/${table_name}
      else 
         echo "Datatype Is Incorrect"
         exit
      fi 
    done

   echo  " " >> ~/myDatabase/${conn_db}/${table_name}

      esac
      done

    esac
    done
fi
;;
esac
done

