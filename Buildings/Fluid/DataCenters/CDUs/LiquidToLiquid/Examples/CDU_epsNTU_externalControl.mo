within Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples;
model CDU_epsNTU_externalControl
  "Example model of a CDU for which the pump speed and the valve position are provided by an external controller"
  extends Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.BaseClasses.PartialCDU_epsNTU(
    cdu(
      use_yPum_in=true,
      use_yVal_in=true));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse yPum(
    amplitude=-0.2,
    width=0.5,
    period=3600,
    shift=1800,
    offset=1)
    "Pump speed command, reduced by 20 percent for half of each hour after the first 30 minutes"
    annotation(Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Reals.PID conVal(
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=1,
    Ti=120,
    reverseActing=false,
    r=10,
    xi_start=1)
    "External controller that tracks the rack supply temperature by commanding the valve"
    annotation(Placement(transformation(extent={{-60,70},{-40,90}})));

equation
  connect(yPum.y, cdu.yPum_in)
    annotation(Line(points={{-38,40},{-34,40},{-34,22},{-12,22}},   color={0,0,127}));
  connect(TSetRacIn.y, conVal.u_s)
    annotation(Line(points={{-78,80},{-62,80}}, color={0,0,127}));
  connect(senTRac_a.T, conVal.u_m)
    annotation(Line(points={{-80,31},{-80,60},{-50,60},{-50,68}},
                                                color={0,0,127}));
  connect(conVal.y, cdu.yVal_in)
    annotation(Line(points={{-38,80},{-30,80},{-30,30},{-12,30}}, color={0,0,127}));

  annotation(
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenters/CDUs/LiquidToLiquid/Examples/CDU_epsNTU_externalControl.mos"
      "Simulate and plot"),
    Diagram(
      coordinateSystem(extent={{-120,-120},{120,140}})),
    Icon(
      coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(
      info="<html>
<p>
This example models a liquid-to-liquid coolant distribution unit (CDU) whose
pump speed and valve position are commanded by external control signals.
</p>
<p>
The model extends
<a href=\"modelica://Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.BaseClasses.PartialCDU_epsNTU\">
Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.BaseClasses.PartialCDU_epsNTU</a>
and configures the CDU in the same plant and rack loop as
<a href=\"modelica://Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.CDU_epsNTU\">
Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.CDU_epsNTU</a>,
but replaces the internal CDU controllers with external control signals.
Setting <code>use_yPum_in = true</code> and <code>use_yVal_in = true</code>
removes the internal pump and valve controllers and the set point inputs
<code>dpSet</code> and <code>TSet</code>.
Instead, the inputs <code>yPum_in</code> and <code>yVal_in</code> command the
pump speed and the valve position directly.
</p>
<p>
An external PI controller <code>conVal</code> computes the valve position to
track the rack supply coolant temperature set point <code>TSetRacIn</code>.
A periodic pulse source <code>yPum</code> commands the pump speed.
This configuration allows, for example, a common external controller to
coordinate multiple CDUs.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 24, 2026, by Michael Wetter:<br/>
Refactored to extend
<a href=\"modelica://Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.BaseClasses.PartialCDU_epsNTU\">
Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.BaseClasses.PartialCDU_epsNTU</a>
without <code>break</code> statements.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4905\">Buildings, #4905</a>.
</li>
<li>
November 18, 2026, by Nauman Rafique:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4905\">Buildings, #4905</a>.
</li>
</ul>
</html>"));
end CDU_epsNTU_externalControl;
