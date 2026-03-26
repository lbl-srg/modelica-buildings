within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model GeneralModeSelection
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.GeneralModeSelection
    generalModeSelection
    annotation (Placement(transformation(extent={{32,0},{56,24}})));
  CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,0; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-84,40},{-64,60}})));
  CDL.Reals.Sources.Sin sin(
    final freqHz=1/86400,
    final amplitude=1,
    phase=3.1415926535898,
    final offset=273.15 + 20)
    annotation (Placement(transformation(extent={{-64,-2},{-44,18}})));
  CDL.Reals.Sources.Sin sin1(
    final freqHz=1/43200,
    final amplitude=10,
    phase=1.5707963267949,
    final offset=273.15 + 25)
    annotation (Placement(transformation(extent={{-60,-44},{-40,-24}})));
  CDL.Reals.Sources.Sin sin2(
    final freqHz=1/21600,
    final amplitude=2,
    phase=0,
    final offset=273.15 + 15)
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation
  connect(intTimTab.y[1], generalModeSelection.uMod) annotation (Line(points={{
          -62,50},{-40,50},{-40,20.8},{29.913,20.8}}, color={255,127,0}));
  connect(sin.y, generalModeSelection.uNom) annotation (Line(points={{-42,8},{
          -6,8},{-6,12.8},{29.913,12.8}}, color={0,0,127}));
  connect(sin1.y, generalModeSelection.uShe) annotation (Line(points={{-38,-34},
          {-4,-34},{-4,8.8},{29.913,8.8}}, color={0,0,127}));
  connect(sin2.y, generalModeSelection.uReb) annotation (Line(points={{-38,-80},
          {-4,-80},{-4,4.2},{29.913,4.2}}, color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end GeneralModeSelection;
