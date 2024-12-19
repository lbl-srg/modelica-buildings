within GED.DistrictElectrical.CHP.BaseClasses;
block HRSGSteam "Superheated steam heat flow from HRSG"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.NonSI.Temperature_degC TSta = 87.778
    "Exhaust stack temperature in Celsius";

  Modelica.Blocks.Interfaces.RealInput TExh(
  final quantity="ThermodynamicTemperature",
  final unit = "degC") "Gas turbine exhaust gas temperature"
   annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}), iconTransformation(
          extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput mExh(
  final unit= "kg/s")
  "Gas turbine exhaust gas mass flow rate"
   annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput supSte(final quantity="Power", final
      unit="W") "Superheated steam heat flow" annotation (Placement(
        transformation(extent={{100,-18},{136,18}}), iconTransformation(extent=
            {{100,-18},{136,18}})));

  HRSGEfficiency heaExcEff(
  final TSta = TSta) "HRSG Efficiency depends on the stack temperature"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  WasteHeatEnthalpy wasEnt "Waste heat specific enthalpy"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Modelica.Blocks.Interfaces.RealInput TAmb(
  final quantity="ThermodynamicTemperature",
  final unit="degC") "Ambient temperature" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Multiply heaRec
    "Heat generation within the engine"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply supSte1 "Superheated steam energy "
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
equation
  connect(heaRec.y, supSte1.u2) annotation (Line(points={{12,-20},{20,-20},{20,
          -6},{28,-6}}, color={0,0,127}));
  connect(heaExcEff.TExh, TExh)
    annotation (Line(points={{-62,44},{-80,44},{-80,40},{-120,40}},
                                                  color={0,0,127}));
  connect(wasEnt.TExh, TExh) annotation (Line(points={{-62,4},{-80,4},{-80,40},{
          -120,40}},      color={0,0,127}));
  connect(mExh, heaRec.u2) annotation (Line(points={{-120,-40},{-20,-40},{
          -20,-26},{-12,-26}}, color={0,0,127}));
  connect(heaExcEff.eta_HRSG, supSte1.u1)
    annotation (Line(points={{-38,40},{0,40},{0,6},{28,6}}, color={0,0,127}));
  connect(heaExcEff.TAmb, TAmb) annotation (Line(points={{-62,36},{-72,36},{-72,
          0},{-120,0}},   color={0,0,127}));
  connect(wasEnt.TAmb, TAmb) annotation (Line(points={{-62,-4},{-72,-4},{-72,0},
          {-120,0}},  color={0,0,127}));
  connect(heaRec.u1, wasEnt.wasEnt) annotation (Line(points={{-12,-14},{-20,-14},
          {-20,0},{-38,0}}, color={0,0,127}));
  connect(supSte1.y, supSte)
    annotation (Line(points={{52,0},{118,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
<p>The superheated steam heat flow is calculated by the equations</p>

<p align=\"center\">
<i>
Q&#775;<sub>ste</sub> = m&#775;<sub>exh</sub> h<sub>exh</sub> &eta;<sub>HRSG</sub>,
</i>
</p>

<p>
where
<i>Q&#775;<sub>ste</sub></i> is the superheated steam heat flow in the outlet of HRSG, 
and <i>m&#775;<sub>exh</sub></i> is the exhaust gas mass flow rate.
<i>h<sub>exh</sub></i> is the specific enthalpy of the exhaust gas. It is determined by the exhaust temperature and the exhaust stack temperature within the calculation block <code>WasteHeatEnthalpy</code>.
<i>&eta;<sub>HRSG</sub></i> denotes the effectiveness of the HRSG (heat recovery steam generator). It is calculated using the calculation block <code>HRSGEfficiency</code>.
</p>



</html>"));
end HRSGSteam;
