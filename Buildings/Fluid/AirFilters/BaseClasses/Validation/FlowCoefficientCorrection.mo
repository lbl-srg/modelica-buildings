within Buildings.Fluid.AirFilters.BaseClasses.Validation;
model FlowCoefficientCorrection
  "Validation model for the calculation of the flow coefficient correction factor"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.AirFilters.BaseClasses.Data.Generic per(
      mCon_nominal=1, filterationEfficiencyParameters(rat={{0,0.5,1}}, eps={{
          0.7,0.6,0.5}}))
    "Performance dataset"
    annotation (Placement(transformation(extent={{-60,66},{-40,86}})));
  Modelica.Blocks.Sources.Ramp rat(
    duration=1,
    height=1,
    offset=0)
   "Relative mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection kCor(per=per)
    "Flow coefficient correction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(rat.y, kCor.rat)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/Validation/FlowCoefficientCorrection.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
The input relative mass of the contaminant captured by the filter <code>rat</code> 
changes from <i>0</i> to <i>1</i> from 0 to 1 second.
</p>
<p>
The <code>kCor.y</code> changes from 1 to 1.2 during the period from
0 to 1 second.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowCoefficientCorrection;
