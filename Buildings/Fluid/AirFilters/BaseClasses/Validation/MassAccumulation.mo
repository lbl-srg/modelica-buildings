within Buildings.Fluid.AirFilters.BaseClasses.Validation;
model MassAccumulation
  "Validation model for the accumulation of the contaminants"
  extends Modelica.Icons.Example;

  Buildings.Fluid.AirFilters.BaseClasses.MassAccumulation masAcc(
    mCon_max=1,
    mCon_start=0) "Contaminant accumulation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp mCon_flow[1](
    each duration= 63072000,
    each height = 100/1000000000/1.293,
    each offset = 20/1000000000/1.293)
    "Contaminant mass flow rate"
    annotation (Placement(transformation(origin={0,-10}, extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay repFil(
    delayTime = 15*60)
    "Replace filter"
    annotation(Placement(transformation(origin={50,20}, extent={{-10,-10},{10,10}})));
equation
  connect(mCon_flow.y, masAcc.mCon_flow) annotation(
    Line(points={{-39,20},{-20,20},{-20,0},{-12,0}}, color={0,0,127}));
  connect(masAcc.yRep, repFil.u) annotation(
    Line(points={{12,8},{20,8},{20,20},{38,20}}, color={255,0,255}));
  connect(repFil.y, masAcc.uRep) annotation(
    Line(points={{62,20},{80,20},{80,-20},{-20,-20},{-20,-6},{-12,-6}}, color={255,0,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=63072000),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/Validation/MassAccumulation.mos"
        "Simulate and plot"),
Documentation(revisions="<html>
<ul>
<li>
December 23, 2025, by Jianjun Hu:<br/>
Changed to 2 years validation.
</li>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
The input trace substance changes from 20 &#181;g/m&sup3; (1.546e-8 kg/kg,
assuming the air density of 1.293 kg/m&sup3;) to 100 &#181;g/m&sup3;
(7.734e-8 kg/kg) during the 2 years period (63072000 seconds).
</p>
<p>
At around day 355, day 547, and day 696, the mass of the captured contaminant become
more than the maximum mass of the contaminant that can be captured (1.0 kg). The
filter thus was replaced and the captured mass was replaced to 0.
</p>
</html>"));
end MassAccumulation;
