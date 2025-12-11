within Buildings.Fluid.AirFilters.BaseClasses;
model PressureDropWithVaryingFlowCoefficient
  "Flow resistance with a varying flow coefficient"
  extends Buildings.Airflow.Multizone.BaseClasses.PartialOneWayFlowElement(
    m_flow=
      if Modelica.Math.isEqual(m, 0.5, 1E-10) then
        rho_default/(dpCor^m)*Buildings.Airflow.Multizone.BaseClasses.powerLaw05(
          C=C,
          dp=dp,
          a=a,
          b=b,
          c=c,
          d=d,
          dp_turbulent=dp_turbulent,
          sqrt_dp_turbulent=sqrt_dp_turbulent)
      else
        rho_default/(dpCor^m)*Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(
          C=C,
          dp=dp,
          m=m,
          a=a,
          b=b,
          c=c,
          d=d,
          dp_turbulent=dp_turbulent),
    final m_flow_small=1E-4*abs(m_flow_nominal));
  extends Buildings.Airflow.Multizone.BaseClasses.PowerLawResistanceParameters(
    m = 0.85);
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure difference of clean filter at m_flow_nominal"
    annotation (Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpCor(
    final unit = "1",
    final min = 1)
    "Flow coefficient correction factor"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
      rotation=-90, origin={0,120})));

protected
  parameter Real k=m_flow_nominal/(dp_nominal^m) "Flow coefficient, k = m_flow/ dp^m";
  parameter Real C=k/rho_default "Flow coefficient, C = V_flow/dp^m";


annotation (defaultComponentName="res",
Documentation(info="<html>
<p>
Model of a flow resistance with a varying flow coefficient.
</p>
<p>
This block is implemented based on
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>
and inherits most of its configuration.
However, its mass flow rate is calculated differently by using
</p>
<p align=\"center\" style=\"font-style:italic;\">
m_flow / &radic;<span style=\"text-decoration:overline;\">dp</span> = m_flow_nominal / (&radic;<span style=\"text-decoration:overline;\">dp_nominal*dpCor</span>),
</p>
<p>
where <code>dpCor</code> is a correction factor of the flow coefficient.
Therefore, if <code>dpCor=1.2</code>,
at the nominal mass flow rate <code>m_flow_nominal</code>,
there will be 20% more pressure drop
than <code>dp_nominal</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 10, 2025, by Michael Wetter:<br/>
Deleted old implementation as it assumed the pressure drop to be quadratic to the flow rate, which
is not the case for a filter.
</li>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-50,34},{52,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,6},{-58,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{42,8},{94,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,14},{70,-12}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PressureDropWithVaryingFlowCoefficient;
