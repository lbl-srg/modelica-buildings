within Buildings.Fluid.Boilers;
model BoilerTable
  "Boiler with efficiency described by a table with control signal and inlet temperature"
  extends Buildings.Fluid.Boilers.BoilerBase(
    eta=effTable.y);
  parameter Modelica.SIunits.Temperature T_inlet_nominal = 323.15 "Norminal inlet temp";
  parameter Real tableInput[:,:]=
        [0,   294.3,299.8,305.4,310.9,316.5,322.0,327.6,333.2,338.7,344.3;
         0.05,0.991,0.984,0.974,0.959,0.940,0.920,0.900,0.887,0.881,0.880;
          0.5,0.988,0.981,0.969,0.952,0.932,0.908,0.890,0.883,0.879,0.878;
            1,0.969,0.962,0.951,0.935,0.918,0.897,0.885,0.879,0.875,0.874]
        "Efficiency table: First row = inlet temp(K), First column = firing rates or PLR";
/* Example efficiency table: 
    table=[0,   294.3,299.8,305.4,310.9,316.5,322.0,327.6,333.2,338.7,344.3;//u2:inlet temp,K
           0.05,0.991,0.984,0.974,0.959,0.940,0.920,0.900,0.887,0.881,0.880;
            0.5,0.988,0.981,0.969,0.952,0.932,0.908,0.890,0.883,0.879,0.878;
              1,0.969,0.962,0.951,0.935,0.918,0.897,0.885,0.879,0.875,0.874]
              //u1:firing rate or PLR (y)
*/
  parameter Modelica.Blocks.Types.Smoothness smooInput = Modelica.Blocks.Types.Smoothness.ContinuousDerivative
    "Interpolation method";
  parameter Modelica.Blocks.Types.Extrapolation extrInput = Modelica.Blocks.Types.Extrapolation.HoldLastPoint
    "Extrapolation method";

  Modelica.Blocks.Tables.CombiTable2D effTable(
    table=tableInput,
    smoothness=smooInput,
    extrapolation=extrInput)
    "Table that represents a set of efficiency curves varying with both firing rate (control signal) and inlet water temp."
    annotation (Placement(transformation(extent={{-74,64},{-54,84}})));

  Modelica.SIunits.Temperature T_inlet "inlet temp (K)";

initial equation
  if smooInput == Modelica.Blocks.Types.Smoothness.ConstantSegments then
    eta_nominal = Modelica.Blocks.Tables.Internal.getTable2DValueNoDer(
     tableID=effTable.tableID,u1=1,u2=T_inlet_nominal);
  else
    eta_nominal = Modelica.Blocks.Tables.Internal.getTable2DValue(
     tableID=effTable.tableID,u1=1,u2=T_inlet_nominal);
  end if;

equation
  effTable.u2=T_inlet;
  connect(effTable.u1, y) annotation (Line(points={{-76,80},{-120,80}},
                color={0,0,127}));
  annotation (Documentation(info="<html>
<p>This is a model of a boiler whose efficiency is described by a table with control signal and inlet temperature. </p>
</html>", revisions="<html>
<ul>
<li>
October 4, 2021 by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>
.
</li>
</ul>
</html>"));
end BoilerTable;
