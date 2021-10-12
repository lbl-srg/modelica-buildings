within Buildings.Fluid.Boilers;
model BoilerTable
  "Boiler with efficiency described by a table 
    with control signal and inlet temperature"
  extends Buildings.Fluid.Boilers.BaseClasses.PartialBoiler;
  parameter Modelica.SIunits.Temperature
    T_inlet_nominal = 323.15 "Norminal inlet temp";
  parameter Real effCur[:,:]=
        [0,   294.3,299.8,305.4,310.9,316.5,322.0,327.6,333.2,338.7,344.3;
         0.05,0.991,0.984,0.974,0.959,0.940,0.920,0.900,0.887,0.881,0.880;
          0.5,0.988,0.981,0.969,0.952,0.932,0.908,0.890,0.883,0.879,0.878;
            1,0.969,0.962,0.951,0.935,0.918,0.897,0.885,0.879,0.875,0.874]
        "Efficiency curves as a table: First row = inlet temp(K), First column = firing rates or PLR";
/* Example efficiency curve table: 
    table=[0,   294.3,299.8,305.4,310.9,316.5,322.0,327.6,333.2,338.7,344.3;//u2:T
           0.05,0.991,0.984,0.974,0.959,0.940,0.920,0.900,0.887,0.881,0.880;
            0.5,0.988,0.981,0.969,0.952,0.932,0.908,0.890,0.883,0.879,0.878;
              1,0.969,0.962,0.951,0.935,0.918,0.897,0.885,0.879,0.875,0.874]
              //u1:PLR */
  parameter Modelica.Blocks.Types.Smoothness
    smo = Modelica.Blocks.Types.Smoothness.ContinuousDerivative
    "Interpolation method";
  parameter Modelica.Blocks.Types.Extrapolation
    ext = Modelica.Blocks.Types.Extrapolation.HoldLastPoint
    "Extrapolation method";

  Modelica.Blocks.Tables.CombiTable2D effTab(
    table=effCur,
    smoothness=smo,
    extrapolation=ext)
    "Look-up table that represents a set of efficiency curves varying with both the firing rate (control signal) and the inlet water temperature."
    annotation (Placement(transformation(extent={{-74,64},{-54,84}})));

  Modelica.Blocks.Interfaces.RealInput
    T_inlet(quantity="ThermodynamicTemperature", unit="K") "Inlet temperature"
    annotation (Placement(transformation(extent={{-140,16},{-100,56}}),
        iconTransformation(extent={{-140,16},{-100,56}})));

initial equation
  eta_nominal = Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=T_inlet_nominal, xSup=effCur[1,2:end], ySup=effCur[end,2:end]);
  assert(effCur[end,1] == 1,
    "Efficiency curve at full load (y == 1) must be provided.");

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
</p>
</html>", revisions="<html>
<ul>
<li>
October 7, 2021 by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end BoilerTable;
