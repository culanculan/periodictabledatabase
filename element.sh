#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -X -t --no-align"

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

INPUT=$(printf '%s' "$1" | sed "s/'/''/g")
ELEMENT=$($PSQL -c "SELECT e.atomic_number || '|' || e.name || '|' || e.symbol || '|' || t.type || '|' || p.atomic_mass || '|' || p.melting_point_celsius || '|' || p.boiling_point_celsius FROM elements e JOIN properties p USING (atomic_number) JOIN types t USING (type_id) WHERE e.atomic_number::text = COALESCE(NULLIF(ltrim('$INPUT', '0'), ''), '0') OR e.symbol = '$INPUT' OR e.name = '$INPUT' LIMIT 1")

if [[ -z "$ELEMENT" ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$ELEMENT"
printf "The element with atomic number %s is %s (%s). It's a %s, with a mass of %s amu. %s has a melting point of %s celsius and a boiling point of %s celsius.\n" \
  "$atomic_number" "$name" "$symbol" "$type" "$atomic_mass" "$name" "$melting_point" "$boiling_point"