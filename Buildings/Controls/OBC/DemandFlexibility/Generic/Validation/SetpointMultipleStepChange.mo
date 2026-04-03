within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model SetpointMultipleStepChange "Multiple-step setpoint change"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointMultipleStepChange
    setpointMultipleStepChange
    annotation (Placement(transformation(extent={{18,-72},{48,-46}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400, shift=43200)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=273.15 + 25)
    annotation (Placement(transformation(extent={{-72,-68},{-52,-48}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=273.15 + 20)
    annotation (Placement(transformation(extent={{-78,-102},{-58,-82}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SingleTemperatureSetpointMock
    singleTemperatureSetpointMock annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={36,-18})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSet
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  connect(booPul.y, setpointMultipleStepChange.have_pri) annotation (Line(
        points={{-48,0},{-30,0},{-30,-51},{16,-51}}, color={255,0,255}));
  connect(con.y, setpointMultipleStepChange.uSetTar) annotation (Line(points={{
          -50,-58},{-30,-58},{-30,-61.6},{16,-61.6}}, color={0,0,127}));
  connect(con1.y,setpointMultipleStepChange.uSetBas)  annotation (Line(points={
          {-56,-92},{-32,-92},{-32,-67},{16,-67}}, color={0,0,127}));
  connect(setpointMultipleStepChange.ySetCom, singleTemperatureSetpointMock.uTSet)
    annotation (Line(points={{50,-59},{50,-60},{68,-60},{68,-18},{48,-18}},
        color={0,0,127}));
  connect(singleTemperatureSetpointMock.yTSet, setpointMultipleStepChange.uSetCur)
    annotation (Line(points={{24,-18},{-22,-18},{-22,-55.6},{16,-55.6}}, color=
          {0,0,127}));
  connect(singleTemperatureSetpointMock.yTSet, TSet) annotation (Line(points={{
          24,-18},{-16,-18},{-16,0},{120,0}}, color={0,0,127}));
   annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>This example validates <a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointMultipleStepChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointMultipleStepChange</a>.</p>
</html>",
        revisions="<html>
<ul>
<li>
April 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>

</ul>
</html>"));
end SetpointMultipleStepChange;
