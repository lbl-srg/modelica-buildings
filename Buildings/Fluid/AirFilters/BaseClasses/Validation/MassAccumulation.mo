within Buildings.Fluid.AirFilters.BaseClasses.Validation;
model MassAccumulation
  "Validation model for the accumulation of the contaminants"
  extends Modelica.Icons.Example;

  Buildings.Fluid.AirFilters.BaseClasses.MassAccumulation masAcc(
    mCon_nominal=1,
    mCon_reset=0)
    "Contaminant accumulation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp mCon_flow[1](
    each duration=1,
    each height=1.2,
    each offset=0) "Contaminant mass flow rate"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse RepSig(
    period=1,
    shift=0.5)
    "Filter replacement signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

equation
  connect(RepSig.y, masAcc.uRep)
    annotation (Line(points={{-38,-20},{-20,-20},{-20,-6},{-12,-6}}, color={255,0,255}));
  connect(mCon_flow.y, masAcc.mCon_flow) annotation (Line(points={{-39,30},{-20,
          30},{-20,0},{-12,0}}, color={0,0,127}));
annotation (experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/Validation/MassAccumulation.mos"
        "Simulate and plot"),
Documentation(revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
The contaminant mass flow rate <code>mCon_flow</code> changes 
from <i>0</i> to <i>1.2kg/s</i> during the period from 0 to 1 second;
The filter replacement signal changes from <i>false</i> to <i>true</i> at 0.5 seconds.
</p>
<p>
The contaminant mass <code>masAcc.mCon</code> increases from <i>0</i> to <i>0.15kg/s</i> 
during the period from 0 to 0.5 seconds;
It drops to <i>0kg</i> at 0.5 seconds and keeps increasing again after that.
</p>
</html>"));
end MassAccumulation;
