within Buildings.Controls.OBC.DemandFlexibility.Validation;
model SingleZoneRatchet
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.SingleZoneRatchet SingleZoneRatchet
    annotation (Placement(transformation(extent={{-28,-14},{28,30}})));
  CDL.Reals.Sources.TimeTable timTab(
    table=[0,273.15 + 14; 7,273.15 + 20; 17,273.15 + 19; 20,273.15 + 14; 24,
        273.15 + 14],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-84,2},{-64,22}})));
  CDL.Reals.Sources.TimeTable timTab1(
    table=[0,273.15 + 33; 7,273.15 + 28; 18,273.15 + 29; 20,273.15 + 33; 24,
        273.15 + 33],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-84,-36},{-64,-16}})));
  CDL.Reals.Sources.Sin                        TZon(
    final freqHz=1/86400,
    final amplitude=12,
    phase=3.1415926535898,
    final offset=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-86,42},{-66,62}})));
equation
  connect(timTab.y[1], SingleZoneRatchet.TZonHeaSetCur) annotation (Line(points
        ={{-62,12},{-38,12},{-38,11},{-30.2,11}}, color={0,0,127}));
  connect(timTab1.y[1], SingleZoneRatchet.TZonCooSetCur) annotation (Line(
        points={{-62,-26},{-40,-26},{-40,7.6},{-30.2,7.6}}, color={0,0,127}));
  connect(TZon.y, SingleZoneRatchet.TZon) annotation (Line(points={{-64,52},{-40,
          52},{-40,14.2},{-30.2,14.2}}, color={0,0,127}));
  annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end SingleZoneRatchet;
