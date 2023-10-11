within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Validation;
model EffectivenessCalculation
  extends Modelica.Icons.Example;

  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.EffectivenessCalculation
    epsCal(
    epsL_cool_nominal=0.6,
    epsL_cool_partload=0.7,
    epsS_heat_nominal=0.7,
    epsL_heat_nominal=0.6,
    epsS_heat_partload=0.6,
    epsL_heat_partload=0.5,
    v_flow_sup_nominal=1) "Effectiveness calculator"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.Ramp y(
    height=0.7,
    duration=60,
    offset=0.3,
    startTime=60) "Wheel speed"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=5,
    duration=60,
    offset=273.15 + 20,
    startTime=0) "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Ramp TExh(
    height=20,
    duration=60,
    offset=273.15 + 15,
    startTime=0) "Exhaust air temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Ramp vSup(
    height=0.7,
    duration=60,
    offset=0.3,
    startTime=0) "Supply air flow rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Ramp vExh(
    height=0.8,
    duration=60,
    offset=0.2,
    startTime=0) "Exhaust air flow rate"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(y.y, epsCal.y) annotation (Line(points={{-59,80},{-22,80},{-22,8},{
          -14,8}}, color={0,0,127}));
  connect(TSup.y, epsCal.TSup) annotation (Line(points={{-59,40},{-24,40},{-24,
          4},{-14,4}}, color={0,0,127}));
  connect(TExh.y, epsCal.TExh)
    annotation (Line(points={{-59,0},{-14,0}}, color={0,0,127}));
  connect(vSup.y, epsCal.v_flow_Sup) annotation (Line(points={{-59,-40},{-24,
          -40},{-24,-4},{-14,-4}}, color={0,0,127}));
  connect(vExh.y, epsCal.v_flow_Exh) annotation (Line(points={{-59,-80},{-20,
          -80},{-20,-8},{-14,-8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(Tolerance=1e-6, StopTime=120),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/AirToAirHeatRecovery/BaseClasses/Validation/EffectivenessCalculation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.EffectivenessCalculation\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.EffectivenessCalculation</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The temperature of the supply air, <i>TSup</i>, is larger than the temperature
of the exhaust air, <i>TExh</i> before <i>20s</i>;
After that, <i>TSup</i> is less than <i>TExh</i>, leading to a heating mode.
</li>
<li>
The supply air flow rate, <i>vSup</i>, and the exhaust air flow rate,
<i>vExh</i>, change from 0.3 to 1 and 0.2 to 1 
during the period from <i>0s</i> to <i>60s</i>, respectively;
They then stay constant.
</li>
<li>
The wheel speed ratio, <i>y</i> keeps constant during the period from
<i>0s</i> to <i>60s</i> and then increases from 0.3 to 1
during the period from <i>60s</i> to <i>120s</i>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 29, 2022, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end EffectivenessCalculation;
