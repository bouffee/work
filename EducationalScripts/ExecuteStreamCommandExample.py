"""In this code you read data from csv-file that is declared in command line as a second argument. Result of a code is coverted json file. """
import csv
import json
import sys

if len(sys.argv) < 2:
    print("Usage: python csv_to_json.py <inputCsvFile>")
    sys.exit(1)

inputCsvFile = sys.argv[1]
outputJsonFile = inputCsvFile.replace(".csv", ".json")

data = []

try:
    with open(inputCsvFile, "r") as csvfile:
        reader = csv.DictReader(csvfile, delimiter=";")
        for row in reader:
            data.append(row)

    with open(outputJsonFile, "w") as jsonfile:
        json.dump(data, jsonfile, indent=4)
except FileNotFoundError:
    print("File is not found!")
else:
    print("Transformation passed successfully!")
