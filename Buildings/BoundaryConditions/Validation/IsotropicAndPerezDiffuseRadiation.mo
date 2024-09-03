within Buildings.BoundaryConditions.Validation;
model IsotropicAndPerezDiffuseRadiation
  "Partial model to run BESTEST validation case studies for weather data processing"
  extends Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.PartialSolarIrradiation;
  Modelica.Blocks.Interfaces.RealOutput HPer(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2")
    "Radiation per unit area using Perez Model"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  parameter Modelica.Units.SI.Angle til(displayUnit="deg") "Surface tilt angle";
  parameter Modelica.Units.SI.Angle azi(displayUnit="deg") "Azimuth angle";
  parameter Real rho=0.2
    "Ground reflectance";
  SolarIrradiation.DirectTiltedSurface HDir(
    til=til,
    azi=azi)
    "Direct Irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  SolarIrradiation.DiffuseIsotropic HDiffIso(
    til=til,
    rho=rho,
    outSkyCon=true,
    outGroCon=true)
    "Isoentropic diffuse radiation"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  SolarIrradiation.DiffusePerez HDiffPer(
    til=til,
    rho=rho,
    azi=azi,
    outSkyCon=true,
    outGroCon=true)
    "Diffused radiation using Perez"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

protected
  Modelica.Blocks.Math.Add addHDirHDiffIso
    "Sum of Direct radiation and Isoentropic radiation"
    annotation (Placement(transformation(extent={{40,24},{60,44}})));
  Modelica.Blocks.Math.Add addHDirHDiffPer
    "Sum of Direct radiation and Perez radiation"
    annotation (Placement(transformation(extent={{40,-42},{60,-22}})));

equation
  connect(weaBus,HDiffIso.weaBus)
    annotation (Line(points={{-100,0},{-74,0},{-74,40},{-40,40}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(HDir.weaBus,HDiffIso.weaBus)
    annotation (Line(points={{-40,0},{-74,0},{-74,40},{-40,40}},color={255,204,51},thickness=0.5));
  connect(HDiffPer.weaBus,HDiffIso.weaBus)
    annotation (Line(points={{-40,-40},{-74,-40},{-74,40},{-40,40}},color={255,204,51},thickness=0.5));
  connect(HDir.H,addHDirHDiffPer.u1)
    annotation (Line(points={{-19,0},{0,0},{0,-20},{20,-20},{20,-26},{38,-26}},color={0,0,127}));
  connect(HDiffPer.H,addHDirHDiffPer.u2)
    annotation (Line(points={{-19,-40},{32,-40},{32,-38},{38,-38}},color={0,0,127}));
  connect(HDiffIso.H,addHDirHDiffIso.u1)
    annotation (Line(points={{-19,40},{38,40}},color={0,0,127}));
  connect(HDir.H,addHDirHDiffIso.u2)
    annotation (Line(points={{-19,0},{0,0},{0,20},{20,20},{20,28},{38,28}},color={0,0,127}));
  connect(addHDirHDiffIso.y,H)
    annotation (Line(points={{61,34},{80,34},{80,0},{110,0}},color={0,0,127}));
  connect(addHDirHDiffPer.y,HPer)
    annotation (Line(points={{61,-32},{80,-32},{80,-40},{110,-40}},color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      revisions="<html>
<ul>
<li>
September 6, 2021, by Ettore Zanetti:<br/>
Removed parameter <code>lat</code> as it is now obtained from the weather data bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
May 2, 2021, by Ettore Zanetti:<br/>
Added altitude to parameters.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
October 25, 2020, by Ettore Zanetti:<br/>
Updated comments for variable descriptions
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1351\">#1351</a>.
</li>
<li>
April 14, 2020, by Ettore Zanetti:<br/>
Rework after comments from pull request
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1339\">#1339</a>.
</li>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model outputs the global radiation with a certain inclination and orientation
using the isotropic sky model and the Perez sky model. The variable <code>H</code> is
the global radiation calculated using the isotropic sky model, while <code>HPer</code> is
the global radiation calculated using the Perez sky model.</p>
</html>"));
end IsotropicAndPerezDiffuseRadiation;
