within Buildings.Fluid.Geothermal.Boreholes.BaseClasses.Examples;
model SingleUTubeResistances "Model that tests the resistances in the borehole"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water "Medium in the pipes";

  replaceable parameter Buildings.HeatTransfer.Data.Soil.Granite matSoi
    "Thermal properties of soil"
    annotation (choicesAllMatching=true, Dialog(group="Soil"),
    Placement(transformation(extent={{2,70},{22,90}})));

  replaceable parameter Buildings.HeatTransfer.Data.BoreholeFillings.Bentonite matFil
    "Thermal properties of the filling material"
    annotation (choicesAllMatching=true, Dialog(group="Filling material"),
    Placement(transformation(extent={{-68,70},{-48,90}})));

  parameter Modelica.Units.SI.Height hSeg=1 "Height of the element";
  parameter Modelica.Units.SI.Radius rBor=0.2 "Radius of the borehole";
  parameter Modelica.Units.SI.Radius rTub=0.02 "Radius of the tubes"
    annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.ThermalConductivity kTub=0.5
    "Thermal conductivity of the tube" annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Length eTub=0.002 "Thickness of a tube"
    annotation (Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Length xC=0.05
    "Shank spacing, defined as the distance between the center of a pipe and the center of the borehole"
    annotation (Dialog(group="Borehole"));

  parameter Modelica.Units.SI.ThermalResistance Rgb(fixed=false)
    "Thermal resistance between grout zone and borehole wall";
  parameter Modelica.Units.SI.ThermalResistance Rgg(fixed=false)
    "Thermal resistance between the two grout zones";
  parameter Modelica.Units.SI.ThermalResistance RCondGro(fixed=false)
    "Thermal resistance of the pipe wall";
  parameter Real x(fixed=false) "Capacity location";

initial equation
  (Rgb, Rgg, RCondGro, x) =
    Buildings.Fluid.Geothermal.Boreholes.BaseClasses.singleUTubeResistances(
    hSeg=hSeg,
    rBor=rBor,
    rTub=rTub,
    eTub=eTub,
    xC=xC,
    kSoi=matSoi.k,
    kFil=matFil.k,
    kTub=kTub);

 annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Boreholes/BaseClasses/Examples/SingleUTubeResistances.mos"
        "Simulate and plot"),
                  Documentation(info="<html>
<p>
This example tests the thermal resistances in the borehole.
</p>
</html>", revisions="<html>
<ul>
<li>
February 14, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleUTubeResistances;
