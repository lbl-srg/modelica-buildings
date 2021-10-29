within Buildings.Fluid.Boilers;
model BoilerTable
  "Boiler with efficiency described by a table with control signal and inlet temperature"
  extends Buildings.Fluid.Boilers.BaseClasses.PartialBoiler;
  parameter Modelica.SIunits.Temperature
    T_inlet_nominal = 323.15 "Norminal inlet temp";
  parameter Buildings.Fluid.Boilers.Data.EfficiencyCurves
    effCur "Efficiency curves as a table";
  parameter Modelica.Blocks.Types.Smoothness
    smo = Modelica.Blocks.Types.Smoothness.ContinuousDerivative
    "Interpolation method";

  //The extrapolation setting is commented out
  //  because it throws out an error in jmodelica unit tests.
    /*  parameter Modelica.Blocks.Types.Extrapolation
    ext = Modelica.Blocks.Types.Extrapolation.HoldLastPoint
    "Extrapolation method";*/

  Modelica.Blocks.Tables.CombiTable2D effTab(
    table=effCur.effCur,
    smoothness=smo)
    "Look-up table that represents a set of efficiency curves varying with both the firing rate (control signal) and the inlet water temperature"
    annotation (Placement(transformation(extent={{-74,64},{-54,84}})));
    //extrapolation=ext

  Modelica.Blocks.Interfaces.RealInput T_inlet(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Inlet temperature"
    annotation (Placement(transformation(extent={{-140,16},{-100,56}}),
        iconTransformation(extent={{-140,-64},{-100,-24}})));

initial equation
  eta_nominal = Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=T_inlet_nominal, xSup=effCur.effCur[1,2:end], ySup=effCur.effCur[end,2:end]);
  assert(abs(effCur.effCur[end,1] - 1) < 1E-6,
    "Efficiency curve at full load (y = 1) must be provided.");

equation
  eta=effTab.y;
  connect(effTab.u1, y) annotation (Line(points={{-76,80},{-120,80}},
                color={0,0,127}));
  connect(T_inlet, effTab.u2) annotation (Line(points={{-120,36},{-82,36},{-82,
          68},{-76,68}},
                     color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This is a model of a boiler whose efficiency is described 
by a table with control signal and inlet temperature. 
An example table is supplied in 
<a href=\"Buildings.Fluid.Boilers.Data.EfficiencyCurves\">
<code>Buildings.Fluid.Boilers.Data.EfficiencyCurves</code></a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2021 by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"), Icon(graphics={Line(points={{-100,-44},{-80,-44}}, color={0,0,0}),
        Text(
          extent={{-22,-54},{-142,-104}},
          lineColor={0,0,0},
          textString="T_in")}));
end BoilerTable;
