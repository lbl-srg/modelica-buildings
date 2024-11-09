within Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.SurfaceComparison.BaseClasses;
model ExteriorWall "Model of an exterior wall with Spawn-controlled surface conditions"
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConstruction;

  parameter String surNam "Name of EnergyPlus Surface";

  parameter Modelica.Units.SI.Area A "Wall area";

  replaceable parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    layers "Construction definition from Data.OpaqueConstructions"
  annotation (choicesAllMatching=true, Placement(transformation(extent={{60,60},
          {80,80}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.ZoneSurface sur(surfaceName=surNam)
    "Wall interior surface"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  HeatTransfer.Conduction.MultiLayer walCon(
    A=A,
    layers=layers) "Wall construction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,0})));
  HeatTransfer.Sources.PrescribedHeatFlow heaSurExt
    "Exterior surface heat transfer rate"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,30})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSurInt
    "Interior surface temperature"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,-30})));
  HeatTransfer.Sources.PrescribedHeatFlow heaSurInt
   "Prescribed heat flow rate"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-30})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OutputVariable extSurHea(
    name="Surface Outside Face Conduction Heat Transfer Rate",
    key=surNam)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Math.Gain inv(k=-1) "Invert the sign of the heat flow signal"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
equation
  connect(heaSurExt.port, walCon.port_a)
    annotation (Line(points={{40,20},{40,10},{0,10}}, color={191,0,0}));
  connect(sur.Q_flow, heaSurInt.Q_flow)
    annotation (Line(points={{12,-44},{40,-44},{40,-40}}, color={0,0,127}));
  connect(heaSurInt.port, walCon.port_b)
    annotation (Line(points={{40,-20},{40,-10},{0,-10}}, color={191,0,0}));
  connect(TSurInt.port, walCon.port_b)
    annotation (Line(points={{-40,-20},{-40,-10},{0,-10}}, color={191,0,0}));
  connect(TSurInt.T, sur.T)
    annotation (Line(points={{-40,-41},{-40,-50},{-12,-50}}, color={0,0,127}));
  connect(extSurHea.y, inv.u)
    annotation (Line(points={{-19,50},{-2,50}}, color={0,0,127}));
  connect(inv.y, heaSurExt.Q_flow)
    annotation (Line(points={{21,50},{40,50},{40,40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Bitmap(
          extent={{58,-98},{98,-68}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus/EnergyPlusLogo.png"),
        Rectangle(
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          extent={{-78,-64},{70,68}}),
        Rectangle(
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          extent={{56,-50},{-62,56}}),
        Rectangle(
          extent={{-78,68},{70,56}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
July 21, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>
This is a model of the heat transfer through an exterior wall, which is connected
to an EnergyPlus Zone Heat Balance through 
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.ZoneSurface\">
Buildings.ThermalZones.EnergyPlus_9_6_0.ZoneSurface</a> object on the interior surface and a 
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.OutputVariable\">
Buildings.ThermalZones.EnergyPlus_9_6_0.OutputVariable</a> to read the exterior surface temperature.
</p>
<p>
This model can be used in a Spawn simulation to substitute the heat conduction 
calculation performed by EnergyPlus with a
<a href=\"modelica://Buildings.HeatTransfer.Conduction.MultiLayer\">
Buildings.HeatTransfer.Conduction.MultiLayer</a> object.
</p>
</html>"));
end ExteriorWall;
