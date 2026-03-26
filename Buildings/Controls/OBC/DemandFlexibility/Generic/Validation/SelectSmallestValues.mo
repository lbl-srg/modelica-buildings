within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SelectSmallestValues
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.SelectSmallestValues
    selectSmallestValues(nNum=5, nSel=3)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Reals.Sources.Constant con[5](k={7,13,5,2,3})
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
equation
  connect(con.y, selectSmallestValues.u)
    annotation (Line(points={{-66,0},{-12,0}}, color={0,0,127}));
  annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end SelectSmallestValues;
