within Buildings.Airflow.Multizone.BaseClasses.Examples;
model WindPressureProfile
  "Test model for wind pressure profile function"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Angle incAngSurNor[:](
    each displayUnit="deg")=
      {0, 45, 90, 135, 180, 225, 270, 315}*Modelica.Constants.pi/180
    "Wind incidence angles, relative to the surface normal (normal=0), first point must be 0, last smaller than 2 pi(=360 deg)";
  parameter Real Cp[:](
    each final unit="1")=
      {0.4, 0.1, -0.3, -0.35, -0.2, -0.35, -0.3, 0.1}
    "Cp values at the corresponding incAngSurNor";

  Modelica.Units.SI.Angle  alpha "Wind incidence angle (0: normal to wall)";
  Real CpAct "Wind pressure coefficient";

protected
  final parameter Integer n=size(incAngSurNor, 1)
    "Number of data points provided by user";
  final parameter Modelica.Units.SI.Angle incAngExt[n + 3](each displayUnit=
        "deg") = cat(
    1,
    {incAngSurNor[n - 1] - (2*Modelica.Constants.pi)},
    incAngSurNor,
    2*Modelica.Constants.pi .+ {incAngSurNor[1],incAngSurNor[2]})
    "Extended number of incidence angles";
  final parameter Real CpExt[n+3]=cat(1, {Cp[n-1]}, Cp, {Cp[1], Cp[2]})
    "Extended number of Cp values";

  final parameter Real[n+3] deri=
      Buildings.Utilities.Math.Functions.splineDerivatives(
      x=incAngExt,
      y=CpExt,
      ensureMonotonicity=false) "Derivatives for table interpolation";

  Modelica.Blocks.Sources.Ramp ramp(
    duration=500,
    height=3*360,
    offset=-360)
    "Ramp model generating a singal from -360 to 720";

initial equation
  assert(size(incAngSurNor, 1) == size(Cp, 1), "In " + getInstanceName() +
    ": Size of parameters are size(CpincAng, 1) = " + String(size(incAngSurNor,
    1)) + " and size(Cp, 1) = " + String(size(Cp, 1)) + ". They must be equal.");

  assert(abs(incAngSurNor[1]) < 1E-4, "In " + getInstanceName() +
    ": First point in the table CpAngAtt must be 0.");

  assert(2*Modelica.Constants.pi - incAngSurNor[end] > 1E-4, "In " +
    getInstanceName() +
    ": Last point in the table CpAngAtt must be smaller than 2 pi (360 deg).");

equation
   alpha=Modelica.Constants.D2R*ramp.y;
   CpAct =Buildings.Airflow.Multizone.BaseClasses.windPressureProfile(
    alpha=alpha,
    incAngTab=incAngExt,
    CpTab=CpExt,
    d=deri) "Actual wind pressure coefficient";


  annotation (
experiment(
      StopTime=500,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/BaseClasses/Examples/WindPressureProfile.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This examples demonstrates the
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.windPressureProfile\">
Buildings.Airflow.Multizone.BaseClasses.windPressureProfile</a>
function.
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
Apr 6, 2021, by Klaas De Jonge:<br/>
First implementation
</li>
</ul>
</html>
"));
end WindPressureProfile;
