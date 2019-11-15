within Buildings.Experimental.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.BaseClasses;
partial model PartialFloor "Interface for a model of a floor of a building"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);

  parameter Boolean use_windPressure=true
    "Set to true to enable wind pressure";

  parameter Modelica.SIunits.Volume VRooCor "Room volume corridor";
  parameter Modelica.SIunits.Volume VRooSou "Room volume south";
  parameter Modelica.SIunits.Volume VRooNor "Room volume north";
  parameter Modelica.SIunits.Volume VRooEas "Room volume east";
  parameter Modelica.SIunits.Volume VRooWes "Room volume west";

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsSou[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,-44},{110,-28}}),
        iconTransformation(extent={{-20,-80},{20,-64}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsEas[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{310,28},{350,44}}),
        iconTransformation(extent={{50,-8},{90,8}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsNor[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,116},{110,132}}),
        iconTransformation(extent={{-20,60},{20,76}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsWes[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-50,36},{-10,52}}),
        iconTransformation(extent={{-88,-8},{-48,8}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsCor[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,38},{110,54}}),
        iconTransformation(extent={{-20,-8},{20,8}})));

  Modelica.Blocks.Interfaces.RealOutput TRooAir[5](
    each unit="K",
    each displayUnit="degC") "Room air temperatures"
    annotation (Placement(transformation(extent={{380,150},{400,170}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput p_rel
    "Relative pressure signal of building static pressure" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-170,220}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,0})));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},
            {400,500}}, initialScale=0.1)),
    Documentation(info="<html>
<p>
This is a partial floor model used to constrain the replaceable thermal zone classes and
ensure those are plug compatible.
fixme: this model should live somewhere else as the ThermalZone.Floor also extends it
</p>
</html>",
revisions="<html>
<ul>
<li>
November 14, 2019, by Milica Grahovac:<br/>
Extracted interfaces and common parameters found in thermal zone models.
</li>
</ul>
</html>"),
    Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={95,95,95},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}));
end PartialFloor;
