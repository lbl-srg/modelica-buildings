within Buildings.ThermalZones.EnergyPlus.BaseClasses;
class FMUInputVariableClass
  "Class used to couple the FMU to send values to actuators and schedules"
  extends ExternalObject;
  function constructor
    "Construct to connect to a schedule in EnergyPlus"
    extends Modelica.Icons.Function;
    input Integer objectType
      "Set to 1 for Actuator and 2 for Schedule";
    input String modelicaNameBuilding
      "Name of this Modelica building instance that requests this output variable";
    input String modelicaNameInputVariable
      "Name of the Modelica instance that requests this output variable";
    input String idfName
      "Name of the IDF";
    input String weaName
      "Name of the weather file";
    input String name
      "EnergyPlus name of the actuator or schedule";
    input String componentType
      "Actuated component type (not used for schedule)";
    input String controlType
      "Actuated component control type (not used for schedule)";
    input String unit
      "Unit of the input in Modelica";
    input Boolean usePrecompiledFMU
      "Set to true to use precompiled FMU with name specified by input fmuName";
    input String fmuName
      "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)";
    input String buildingsLibraryRoot
      "Root directory of the Buildings library (used to find the spawn executable)";
    input Buildings.ThermalZones.EnergyPlus.Types.LogLevels logLevel
      "LogLevels of EnergyPlus output"
      annotation (Dialog(tab="Debug"));
    output FMUInputVariableClass adapter;
  external "C" adapter=SpawnInputVariableAllocate(
    objectType,
    modelicaNameBuilding,
    modelicaNameInputVariable,
    idfName,
    weaName,
    name,
    componentType,
    controlType,
    unit,
    usePrecompiledFMU,
    fmuName,
    buildingsLibraryRoot,
    logLevel)
    annotation (
      Include="#include <EnergyPlusWrapper.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources",
      Library={"ModelicaBuildingsEnergyPlus", "fmilib_shared"});
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
November 13, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end constructor;
  function destructor
    "Release storage"
    extends Modelica.Icons.Function;
    input FMUInputVariableClass adapter;
  external "C" EnergyPlusInputVariableFree(
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
November 13, 2019, by Michael Wetter:<br/>
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
November 13, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FMUInputVariableClass;
