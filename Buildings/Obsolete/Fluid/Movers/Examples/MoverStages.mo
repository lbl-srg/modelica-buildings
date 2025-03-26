within Buildings.Obsolete.Fluid.Movers.Examples;
model MoverStages
  "Example model of movers using an integer input for setting the stage"
  extends Buildings.Obsolete.Fluid.Movers.Examples.MoverParameter(
    pump_Nrpm(inputType=Buildings.Fluid.Types.InputType.Stages),
    pump_m_flow(inputType=Buildings.Fluid.Types.InputType.Stages),
    pump_y(inputType=Buildings.Fluid.Types.InputType.Stages),
    pump_dp(inputType=Buildings.Fluid.Types.InputType.Stages));
  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=2
    "Nominal mass flow rate";

  Modelica.Blocks.Sources.IntegerTable integerTable(table=[0,1; 0.3,2; 0.6,3])
    "Integer step input, 1 is off, 2 is on"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  parameter Modelica.Units.SI.PressureDifference dp_nominal=10000
    "Nominal pressure raise";
equation
  connect(integerTable.y, pump_Nrpm.stage)
    annotation (Line(points={{-39,80},{0,80},{0,52}}, color={255,127,0}));
  connect(integerTable.y, pump_m_flow.stage)
    annotation (Line(points={{-39,80},{-30,80},{-30,20},{-30,20},{-30,20},{0,20},
          {0,12}},                                    color={255,127,0}));
  connect(integerTable.y, pump_y.stage)
    annotation (Line(points={{-39,80},{-30,80},{-30,-16},{-30,-16},{-30,-20},{0,
          -20},{0,-28}},                               color={255,127,0}));
  connect(integerTable.y, pump_dp.stage)
    annotation (Line(points={{-39,80},{-30,80},{-30,-60},{0,-60},{0,-68}},
                                                       color={255,127,0}));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Fluid/Movers/Examples/MoverStages.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates the use of the <code>Integer</code>
stage connector for a mover model.
Note that integer input <i>1</i> refers to the first stage, whereas
input <i>0</i> switches the mover off.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2023, by Hongxiang Fu:<br/>
Copied this model to the Obsolete package.
Revised its original version to remove the <code>Nrpm</code> mover.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">#1704</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
August 24, 2015, by Filip Jorissen:<br/>
Extended implementation with more movers.
</li>
<li>
April 2, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-06, StopTime=1));
end MoverStages;
