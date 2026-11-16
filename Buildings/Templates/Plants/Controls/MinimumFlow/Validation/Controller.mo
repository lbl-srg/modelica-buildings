within Buildings.Templates.Plants.Controls.MinimumFlow.Validation;
model Controller
  "Validation model for the minimum flow bypass valve controller"
  Buildings.Templates.Plants.Controls.MinimumFlow.Controller ctlFloMinPum(
    use_val=false,
    use_pumPriDed=true,
    use_pumPriDedEqu=fill(true, 2),
    V_flow_nominal={0.02,0.05},
    V_flow_min={0.01,0.03},
    nEqu=2)
    "Valve controller enabled by primary pump status"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.Controller ctlFloMinVal(
    use_val=true,
    use_valEqu=fill(true, 2),
    use_pumPriDed=false,
    V_flow_nominal={0.02,0.05},
    V_flow_min={0.01,0.03},
    nEqu=2)
    "Valve controller enabled by isolation valve command"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1EquValPum(
    table=[
      0, 0, 0;
      1, 1, 0;
      2, 1, 1;
      3, 0, 1;
      4, 0, 0],
    timeScale=200,
    period=900)
    "Source signal for equipment or valve command or pump status"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin dVPri_flow(
    amplitude=sum(ctlFloMinVal.V_flow_min) / 2,
    freqHz=3 / 1000)
    "Source signal for primary flow rate variation around setpoint"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPri_flow1
    "Primary flow rate"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPri_flow
    "Primary flow rate"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
equation
  connect(u1EquValPum.y[1:2], ctlFloMinVal.u1ValIso[1:2]) annotation (Line(
        points={{-58,40},{0,40},{0,44.5},{18,44.5}}, color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPum.u1PumPri_actual[1:2])
    annotation (Line(points={{-58,40},{0,40},{0,-40},{18,-40}},    color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinVal.u1Equ[1:2])
    annotation (Line(points={{-58,40},{0,40},{0,48.5},{18,48.5}},color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPum.u1Equ[1:2])
    annotation (Line(points={{-58,40},{0,40},{0,-31.5},{18,-31.5}},color={255,0,255}));
  connect(dVPri_flow.y, VPri_flow1.u2)
    annotation (Line(points={{-58,0},{-40,0},{-40,-66},{-32,-66}},color={0,0,127}));
  connect(VPri_flow1.y, ctlFloMinPum.VPri_flow)
    annotation (Line(points={{-8,-60},{10,-60},{10,-44},{18,-44}},color={0,0,127}));
  connect(ctlFloMinPum.VPriSet_flow, VPri_flow1.u1)
    annotation (Line(points={{42,-34},{50,-34},{50,-20},{-36,-20},{-36,-54},{
          -32,-54}},
      color={0,0,127}));
  connect(ctlFloMinVal.VPriSet_flow, VPri_flow.u1)
    annotation (Line(points={{42,46},{50,46},{50,60},{-40,60},{-40,26},{-32,26}},
      color={0,0,127}));
  connect(dVPri_flow.y, VPri_flow.u2)
    annotation (Line(points={{-58,0},{-40,0},{-40,14},{-32,14}},color={0,0,127}));
  connect(VPri_flow.y, ctlFloMinVal.VPri_flow)
    annotation (Line(points={{-8,20},{10,20},{10,36},{18,36}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/MinimumFlow/Validation/Controller.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1000.0,
      Tolerance=1e-06),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.MinimumFlow.Controller\">
Buildings.Templates.Plants.Controls.MinimumFlow.Controller</a>
in two configurations: one where the bypass valve controller is enabled
with the isolation valve command (component <code>ctlFloMinVal</code>), and 
another where it is enabled with the primary pump status (component <code>ctlFloMinPum</code>).
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
