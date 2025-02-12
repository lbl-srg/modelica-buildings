within Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.SurfaceComparison.BaseClasses;
model InteriorWall "Model of an interior wall with Spawn-controlled surface conditions"
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConstruction;

  parameter String surNam_a "Name of EnergyPlus Surface (port a)";
  parameter String surNam_b "Name of EnergyPlus Surface (port b)";

  parameter Modelica.Units.SI.Area A "Wall area";

  replaceable parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    layers "Construction definition from Data.OpaqueConstructions"
  annotation (choicesAllMatching=true, Placement(transformation(extent={{60,60},
          {80,80}})));

  Buildings.ThermalZones.EnergyPlus_24_2_0.ZoneSurface sur_a(surfaceName=surNam_a)
    "Wall surface (port a)"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.ThermalZones.EnergyPlus_24_2_0.ZoneSurface sur_b(surfaceName=surNam_b)
    "Wall surface (port b)"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Buildings.HeatTransfer.Conduction.MultiLayer walCon(
    A=A,
    layers=layers) "Wall conduction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,0})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSur_a
    "Surface temperature (port a)"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,30})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaSur_a
    "Surface heat transfer rate (port a)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,30})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSur_b
    "Surface temperature (port b)"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,-30})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaSur_b
    "Surface heat transfer rate (port b)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-30})));
equation
  connect(walCon.port_a, TSur_a.port)
    annotation (Line(points={{0,10},{-40,10},{-40,20}}, color={191,0,0}));
  connect(TSur_a.T, sur_a.T)
    annotation (Line(points={{-40,41},{-40,50},{-12,50}}, color={0,0,127}));
  connect(sur_a.Q_flow, heaSur_a.Q_flow)
    annotation (Line(points={{12,56},{40,56},{40,40}}, color={0,0,127}));
  connect(heaSur_a.port, walCon.port_a)
    annotation (Line(points={{40,20},{40,10},{0,10}}, color={191,0,0}));
  connect(sur_b.Q_flow, heaSur_b.Q_flow)
    annotation (Line(points={{12,-44},{40,-44},{40,-40}}, color={0,0,127}));
  connect(heaSur_b.port, walCon.port_b)
    annotation (Line(points={{40,-20},{40,-10},{0,-10}}, color={191,0,0}));
  connect(TSur_b.port, walCon.port_b)
    annotation (Line(points={{-40,-20},{-40,-10},{0,-10}}, color={191,0,0}));
  connect(TSur_b.T, sur_b.T)
    annotation (Line(points={{-40,-41},{-40,-50},{-12,-50}}, color={0,0,127}));
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
          extent={{-78,-64},{78,66}}),
        Rectangle(
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          extent={{70,-56},{-70,60}}),
        Rectangle(
          extent={{-4,60},{4,-56}},
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
</html>", info="<html>
<p>
This is a model of the heat transfer through an interior wall, which is connected
to an EnergyPlus Zone Heat Balance through
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.ZoneSurface\">
Buildings.ThermalZones.EnergyPlus_24_2_0.ZoneSurface</a> objects on both side of
the wall.
</p>
<p>
This model can be used in a Spawn simulation to substitute the heat conduction
calculation performed by EnergyPlus with a
<a href=\"modelica://Buildings.HeatTransfer.Conduction.MultiLayer\">
Buildings.HeatTransfer.Conduction.MultiLayer</a> object.
</p>
</html>"));
end InteriorWall;
