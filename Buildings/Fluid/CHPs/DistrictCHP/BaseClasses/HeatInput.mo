within Buildings.Fluid.CHPs.DistrictCHP.BaseClasses;
block HeatInput "Required heat input"
  extends Modelica.Blocks.Icons.Block;

  parameter Real a_SteMas[:]={0.153, 0.018, 0.002}
    "Coefficients for calculating steam to exhaust mass flow ratio";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TExh(
    displayUnit="degC",
    final unit= "K",
    final quantity= "ThermodynamicTemperature")
    "Exhaust gas temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mExh_flow(
    final quantity="MassFlowRate",
    final unit="kg/s")
    "Exhaust mass flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSte(
    displayUnit="degC",
    final unit= "K",
    final quantity= "ThermodynamicTemperature")
    "Steam temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hSte_flow(
    final quantity="SpecificEnergy",
    final unit="J/kg")
    "Fixed steam specific enthalpy"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hWat_flow(
    final quantity="SpecificEnergy",
    final unit="J/kg")
    "Fixed water specific enthalpy"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow
    "Heat input"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mSte_flow(
    final quantity="MassFlowRate",
    final unit="kg/s")
    "Calculated steam mass flow rate"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract entDif "Enthalpy difference"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.SteamToExhaustMassFlowRatio ratSteToExh(
    final a_SteMas=a_SteMas)
    "Steam to exhaust mass flow rate ratio"
    annotation (Placement(transformation(extent={{-60,66},{-40,86}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Multiply heaInp
    "Calculated heat flow rate"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply masSte
    "Calculated steam mass flow rate"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

equation
  connect(TSte, ratSteToExh.TSte) annotation (Line(points={{-120,0},{-80,0},{-80,
          72},{-62,72}}, color={0,0,127}));
  connect(heaInp.y, Q_flow)
    annotation (Line(points={{82,40},{120,40}}, color={0,0,127}));
  connect(masSte.y, heaInp.u1) annotation (Line(points={{22,60},{40,60},{40,46},
          {58,46}}, color={0,0,127}));
  connect(entDif.y, heaInp.u2) annotation (Line(points={{-18,-60},{20,-60},{20,
          34},{58,34}}, color={0,0,127}));
  connect(mExh_flow, masSte.u2) annotation (Line(points={{-120,40},{-20,40},{-20,
          54},{-2,54}}, color={0,0,127}));
  connect(hSte_flow, entDif.u1) annotation (Line(points={{-120,-40},{-60,-40},{-60,
          -54},{-42,-54}}, color={0,0,127}));
  connect(hWat_flow, entDif.u2) annotation (Line(points={{-120,-80},{-60,-80},{-60,
          -66},{-42,-66}}, color={0,0,127}));
  connect(ratSteToExh.mu, masSte.u1) annotation (Line(points={{-38,76},{-20,76},
          {-20,66},{-2,66}}, color={0,0,127}));
  connect(masSte.y, mSte_flow) annotation (Line(points={{22,60},{40,60},{40,-40},
          {120,-40}}, color={0,0,127}));
  connect(ratSteToExh.TExh, TExh)
    annotation (Line(points={{-62,80},{-120,80}}, color={0,0,127}));

annotation (defaultComponentName="reqHeaInp",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
                               Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-72,-55},{65,-55}}, color={255,255,255}),
        Line(points={{-58,73},{-58,-66}}, color={255,255,255}),
        Polygon(
          points={{-58,85},{-66,63},{-50,63},{-58,85}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{71,-55},{49,-47},{49,-63},{71,-55}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-58,-12},{-22,-12},{2,20},{24,28},{50,30}},
          color={255,255,255},
          smooth=Smooth.Bezier)}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
March 28, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This calculation block determines the required heat input to meet the enthalpy
difference between the feedwater and the saturated steam.
</p>
<p align=\"center\">
<i>
Q&#775;<sub>in</sub> = m&#775;<sub>ste</sub> ( h<sub>ste</sub> - h<sub>wat</sub> ),
</i>
</p>
<p>
where <i>Q&#775;<sub>in</sub></i> is the required heat flow,
<i>h<sub>ste</sub></i> is the defined saturated steam specific enthalpy,
and <i>h<sub>wat</sub></i> is the defined feedwater specific enthalpy.
The <i>m&#775;<sub>ste</sub></i> is calculated by
</p>
<p align=\"center\">
<i>
m&#775;<sub>ste</sub> = &mu; m&#775;<sub>exh</sub>,
</i>
</p>
<p>
where <i>m&#775;<sub>exh</sub></i> is the exhaust gas mass flow rate.
The parameter <i>&mu;</i> denotes the ratio of the steam mass flow rate to the
exhaust gas mass flow rate.
This ratio is calculated by the instance of the block
<a href=\"modelica://Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.SteamToExhaustMassFlowRatio\">
Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.SteamToExhaustMassFlowRatio</a>.
</p>
</html>"));
end HeatInput;
