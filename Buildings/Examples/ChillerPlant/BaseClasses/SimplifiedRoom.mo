within Buildings.Examples.ChillerPlant.BaseClasses;
model SimplifiedRoom "Simplified data center room"
  extends Buildings.BaseClasses.BaseIconLow;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  parameter Integer nPorts=0 "Number of parts" annotation (Evaluate=true,
      Dialog(
      __Dymola_connectorSizing=true,
      tab="General",
      group="Ports"));
  parameter Modelica.SIunits.Length rooLen "Length of the room";
  parameter Modelica.SIunits.Length rooWid "Width of the room";
  parameter Modelica.SIunits.Height rooHei "Height of the room";
  parameter Modelica.SIunits.Power QRoo_flow
    "Heat generation of the computer room";

  Buildings.Fluid.MixingVolumes.MixingVolume rooVol(
    nPorts=nPorts,
    redeclare each package Medium = Medium,
    V=rooLen*rooWid*rooHei,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final T_start=293.15) "Volume of air in the room" annotation (Placement(
        transformation(extent={{41,-20},{61,-40}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b airPorts[nPorts](
      redeclare each package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(
        extent={{-37,-14},{37,14}},
        rotation=90,
        origin={101,10}), iconTransformation(
        extent={{-37,-14},{37,14}},
        rotation=180,
        origin={0,100})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QSou
    "Heat source of the room"
    annotation (Placement(transformation(extent={{-18,-40},{2,-20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=QRoo_flow,
    offset=0,
    duration=36000,
    startTime=0)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
equation
  connect(rooVol.ports, airPorts) annotation (Line(
      points={{51,-20},{52,-20},{52,10},{52,10},{52,10},{101,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(QSou.port, rooVol.heatPort) annotation (Line(
      points={{2,-30},{41,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ramp.y, QSou.Q_flow) annotation (Line(
      points={{-39,-30},{-18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=1)}),
    Documentation(info="<html>
<p>
This is a simplified room model for a data center. There is no heat exchange between the room and ambient environment through the building envelope since it is negligible compared to the heat released by the servers.
</p></html>", revisions="<html>
<ul>
<li>
July 21, 2011 by Wangda Zuo:<br/>
Merge to library.
</li>
<li>
December 10, 2010 by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimplifiedRoom;
