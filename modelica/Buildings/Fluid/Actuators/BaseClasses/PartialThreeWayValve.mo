within Buildings.Fluid.Actuators.BaseClasses;
partial model PartialThreeWayValve "Partial three way valve"
    extends Buildings.Fluid.BaseClasses.PartialThreeWayResistance(
      final mDyn_flow_nominal = m_flow_nominal,
        redeclare replaceable 
          Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve
            res1 constrainedby 
               Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
               redeclare package Medium = Medium,
               l=l[1],
               deltaM=deltaM,
               dpValve_nominal=dpValve_nominal,
               dpFixed_nominal=dpFixed_nominal[1],
               dp(start=dpValve_nominal/2),
               from_dp=from_dp,
               linearized=linearized[1],
               homotopyInitialization=homotopyInitialization,
               m_flow_nominal=m_flow_nominal,
               CvData=CvData,
               Kv_SI=Kv_SI,
               Kv=Kv,
               Cv=Cv,
               Av=Av,
               final filteredOpening=false),
        redeclare FixedResistances.LosslessPipe res2(
          redeclare package Medium = Medium, m_flow_nominal=m_flow_nominal),
        redeclare replaceable 
          Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve
            res3 constrainedby 
               Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
               redeclare package Medium = Medium,
               l=l[2],
               deltaM=deltaM,
               dpValve_nominal=dpValve_nominal,
               dpFixed_nominal=dpFixed_nominal[2],
               dp(start=dpValve_nominal/2),
               from_dp=from_dp,
               linearized=linearized[2],
               homotopyInitialization=homotopyInitialization,
               m_flow_nominal=m_flow_nominal,
               CvData=CvData,
               Kv_SI=fraK*Kv_SI,
               Kv=fraK*Kv,
               Cv=fraK*Cv,
               Av=fraK*Av,
               final filteredOpening=false));
    extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters(
      dpValve_nominal=6000,
      rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default));
    extends Buildings.Fluid.Actuators.BaseClasses.ActuatorSignal;

  parameter Real fraK(min=0, max=1) = 0.7
    "Fraction Kv_SI(port_1->port_2)/Kv_SI(port_3->port_2)";
  parameter Real[2] l(min=0, max=1) = {0, 0} "Valve leakage, l=Cv(y=0)/Cvs";
  parameter Real deltaM = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));
  parameter Medium.MassFlowRate m_flow_nominal(min=0) "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dpFixed_nominal[2](each displayUnit="Pa",
                                                         each min=0) = {0, 0}
    "Nominal pressure drop of pipes and other equipment in flow legs at port_1 and port_3"
    annotation(Dialog(group="Nominal condition"));
  parameter Boolean[2] linearized = {false, false}
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Advanced"));

protected
  Modelica.Blocks.Math.Feedback inv "Inversion of control signal"
    annotation (Placement(transformation(extent={{-74,40},{-62,52}}, rotation=0)));
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Outputs one for bypass valve"
    annotation (Placement(transformation(extent={{-92,40},{-80,52}}, rotation=0)));
equation

  connect(uni.y, inv.u1)
    annotation (Line(points={{-79.4,46},{-72.8,46}},
                     color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{0,70},{40,70}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-100,44},{100,-36}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,26},{100,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{0,2},{-78,64},{-78,-56},{0,2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-68,56},{0,2},{56,44},{76,60},{-68,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-56,-40},{0,2},{56,44},{60,-40},{-56,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,2},{82,64},{82,-54},{0,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,-56},{24,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-14,-56},{14,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{0,2},{62,-80},{-58,-80},{0,2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-30,46},{30,46}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,100},{0,-2}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          visible=filteredOpening,
          extent={{-36,36},{36,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=filteredOpening,
          extent={{-36,100},{36,36}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=filteredOpening,
          extent={{-22,92},{20,46}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold})}),
    Documentation(info="<html>
<p>
Partial model of a three way valve. This is the base model for valves
with different opening characteristics, such as linear, equal percentage
or quick opening. The three way valve model consists of a mixer where 
valves are placed in two of the flow legs. The third flow leg
has no friction. 
The flow coefficient <code>Kv_SI</code> for flow from <code>port_1 -> port_2</code> is
a parameter and the flow coefficient for flow from <code>port_3 -> port_2</code>
is computed as<pre>
         Kv_SI(port_1 -> port_2)
  fraK = ----------------------
         Kv_SI(port_3 -> port_2)
</pre> 
where <code>fraK</code> is a parameter.
</p><p>
Since this model uses two way valves to construct a three way valve, see 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a> for details regarding the valve implementation.
</p>
</html>", revisions="<html>
<ul>
<li>
February 20, 2012 by Michael Wetter:<br>
Renamed parameter <code>dp_nominal</code> to <code>dpValve_nominal</code>,
and added new parameter <code>dpFixed_nominal=0</code>.
See 
<a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
Buildings.Fluid.Actuators.UsersGuide</a>.
</li>
<li>
March 25, 2011, by Michael Wetter:<br>
Added homotopy method.
</li>
<li>
June 3, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialThreeWayValve;
