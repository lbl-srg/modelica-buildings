within Buildings.Fluid.CHPs.DistrictCHP.BaseClasses;
block HRSGSteam "Superheated steam heat flow from HRSG"
  extends Modelica.Blocks.Icons.Block;

  parameter Real TSta(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit="degC") = 273.15+87.778
    "Exhaust stack temperature";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TExh(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit="degC")
    "Gas turbine exhaust gas temperature"
     annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mExh_flow(
    final unit="kg/s")
    "Gas turbine exhaust gas mass flow rate"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit="degC")
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QSupSte_flow(
    final quantity="Power",
    final unit="W")
    "Superheated steam heat flow"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HRSGEfficiency heaExcEff(
    final TSta = TSta)
    "HRSG Efficiency depends on the stack temperature"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.WasteHeatEnthalpy wasEnt
    "Waste heat specific enthalpy"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Multiply heaRec
    "Heat generation within the engine"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply supSte "Superheated steam energy "
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(heaRec.y, supSte.u2) annotation (Line(points={{22,-20},{40,-20},{40,
          -6},{58,-6}}, color={0,0,127}));
  connect(heaExcEff.TExh, TExh)
    annotation (Line(points={{-42,44},{-80,44},{-80,40},{-120,40}}, color={0,0,127}));
  connect(wasEnt.TExh, TExh) annotation (Line(points={{-42,4},{-80,4},{-80,40},
          {-120,40}},color={0,0,127}));
  connect(mExh_flow, heaRec.u2) annotation (Line(points={{-120,-40},{-10,-40},{
          -10,-26},{-2,-26}}, color={0,0,127}));
  connect(heaExcEff.eta_HRSG, supSte.u1)
    annotation (Line(points={{-18,40},{0,40},{0,6},{58,6}}, color={0,0,127}));
  connect(heaExcEff.TAmb, TAmb) annotation (Line(points={{-42,36},{-60,36},{-60,
          0},{-120,0}}, color={0,0,127}));
  connect(wasEnt.TAmb, TAmb) annotation (Line(points={{-42,-4},{-60,-4},{-60,0},
          {-120,0}}, color={0,0,127}));
  connect(heaRec.u1, wasEnt.hWasHea) annotation (Line(points={{-2,-14},{-10,-14},
          {-10,0},{-18,0}}, color={0,0,127}));
  connect(supSte.y, QSupSte_flow)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));

annotation (defaultComponentName="supSteaHea",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
The superheated steam heat flow is calculated by the equations:
</p>
<p align=\"center\">
<i>
Q&#775;<sub>ste</sub> = m&#775;<sub>exh</sub> h<sub>exh</sub> &eta;<sub>HRSG</sub>,
</i>
</p>
<p>
where <i>Q&#775;<sub>ste</sub></i> is the superheated steam heat flow in the outlet of HRSG, 
and <i>m&#775;<sub>exh</sub></i> is the exhaust gas mass flow rate.
<i>h<sub>exh</sub></i> is the specific enthalpy of the exhaust gas, which is calculated
by the instance of the block
<a href=\"modelica://Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.WasteHeatEnthalpy\">
Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.WasteHeatEnthalpy</a>.
<i>&eta;<sub>HRSG</sub></i> denotes the effectiveness of the HRSG (heat recovery
steam generator), which is calculated by the instance of the block
<a href=\"modelica://Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HRSGEfficiency\">
Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HRSGEfficiency</a>.
</p>
</html>"));
end HRSGSteam;
