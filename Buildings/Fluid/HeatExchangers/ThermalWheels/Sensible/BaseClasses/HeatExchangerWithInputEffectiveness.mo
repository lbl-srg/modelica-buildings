within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses;
model HeatExchangerWithInputEffectiveness
  "Heat exchanger with varying effectiveness"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectiveness(
    sensibleOnly1 = true,
    sensibleOnly2 = true,
    final prescribedHeatFlowRate1=true,
    final prescribedHeatFlowRate2=true,
    Q1_flow = eps * QMax_flow,
    Q2_flow = -Q1_flow,
    mWat1_flow = 0,
    mWat2_flow = 0);

  Buildings.Controls.OBC.CDL.Interfaces.RealInput eps(unit="1")
    "Sensible heat exchanger effectiveness"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,62,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-58,30},{52,-30}},
          textColor={255,255,255},
          textString="eps=%eps")}),
          preferredView="info",
defaultComponentName="hexInpEff",
Documentation(info="<html>
<p>
This block is identical to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>,
except that the sensible heat exchanger effectiveness is a input rather than a parameter.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 8, 2024, by Sen Huang:<br/>
First implementation based on <a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectivenesst</a>.
</li>
</ul>
</html>"));
end HeatExchangerWithInputEffectiveness;
