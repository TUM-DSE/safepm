set -e

sed -i 's|/dev/shm/vmem_dummy.pool|/mnt/ripe/dummy_pool|' ./source/attack_gen.c

declare -a variants=( "asan" "safepm" "memcheck" )

for variant in "${variants[@]}"
do
  docker build -t ripe64-$variant -f=Dockerfile_$variant .
done

mkdir -p results

for variant in "${variants[@]}"
do
  echo
  echo
  echo "--------------------------"
  echo "|Running variant $variant|"
  echo "--------------------------"
  echo
  echo

  if [ "$variant" = "memcheck" ]
  then
    # We trick valgrind into not producing (large) core dumps by creating a read-only directory and running the tests in that. But for that to work, we must run as a non-root user in the container
    docker run -v "$BENCHMARK_PM_PATH:/mnt/ripe" -v "$(pwd)/results:/results" -it --shm-size=2g --user safepm_user ripe64-$variant ./ripe_tester.py both 3 gcc -o /results/$variant
  else
    docker run -v "$BENCHMARK_PM_PATH:/mnt/ripe" -v "$(pwd)/results:/results" -it --shm-size=2g ripe64-$variant ./ripe_tester.py both 3 gcc -o /results/$variant
  fi
done
