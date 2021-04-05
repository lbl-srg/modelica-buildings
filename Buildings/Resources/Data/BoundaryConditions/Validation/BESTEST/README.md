This folder contains scripts that are used for the weather BESTEST.

- The `WeatherDriversTestSpec_1.pdf` and `WeatherDriversTestSpec_2.pdf`
  are the two specification files from the BESTEST.

- The `.epw` and `.mos` files are the weather case studies described in
  the `.pdf` documentation.

- The `WeatherDriversResultsSubmittal1.json`and `WeatherDriversResultsSubmittal2.json`
  are the result template formats provided by the BESTEST and used
  by the script `generateResults.py` to generate the final `.json` results.

- The `generateResults.py` is the main script to run the BESTEST testcases.
  Several options are available when calling the script:
  
  `-v`, Make code verbose
  
  `-c`, Specify to enable ci-testing (will delete output files not stored 
         in version control)
  
  `-g`, Specify to get the results from the github branch instead of local.
  
  `-p`, Specify to pretty print json output.
  
  `-t`, Specify `.json` result type `-t` for `.jsonFormat2` no `-t` for `.jsonFormat1`

- The main results will be saved in the folder `results/JsonResults` and four files are 
  available:
  
  - `WeatherIsoHHorIR.json`: Diffuse radiation calculated with isotropic method and
    `TBlaSky` calculated with horizontal irradiation.
  - `WeatherIsoTDryBulTDewPoinOpa.json`: Diffuse radiation calculated with isotropic
    method and `TBlaSky` calculated using `TDewPoi` and `nOpa`.
  - `WeatherPerHHorIR.json: Diffuse radiation calculated using Perez Model and 
    `TBlaSky` calculated with horizontal irradiation.
  - `WeatherPerTDryBulTDewPoinOpa.json`: Diffuse radiation calculated with Perez
    model and `TBlaSky` using `TDewPoi` and `nOpa`.

- The raw results together with the simulation log will be stored in `results/WD***`
  according to the case study.

