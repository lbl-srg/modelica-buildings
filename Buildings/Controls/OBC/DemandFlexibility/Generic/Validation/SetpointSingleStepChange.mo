within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SetpointSingleStepChange
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointSingleStepChange
    setpointSingleStepChange
    annotation (Placement(transformation(extent={{18,-62},{48,-36}})));
  CDL.Logical.Sources.Pulse booPul(period=86400, shift=43200)
    annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  CDL.Reals.Sources.Constant con(k=273.15 + 25)
    annotation (Placement(transformation(extent={{-72,-58},{-52,-38}})));
  CDL.Reals.Sources.Constant con1(k=273.15 + 20)
    annotation (Placement(transformation(extent={{-78,-92},{-58,-72}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SingleTemperatureSetpointMock
    singleTemperatureSetpointMock annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={36,-8})));
  CDL.Interfaces.RealOutput TSet
    annotation (Placement(transformation(extent={{100,-10},{140,30}})));
equation
  connect(booPul.y, setpointSingleStepChange.have_pri) annotation (Line(points={{-48,10},
          {-30,10},{-30,-39.6593},{16,-39.6593}},           color={255,0,255}));
  connect(con.y, setpointSingleStepChange.uSetTar) annotation (Line(points={{-50,-48},
          {-30,-48},{-30,-49.2889},{16,-49.2889}},          color={0,0,127}));
  connect(con1.y,setpointSingleStepChange.uSetBas)  annotation (Line(points={{
          -56,-82},{-32,-82},{-32,-54.1037},{16,-54.1037}}, color={0,0,127}));
  connect(setpointSingleStepChange.ySetCom, singleTemperatureSetpointMock.uTSet)
    annotation (Line(points={{50,-47.5556},{50,-8},{48,-8}}, color={0,0,127}));
  connect(singleTemperatureSetpointMock.yTSet, setpointSingleStepChange.uSetCur)
    annotation (Line(points={{24,-8},{-22,-8},{-22,-44.4741},{16,-44.4741}},
        color={0,0,127}));
  connect(singleTemperatureSetpointMock.yTSet, TSet) annotation (Line(points={{
          24,-8},{-16,-8},{-16,10},{120,10}}, color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointSingleStepChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointSingleStepChange</a>.</p>
</html>"));
end SetpointSingleStepChange;
