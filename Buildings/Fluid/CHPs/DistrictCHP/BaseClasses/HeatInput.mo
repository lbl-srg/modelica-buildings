within Buildings.Fluid.CHPs.DistrictCHP.BaseClasses;
block HeatInput "This is a calculator for the required heat input"
  extends Modelica.Blocks.Icons.Block;

  parameter Real a_SteMas[:]={0.153, 0.018, 0.002}
  "Coefficients for the function relating the ratio of the steam flow rate to the exhaust flow rate";

  Modelica.Blocks.Interfaces.RealInput TExh(
   final unit= "degC",
   final quantity= "ThermodynamicTemperature") "Exhaust gas temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput steEnt
  "Fixed steam enthalpy"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput QFlo
  "Heat input"
    annotation (Placement(
        transformation(extent={{100,22},{136,58}}), iconTransformation(
          extent={{100,22},{136,58}})));
  Modelica.Blocks.Interfaces.RealOutput mSte
  "Calculated steam mass flow rate"
    annotation (Placement(
        transformation(
        extent={{-18,-18},{18,18}},
        rotation=-90,
        origin={0,-118}),  iconTransformation(
        extent={{-19,-19},{19,19}},
        rotation=-90,
        origin={-1,-119})));
  Modelica.Blocks.Interfaces.RealInput mExh
  "Exhaust mass flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput watEnt
  "fixed water enthalpy"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  SteamToExhaustMassFlowRatio ratSteMasToExhMas(
   final a_SteMas=a_SteMas)
    annotation (Placement(transformation(extent={{-60,66},{-40,86}})));
  Modelica.Blocks.Interfaces.RealInput TSte(
   final unit="degC",
   final quantity="ThermodynamicTemperature")
    "Steam temperature" annotation (Placement(transformation(extent={{-140,-20},
            {-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Multiply heaInp
    "Calculated heat flow rate"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Multiply masSte
    "The calculated steam mass flow rate"
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
equation
  connect(TSte, ratSteMasToExhMas.TSte) annotation (Line(points={{-120,0},{-80,
          0},{-80,72},{-62,72}}, color={0,0,127}));
  connect(heaInp.y, QFlo)
    annotation (Line(points={{82,40},{118,40}}, color={0,0,127}));
  connect(masSte.y, heaInp.u1) annotation (Line(points={{-8,60},{0,60},{0,46},{
          58,46}},      color={0,0,127}));
  connect(sub.y, heaInp.u2) annotation (Line(points={{-18,-60},{40,-60},{40,34},
          {58,34}},     color={0,0,127}));
  connect(mExh, masSte.u2) annotation (Line(points={{-120,40},{-36,40},{-36,54},
          {-32,54}},     color={0,0,127}));
  connect(steEnt, sub.u1) annotation (Line(points={{-120,-40},{-60,-40},{-60,
          -54},{-42,-54}},     color={0,0,127}));
  connect(watEnt, sub.u2) annotation (Line(points={{-120,-80},{-60,-80},{-60,
          -66},{-42,-66}},     color={0,0,127}));
  connect(ratSteMasToExhMas.mu, masSte.u1) annotation (Line(points={{-38,76},{
          -36,76},{-36,66},{-32,66}},
                                  color={0,0,127}));
  connect(masSte.y,mSte)
    annotation (Line(points={{-8,60},{0,60},{0,-118}}, color={0,0,127}));
  connect(mSte,mSte)
    annotation (Line(points={{0,-118},{0,-118}}, color={0,0,127}));
  connect(ratSteMasToExhMas.TExh, TExh)
    annotation (Line(points={{-62,80},{-120,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
This calculation block determines the required heat input to meet the enthalpy difference between the feedwater and the saturated steam.
</p>

<p align=\"center\">
<i>
Q&#775;<sub>in</sub> = m&#775;<sub>ste</sub> ( h<sub>ste</sub> - h<sub>wat</sub> ),
</i>
</p>

<p>
where
<i>Q&#775;<sub>in</sub></i> is the required heat flow, 
<i>h<sub>ste</sub></i> is the defined saturated steam specific enthalpy,
and <i>h<sub>wat</sub></i> is the defined feedwater specific enthalpy.
The <i>m&#775;<sub>ste</sub><i> is calculated by
<p align=\"center\">
<i>
m&#775;<sub>ste</sub> = &mu; m&#775;<sub>exh</sub>,
</i>
</p>
where <i>m&#775;<sub>exh</sub></i> is the exhaust gas mass flow rate.
The parameter <i>&mu;</i> denotes the ratio of the steam mass flow rate to the exhaust gas mass flow rate. 
This ratio is determined using the calculation block <code>SteamToExhaustMassFlowRatio</code>.



</p>



</html>"));
end HeatInput;
