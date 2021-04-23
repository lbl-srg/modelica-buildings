within Buildings.ThermalZones.EnergyPlus.BaseClasses;
partial block PartialEnergyPlusObject
  "Partial definitions of an EnergyPlus object"
  extends Modelica.Blocks.Icons.Block;
  outer Buildings.ThermalZones.EnergyPlus.Building building
    "Building-level declarations";

protected
  constant String modelicaNameBuilding=building.modelicaNameBuilding
    "Name of the building to which this output variable belongs to"
    annotation (HideResult=true);
  constant String modelicaInstanceName=getInstanceName()
    "Name of this instance"
    annotation (HideResult=true);
  final parameter String idfName=building.idfName
    "Name of the IDF file that contains this zone";
  final parameter String weaName=building.weaName
    "Name of the EnergyPlus weather file (but with mos extension)";
  final parameter Real relativeSurfaceTolerance=building.relativeSurfaceTolerance
    "Relative tolerance of surface temperature calculations";
  final parameter Boolean usePrecompiledFMU=building.usePrecompiledFMU
    "Set to true to use pre-compiled FMU with name specified by fmuName"
    annotation (Dialog(tab="Debug"));
  final parameter String fmuName=building.fmuName
    "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)"
    annotation (Dialog(tab="Debug"));
  final parameter Buildings.ThermalZones.EnergyPlus.Types.LogLevels logLevel=building.logLevel
    "LogLevels of EnergyPlus output"
    annotation (Dialog(tab="Debug"));
  parameter Modelica.SIunits.Time startTime(
    fixed=false)
    "Simulation start time";
  function round
    input Real u;
    input Real accuracy;
    output Real y;

  algorithm
    y :=
      if
        (u > 0) then
        floor(
          u/accuracy+0.5)*accuracy
      else
        ceil(
          u/accuracy-0.5)*accuracy;
  end round;

initial equation
  startTime=time;
  annotation (
    Icon(
      graphics={
        Bitmap(
          extent={{58,-98},{98,-68}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/EnergyPlusLogo.png",
          visible=not usePrecompiledFMU)}),
    Documentation(
      info="<html>
<p>
Partial model for an EnergyPlus object.
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
April 04, 2018, by Thierry S. Nouidui:<br/>
Added additional parameters for parametrizing
the EnergyPlus model.
</li>
<li>
March 21, 2018, by Thierry S. Nouidui:<br/>
Revised implementation for efficiency.
</li>
<li>
November 8, 2019, by Michael Wetter:<br/>
First implementation..
</li>
</ul>
</html>"));
end PartialEnergyPlusObject;
