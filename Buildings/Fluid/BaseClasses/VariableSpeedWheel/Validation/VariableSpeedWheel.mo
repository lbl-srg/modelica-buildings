within Buildings.Fluid.BaseClasses.VariableSpeedWheel.Validation;
model VariableSpeedWheel
  extends Modelica.Icons.Example;
  Buildings.Fluid.BaseClasses.VariableSpeedWheel.Sensible senWhe(
    per=perSenWhe)
    "Sensible heat wheel"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.Fluid.BaseClasses.VariableSpeedWheel.BaseClasses.Data.ASHRAE
    perSenWhe(
    motorEfficiency_uSpe(y={0.1,0.6,0.8,1}, eta={0.3,0.8,0.85,1}),
      haveLatentHeatExchange=false,
      useDefaultMotorEfficiencyCurve=false)
    "Performance record for the sensible heat wheet"
    annotation (Placement(transformation(extent={{-80,74},{-60,94}})));
  Modelica.Blocks.Sources.Ramp uSpe(
    duration=1,
    startTime=0,
    offset=0,
    height=1) "Speed ratio"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.BaseClasses.VariableSpeedWheel.Latent
    latWhe(
      per=perLatWhe)
    "Enthalpy wheel"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.BaseClasses.VariableSpeedWheel.Latent
    latWheDefMotCur(
      per=perLatWheDefMotCur)
    "enthalpy wheel with default motor curve"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  BaseClasses.Data.ASHRAE perLatWhe(
    motorEfficiency_uSpe(y={0.1,0.6,0.8,1}, eta={0.3,0.8,0.85,1}),
      haveLatentHeatExchange=true,
      useDefaultMotorEfficiencyCurve=false)
    "Performance record for the enthalpy wheet"
    annotation (Placement(transformation(extent={{-40,74},{-20,94}})));
  BaseClasses.Data.ASHRAE perLatWheDefMotCur(haveLatentHeatExchange=true,
      useDefaultMotorEfficiencyCurve=true)
    "Performance record for the enthalpy wheet with default motor curve"
    annotation (Placement(transformation(extent={{0,74},{20,94}})));
equation
  connect(uSpe.y, senWhe.uSpe) annotation (Line(points={{-39,0},{-28,0},{-28,50},
          {-12,50}}, color={0,0,127}));
  connect(latWhe.uSpe, uSpe.y)
    annotation (Line(points={{-12,0},{-39,0}}, color={0,0,127}));
  connect(latWheDefMotCur.uSpe, uSpe.y) annotation (Line(points={{-12,-50},{-28,
          -50},{-28,0},{-39,0}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/VariableSpeedWheel/Validation/VariableSpeedWheel.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example for the model
<a href=\"modelica://Buildings.Fluid.BaseClasses.VariableSpeedWheel.Sensible\">
Buildings.Fluid.BaseClasses.VariableSpeedWheel.Sensible</a> and the model
<a href=\"modelica://Buildings.Fluid.BaseClasses.VariableSpeedWheel.Latent\">
Buildings.Fluid.BaseClasses.VariableSpeedWheel.latent</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The wheel speed <code>uSpe</code> changes from <i>0</i> to <i>1</i> 
during the period from 0 to 1 second.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
The power consumption of all three wheels increases by time
and equals to the nominal value when <code>uSpe=1</code>.
</li>
<li>
The heat exchange effectiveness corrections increase by time
and equals to 1 when <code>uSpe=1</code>.
</li>
</ul>
</html>"));
end VariableSpeedWheel;
