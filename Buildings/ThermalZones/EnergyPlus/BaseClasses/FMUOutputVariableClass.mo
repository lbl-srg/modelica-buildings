within Buildings.ThermalZones.EnergyPlus.BaseClasses;
class FMUOutputVariableClass
  "Class used to couple the FMU to retrieve output variables"
  extends ExternalObject;
  function constructor
    "Construct to connect to an output variable in EnergyPlus"
    extends Modelica.Icons.Function;
    input String modelicaNameBuilding
      "Name of this Modelica building instance that requests this output variable";
    input String modelicaNameOutputVariable
      "Name of the Modelica instance that requests this output variable";
    input String idfName
      "Name of the IDF";
    input String weaName
      "Name of the weather file";
    input String name
      "EnergyPlus name of the output variable as in the EnergyPlus .rdd or .mdd file";
    input String componentKey
      "EnergyPlus key of the output variable";
    input Boolean usePrecompiledFMU
      "Set to true to use precompiled FMU with name specified by input fmuName";
    input String fmuName
      "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)";
    input String buildingsLibraryRoot
      "Root directory of the Buildings library (used to find the spawn executable)";
    input Buildings.ThermalZones.EnergyPlus.Types.LogLevels logLevel
      "LogLevels of EnergyPlus output";
    input Boolean printUnit
      "Set to true to print unit of OutputVariable objects to log file";
    output FMUOutputVariableClass adapter;
  external "C" adapter=SpawnOutputVariableAllocate(
    modelicaNameBuilding,
    modelicaNameOutputVariable,
    idfName,
    weaName,
    name,
    componentKey,
    usePrecompiledFMU,
    fmuName,
    buildingsLibraryRoot,
    logLevel,
    printUnit)
    annotation (
      Include="#include <EnergyPlusWrapper.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Library={"ModelicaBuildingsEnergyPlus","fmilib_shared"});
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
October 7, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end constructor;
  function destructor
    "Release storage"
    extends Modelica.Icons.Function;
    input FMUOutputVariableClass adapter;
  external "C" EnergyPlusOutputVariableFree(
    adapter)
    annotation (Library={"ModelicaBuildingsEnergyPlus","fmilib_shared"});
    // dl provides dlsym to load EnergyPlus dll, which is needed by OpenModelica compiler
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
October 7, 2019, by Michael Wetter:<br/>
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
October 7, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FMUOutputVariableClass;
