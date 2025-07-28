within Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses;
model Performance "Desiccant dehumidifier performance"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Interfaces.BooleanInput uRot
    "Set to true to enable the dehumidification process"
    annotation (Placement(
    transformation(extent={{-124,68},{-100,92}}), iconTransformation(extent
    ={{-120,72},{-100,92}})));
  Modelica.Blocks.Interfaces.RealInput TProEnt(
    final unit="K")
    "Temperature of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-124,28},{-100,52}}),
    iconTransformation(extent={{-120,32},{-100,52}})));
  Modelica.Blocks.Interfaces.RealInput X_w_ProEnt(final unit="kg/kg")
    "Humidity ratio of the process air entering the dehumidifier"
    annotation (Placement(transformation(
    extent={{-124,-52},{-100,-28}}),
    iconTransformation(extent={{-120,-48},{-100,-28}})));
  Modelica.Blocks.Interfaces.RealInput mPro_flow(
    final unit="kg/s")
    "Mass flow rate of the process air"
    annotation (Placement(transformation(
    extent={{-124,-92},{-100,-68}}),
    iconTransformation(extent={{-120,-92},{-100,-72}})));
  Modelica.Blocks.Interfaces.RealOutput TProLea(
    final unit="K")
    "Temperature of the process air leaving the dehumidifier"
    annotation (
    Placement(transformation(extent={{100,70},{120,90}}),
    iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealInput TRegEnt(
    final unit="K")
    "Temperature of the regeneration air entering the dehumidifier"
    annotation(Placement(transformation(extent={{-124,-12},{-100,12}}),
    iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput X_w_ProLea(
    final unit="1")
    "Humidity ratio of the process air leaving the dehumidifier"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
    iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput mReg_flow(
    final unit="kg/s")
    "Mass flow rate of the regeneration air"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
    iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput hReg(
    final unit="J/kg")
    "Specific regeneration energy"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
    iconTransformation(extent={{100,-90},{120,-70}})));

protected
  Modelica.Units.SI.Velocity vReg
    "Velocity of the regeneration air";
  Modelica.Units.SI.Velocity vPro
    "Velocity of the process air";

equation
  vPro = mPro_flow/per.mPro_flow_nominal*per.vPro_nominal;
  // Dehumidification occurs with sufficient air and an active enable signal.
  if uRot and vPro>0.1 then
    // Check the inlet condition of the process inlet condition.
    assert(TProEnt <= per.TProEnt_max and TProEnt >= per.TProEnt_min,
       "In " + getInstanceName() + ": temperature of the process air entering the dehumidifier is beyond
       the range that is defined in the performance curve.",
       level=AssertionLevel.error);
    assert(X_w_ProEnt <= per.X_w_ProEnt_max and X_w_ProEnt >= per.X_w_ProEnt_min,
       "In " + getInstanceName() + ": humidity ratio of the process air entering the dehumidifier is beyond
       the range that is defined in the performance curve.",
       level=AssertionLevel.error);

    vReg = Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.performanceCurve(
       TProEnt=TProEnt,
       X_w_ProEnt=X_w_ProEnt,
       vPro = vPro,
       a = per.c);
    // We assume a 90deg regeneration air angle and 245deg process air angle.
    mReg_flow = vReg* 90.0 / 245.0 * mPro_flow/vPro;

    // Calculate the outlet condition of the process air.
    TProLea = Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.performanceCurve(
       TProEnt = TProEnt,
       X_w_ProEnt = X_w_ProEnt,
       vPro = vPro,
       a = per.a) + 273.15;
    X_w_ProLea = Buildings.Utilities.Math.Functions.smoothMax(
           x1 = Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.performanceCurve(
           TProEnt = TProEnt,
           X_w_ProEnt = X_w_ProEnt,
           vPro = vPro,
           a = per.b),
           x2 = 0,
           deltaX = 0.01);
    // Calculate the regeneration specific energy.
    hReg = Buildings.Utilities.Math.Functions.smoothMax(
           x1 = Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.performanceCurve(
           TProEnt = TProEnt,
           X_w_ProEnt = X_w_ProEnt,
           vPro = vPro,
           a = per.d)*(per.TRegEnt_nominal- TRegEnt)/(per.TRegEnt_nominal - TProEnt),
           x2 = 0,
           deltaX = 0.01);
  else
    //No dehumidification occurs.
    TProLea = TProEnt;
    X_w_ProLea = X_w_ProEnt;
    mReg_flow = 0;
    hReg = 0;
    vReg = 0;
  end if;
  annotation (
  defaultComponentName="dehPer",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
          points={{-74,-12},{-58,16},{-16,44},{28,44},{58,26},{78,-20}},
          color={28,108,200},
          thickness=0.5)}),
          Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model calculates the outlet conditions of the process air in a desiccant dehumidifier,
along with the required flow rate of the regeneration air and the specific regeneration energy,
based on the inlet conditions. The calculation is set up as follows:
</p>
<ul>
<li>
The velocity of the process air is calculated by:
<p style='text-align:center; font-style:italic;'>
vPro = mPro_flow * vPro_nominal / mPro_flow_nominal,
</p>
where <code>mPro_flow</code> is the mass flow rate of the process air,
<code>mPro_flow_nominal</code> is the nominal mass flow rate of the process air,
and <code>vPro_nominal</code> is the nominal velocity.
</li>
<li>
If the dehumidification signal <code>uRot = true</code> and <code>vPro &gt; 0.1</code>:
<ul>
<li>
The inlet condition is compared to performance curve limits:
<a href='modelica://Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic'>
Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic</a>
<ul>
<li>If out of range, throw an error.</li>
<li>Otherwise:
<ul>
<li>
Temperature leaving: <code>TProLea</code>
<p style='text-align:center; font-style:italic;'>
TProLea = f(TProEnt, X_w_ProEnt, vPro, a) + 273.15,
</p>
</li>
<li>
Humidity ratio: <code>X_w_ProLea</code>
<p style='text-align:center; font-style:italic;'>
X_w_ProLea = max(0, f(TProEnt, X_w_ProEnt, vPro, b)),
</p>
</li>
<li>
Regeneration air velocity:
<p style='text-align:center; font-style:italic;'>
vReg = f(TProEnt, X_w_ProEnt, vPro, c),
</p>
</li>
<li>
Regeneration mass flow rate:
<p style='text-align:center; font-style:italic;'>
mReg_flow = vReg * 90.0 / 245.0 * mPro_flow / vPro,
</p>
</li>
<li>
Regeneration specific energy: <code>hReg</code>
<p style='text-align:center; font-style:italic;'>
hReg = max(0, f(TProEnt, X_w_ProEnt, vPro, d)),
</p>
</li>
</ul>
</li>
</ul>
</li>
</ul>
</li>
<li>
Otherwise:
<ul>
<li>Outlet = inlet condition.</li>
<li><code>mReg_flow</code> and <code>hReg</code> are set to 0.</li>
</ul>
</li>
</ul>
<h4>References</h4>
<ul>
<li>
<a href='https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v22.1.0/EngineeringReference.pdf'>
U.S. Department of Energy, <i>&quot;EnergyPlus Version 22.1.0 Engineering Reference&quot;</i></a>
</li>
<li>
<a href='https://www.ashrae.org/file%20library/technical%20resources/covid-19/i-p_s20_ch26.pdf'>
ASHRAE Handbook—HVAC Systems &amp; Equipment Chapter 26</a>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>July 17, 2025, by Sen Huang:<br/>
First implementation.</li>
</ul>
</html>"));
end Performance;
