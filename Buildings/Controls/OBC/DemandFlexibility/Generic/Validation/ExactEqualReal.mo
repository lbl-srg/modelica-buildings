within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model ExactEqualReal
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.ExactEqualReal
    exactEqualReal
    annotation (Placement(transformation(extent={{-6,-12},{14,8}})));
  CDL.Reals.Sources.Sin sin(
    final freqHz=1/86400,
    final amplitude=1,
    phase=3.1415926535898,
    final offset=273.15 + 20)
    annotation (Placement(transformation(extent={{-72,0},{-52,20}})));
  CDL.Reals.Sources.Sin sin1(
    final freqHz=1/21600,
    final amplitude=10,
    final offset=273.15 + 25)
    annotation (Placement(transformation(extent={{-70,-48},{-50,-28}})));
equation
  connect(sin.y, exactEqualReal.u1) annotation (Line(points={{-50,10},{-30,10},{
          -30,4},{-8,4}}, color={0,0,127}));
  connect(sin1.y, exactEqualReal.u2) annotation (Line(points={{-48,-38},{-28,-38},
          {-28,-8},{-8,-8}}, color={0,0,127}));

    annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end ExactEqualReal;
