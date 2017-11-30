echo "Checking for SpringBoot archive..."
old_dir=`pwd`
cd /deployments
nr_jars=`ls *.jar 2>/dev/null | grep -v '^original-' | wc -l | tr -d '[[:space:]]'`
if [ ${nr_jars} = 1 ]; then
  single_jar=`ls *.jar | grep -v '^original-'`
  echo "Found ${single_jar}..."
  nr_devtools=`unzip -l "${single_jar}" 2>/dev/null | grep -e 'spring-boot-devtools-.*\.jar' | wc -l | tr -d '[[:space:]]'`
  if [ ${nr_devtools} = 1 ]; then
    main_class=`unzip -p "${single_jar}" META-INF/MANIFEST.MF | sed -n 's/Main-Class: \(.*\)$/\1/p' | tr -d '[[:space:]]'`
    echo "Found main class ${main_class}"
    if [[ "${main_class}" =~ org.springframework.boot.loader. ]]; then
      # explosion!!!
      echo "SpringBoot executable jar detected, exploding..."
      unzip "${single_jar}"
      # remove fat jar, run script will setup main class, etc. for run-java.sh
      rm -v "${single_jar}"
    fi
  fi
fi
cd "${old_dir}"
