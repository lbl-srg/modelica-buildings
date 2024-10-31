within Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses;
class SpawnExternalObject
  "Class used to couple the FMU to interact with a thermal zone"
  extends ExternalObject;
  impure function constructor
    "Construct to connect to a thermal zone in EnergyPlus"
    extends Modelica.Icons.Function;
    input Integer objectType
      "Type of the object (1: ThermalZone, 2: Schedule, 3: Actuator, 4: Surface)";
    input Modelica.Units.SI.Time startTime "Start time of the simulation";
    input String modelicaNameBuilding
      "Name of this Modelica building instance that connects to this thermal zone";
    input String modelicaInstanceName
      "Name of the Modelica instance of this object";
    input String spawnExe
      "Name of the spawn executable, without extension, such as spawn-0.2.0-d7f1e095f3";
    input String idfVersion
      "IDF version with underscores, such as 9_6_0";
    input String idfName
      "Name of the IDF";
    input String epwName
      "Name of the weather file";
    input Buildings.ThermalZones.EnergyPlus_9_6_0.Data.RunPeriod runPeriod
      "EnergyPlus RunPeriod configuration";
    input Real relativeSurfaceTolerance
      "Relative tolerance of surface temperature calculations";
    input String epName
      "Name of the object in EnergyPlus";
    input Boolean usePrecompiledFMU
      "Set to true to use precompiled FMU with name specified by input fmuName";
    input String fmuName
      "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)";
    input String buildingsRootFileLocation
      "Name of top-level legal.html file of the Buildings library (used to find the spawn executable)";
    input Buildings.ThermalZones.EnergyPlus_9_6_0.Types.LogLevels logLevel
      "LogLevels of EnergyPlus output";
    input Boolean printUnit
      "Set to true to print units for OutputVariable object. Must be false for all other objects";
    input String jsonName
      "Name of the object in the json configuration file";
    input String jsonKeysValues
      "Keys and values string to be written to the json configuration file";
    input String parOutNames[nParOut]
      "Names of parameter in modelDescription.xml file";
    input String parOutUnits[nParOut]
      "Modelica units of the parameters";
    input Integer nParOut
      "Number of parameters";
    input String inpNames[nInp]
      "Names of inputs in modelDescription.xml file";
    input String inpUnits[nInp]
      "Modelica units of the inputs";
    input Integer nInp
      "Size of inpNames";
    input String outNames[nOut]
      "Names of outputs in modelDescription.xml file";
    input String outUnits[nOut]
      "Modelica units of the outputs";
    input Integer nOut
      "Size of outNames";
    input Integer derivatives_structure[nDer,2]
      "List of derivatives (1-based index, [i,j] means dy_i/du_j";
    input Integer nDer
      "Size of derivatives";
    input Real derivatives_delta[nDer]
      "Increments for derivative calculation";
    output SpawnExternalObject adapter;
  external "C" adapter=allocate_Modelica_EnergyPlus_9_6_0(
    objectType,
    startTime,
    modelicaNameBuilding,
    modelicaInstanceName,
    spawnExe,
    idfVersion,
    idfName,
    epwName,
    runPeriod.startDayOfYear,
    runPeriod.applyWeekEndHolidayRule,
    runPeriod.use_weatherFileDaylightSavingPeriod,
    runPeriod.use_weatherFileHolidaysAndSpecialDays,
    runPeriod.use_weatherFileRainIndicators,
    runPeriod.use_weatherFileSnowIndicators,
    relativeSurfaceTolerance,
    epName,
    usePrecompiledFMU,
    fmuName,
    buildingsRootFileLocation,
    logLevel,
    printUnit,
    jsonName,
    jsonKeysValues,
    parOutNames,
    nParOut,
    parOutUnits,
    nParOut,
    inpNames,
    nInp,
    inpUnits,
    nInp,
    outNames,
    nOut,
    outUnits,
    nOut,
    derivatives_structure,
    2,
    nDer,
    derivatives_delta,
    nDer)
    annotation (
      Include="#include <EnergyPlus_9_6_0_Wrapper.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Library={"ModelicaBuildingsEnergyPlus_9_6_0","fmilib_shared"});
    annotation (
      Documentation(
        info="<html>
  <p>
  The function <code>constructor</code> is a C function that is called by a Modelica simulator
  exactly once during the initialization.
  The function returns the object <code>adapter</code> that
  will be used to store the data structure needed to communicate with EnergyPlus.
  </p>
  </html>",
        revisions="<html>
  <ul>
  <li>
  April 21, 2022, by Michael Wetter:<br/>
  Added support for EnergyPlus <code>RunPeriod</code> object.<br/>
  This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2926\">#2926</a>.
  </li>
  <li>
  December 11, 2021, by Michael Wetter:<br/>
  Declared function as <code>impure</code> for MSL 4.0.0.
  </li>
  <li>
  February 18, 2021, by Michael Wetter:<br/>
  Refactor synchronization of constructors.<br/>
  This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2360\">#2360</a>.
  </li>
  <li>
  February 14, 2018, by Michael Wetter:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
  end constructor;

  pure function destructor
    "Release storage"
    extends Modelica.Icons.Function;
    input SpawnExternalObject adapter;
  external "C" free_Modelica_EnergyPlus_9_6_0(adapter)
    annotation (
      Include="#include <EnergyPlus_9_6_0_Wrapper.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Library={"ModelicaBuildingsEnergyPlus_9_6_0","fmilib_shared"});
    annotation (
      Documentation(
        info="<html>
<p>
Destructor that frees the memory of the object.
</p>
</html>",
        revisions="<html>
<ul>
<li>
February 18, 2021, by Michael Wetter:<br/>
Refactor synchronization of constructors.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2360\">#2360</a>.
</li>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end destructor;
  annotation (
    Documentation(
      info="<html>
<p>
Class derived from <code>ExternalObject</code> having two local external function definition,
named <code>destructor</code> and <code>constructor</code> respectively.
<p>
These functions create and release an external object that allows the storage
of the data structure needed to communicate with the EnergyPlus FMU.

</html>",
      revisions="<html>
<ul>
<li>
December 11, 2021, by Michael Wetter:<br/>
Declared function as <code>pure</code> for MSL 4.0.0.
</li>
<li>
February 18, 2021, by Michael Wetter:<br/>
Refactor synchronization of constructors.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2360\">#2360</a>.
</li>
<li>
April 04, 2018, by Thierry S. Nouidui:<br/>
Added additional parameters for parametrizing
the EnergyPlus model.
</li>
<li>
March 21, 2018, by Thierry S. Nouidui:<br/>
Revised implementation for efficiency.
</li>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpawnExternalObject;
