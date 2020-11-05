within Buildings.Air.Systems.SingleZone.VAV.BaseClasses.Validation;
model ControllerEconomizer "Validate the block ControllerEconomizer"
  extends Modelica.Icons.Example;
  Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerEconomizer conEco
    "Controller for economizer"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Sine mixAirTem(
    amplitude=7.5,
    freqHz=1/86400,
    offset=20 + 273.15) "Mixed air temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Sine retAirTem(
    amplitude=4,
    freqHz=1/86400,
    offset=21 + 273.15) "Return air temperature"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Sine mixAirTemSet(
    amplitude=5,
    freqHz=1/86400,
    offset=20 + 273.15) "Mixed air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Sine minOutAirFra(
    freqHz=1/86400,
    offset=0.2,
    amplitude=0.15) "Minimum outdoor air fraction"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Sources.Sine outAirTem(
    freqHz=1/86400,
    amplitude=6,
    offset=18 + 273.15) "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Sine heaConSig(
    amplitude=0.1,
    freqHz=1/86400,
    offset=0.2) "Heating control signal"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(mixAirTemSet.y, conEco.TMixSet) annotation (Line(points={{-59,80},{-20,
          80},{20,80},{20,8},{39,8}}, color={0,0,127}));
  connect(mixAirTem.y, conEco.TMix) annotation (Line(points={{-59,50},{-59,50},
          {10,50},{10,5},{39,5}}, color={0,0,127}));
  connect(retAirTem.y, conEco.TRet) annotation (Line(points={{-59,20},{-59,20},
          {0,20},{0,2},{39,2}}, color={0,0,127}));
  connect(minOutAirFra.y, conEco.minOAFra) annotation (Line(points={{-59,-20},
          {-59,-20},{0,-20},{0,-2},{39,-2}}, color={0,0,127}));
  connect(outAirTem.y, conEco.TOut) annotation (Line(points={{-59,-50},{-59,-50},
          {10,-50},{10,-5},{39,-5}}, color={0,0,127}));
  connect(heaConSig.y, conEco.yHea) annotation (Line(points={{-59,-80},{-18,-80},
          {20,-80},{20,-8},{39,-8}}, color={0,0,127}));
  annotation (
  experiment(StopTime=604800,  Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/BaseClasses/Validation/ControllerEconomizer.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerEconomizer\">
Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerEconomizer</a>.
</p>
The sine inputs include:
<ul>
<li>
Mixed air temperature <code>mixAirTem</code>, varying from <i>12.5</i> &deg;C
to <i>27.5</i> &deg;C
</li>
<li>
Return air temperature <code>retAirTem</code>, varying from <i>17.0</i> &deg;C
to <i>25.0</i> &deg;C
</li>
<li>
Mixed air temperature setpoint <code>mixAirTemSet</code>, varying from <i>15.0
</i> &deg;C to <i>25.0</i> &deg;C
</li>
<li>
Outdoor air temperature <code>outAirTem</code>, varying from <i>12.0</i>
&deg;C to <i>24.0</i> &deg;C
</li>
<li>
Minimum outdoor air fraction <code>minOutAirFra</code>, varying from <i>0.05
</i> to <i>0.35</i>
</li>
<li>
Heating control signal <code>heaConSig</code>, varying from <i>0.1</i> to
<i>0.3</i>
</li>
</ul>

</html>", revisions="<html>
<ul>
<li>
July 3, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControllerEconomizer;
