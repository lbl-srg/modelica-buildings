within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Subsequences.BaseTemperatureSetpointElements.Subsequences.Validation;
model ModeSelection
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Subsequences.BaseTemperatureSetpointElements.Subsequences.ModeSelection
    modeSelection
    annotation (Placement(transformation(extent={{34,14},{58,38}})));
  CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,0; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-82,54},{-62,74}})));
  CDL.Reals.Sources.Sin sin(
    final freqHz=1/86400,
    final amplitude=1,
    phase=3.1415926535898,
    final offset=273.15 + 20)
    annotation (Placement(transformation(extent={{-56,-4},{-36,16}})));
  CDL.Reals.Sources.Sin sin1(
    final freqHz=1/43200,
    final amplitude=10,
    phase=1.5707963267949,
    final offset=273.15 + 25)
    annotation (Placement(transformation(extent={{-56,-44},{-36,-24}})));
  CDL.Reals.Sources.Sin sin2(
    final freqHz=1/21600,
    final amplitude=2,
    phase=0,
    final offset=273.15 + 15)
    annotation (Placement(transformation(extent={{-54,-88},{-34,-68}})));
  CDL.Reals.Sources.Sin sin3(
    final freqHz=1/21600,
    final amplitude=2,
    phase=0,
    final offset=273.15 + 15)
    annotation (Placement(transformation(extent={{-90,18},{-70,38}})));
equation
  connect(intTimTab.y[1], modeSelection.uMod) annotation (Line(points={{-60,64},
          {-38,64},{-38,34.8},{31.913,34.8}}, color={255,127,0}));
  connect(sin.y, modeSelection.uNom) annotation (Line(points={{-34,6},{-4,6},{
          -4,26.8},{31.913,26.8}}, color={0,0,127}));
  connect(sin1.y, modeSelection.uShe) annotation (Line(points={{-34,-34},{-2,
          -34},{-2,22.8},{31.913,22.8}}, color={0,0,127}));
  connect(sin2.y, modeSelection.uReb) annotation (Line(points={{-32,-78},{-2,
          -78},{-2,18.2},{31.913,18.2}}, color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end ModeSelection;
