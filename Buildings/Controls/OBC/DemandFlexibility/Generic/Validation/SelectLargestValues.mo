within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SelectLargestValues
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.SelectLargestValues
    selectLargestValues(nNum=5, nSel=3)
    annotation (Placement(transformation(extent={{2,-10},{22,10}})));
  CDL.Reals.Sources.Constant con[5](k={7,13,5,2,3})
    annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
equation
  connect(con.y, selectLargestValues.u)
    annotation (Line(points={{-54,0},{0,0}}, color={0,0,127}));
      annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end SelectLargestValues;
