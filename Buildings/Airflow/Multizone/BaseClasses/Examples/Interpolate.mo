within Buildings.Airflow.Multizone.BaseClasses.Examples;
model Interpolate "Test model for the interpolation function"
  extends Modelica.Icons.Example;

  parameter Real table[:,:]=[-50,-0.08709; -25,-0.06158; -10,-0.03895; -5,-0.02754;
      -3,-0.02133; -2,-0.01742; -1,-0.01232; 0,0; 1,0.01232; 2,0.01742; 3,0.02133;
      4.5,0.02613; 50,0.02614]
      "Table of mass flow rate in kg/s (second column) as a function of pressure difference in Pa (first column)";

  Modelica.Units.SI.PressureDifference dp
    "Pressure difference";
  Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate";

protected
  parameter Real[:] xd=table[:,1] "X-axis support points";
  parameter Real[size(xd, 1)] yd=table[:,2] "Y-axis support points";
  parameter Real[size(xd, 1)] d(each fixed=false) "Derivatives at the support points";

  Modelica.Blocks.Sources.Ramp ramp(
    duration=500,
    height=100,
    offset=-50) "Ramp from -50Pa to +50Pa";
initial equation
  d =Buildings.Utilities.Math.Functions.splineDerivatives(
    x=xd,
    y=yd,
    ensureMonotonicity=true);
equation
   dp=ramp.y;
   m_flow =Buildings.Airflow.Multizone.BaseClasses.interpolate(u=dp,xd=xd,yd=yd,d=d);

  annotation (
experiment(
      StopTime=500,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/BaseClasses/Examples/Interpolate.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example demonstrates the function
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.interpolate\">
Buildings.Airflow.Multizone.BaseClasses.interpolate</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Apr 6, 2021, 2020, by Klaas De Jonge:<br/>
First implementation
</li>
</ul>
</html>
"));
end Interpolate;
