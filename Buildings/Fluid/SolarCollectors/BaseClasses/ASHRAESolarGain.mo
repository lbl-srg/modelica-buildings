within Buildings.Fluid.SolarCollectors.BaseClasses;
block ASHRAESolarGain
  "Calculate the solar heat gain of a solar collector per ASHRAE Standard 93"
  extends Modelica.Blocks.Icons.Block;
  extends SolarCollectors.BaseClasses.PartialParameters;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the system";

  parameter Real B0 "1st incident angle modifer coefficient";
  parameter Real B1 "2nd incident angle modifer coefficient";
  parameter Boolean use_shaCoe_in = false "Enable input connector for shaCoe"
    annotation(Dialog(group="Shading"));

  parameter Real shaCoe(
    min=0.0,
    max=1.0) = 0 "Shading coefficient 0.0: no shading, 1.0: full shading"
    annotation(Dialog(enable = not use_shaCoe_in, group = "Shading"));

  parameter Modelica.SIunits.Angle til "Surface tilt";

  Modelica.Blocks.Interfaces.RealInput shaCoe_in if use_shaCoe_in
    "Shading coefficient"
    annotation(Placement(transformation(extent={{-140,-70},{-100,-30}})));
   Modelica.Blocks.Interfaces.RealInput TFlu[nSeg](
   each unit = "K",
   each displayUnit="degC",
   each quantity="ThermodynamicTemperature")
   annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
   Modelica.Blocks.Interfaces.RealInput HSkyDifTil(
     unit="W/m2", quantity="RadiantEnergyFluenceRate")
    "Diffuse solar irradiation on a tilted surfce from the sky"
     annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput HGroDifTil(
    unit="W/m2", quantity="RadiantEnergyFluenceRate")
    "Diffuse solar irradiation on a tilted surfce from the ground"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}})));
  Modelica.Blocks.Interfaces.RealInput incAng(
    quantity="Angle",
    unit="rad",
    displayUnit="degree") "Incidence angle of the sun beam on a tilted surface"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput HDirTil(
    unit="W/m2", quantity="RadiantEnergyFluenceRate")
    "Direct solar irradiation on a tilted surfce"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealOutput QSol_flow[nSeg](each final unit="W")
    "Solar heat gain"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  constant Modelica.SIunits.TemperatureDifference dTMax = 1
    "Safety temperature difference to prevent TFlu > Medium.T_max";
  final parameter Modelica.SIunits.Temperature TMedMax = Medium.T_max-dTMax
    "Fluid temperature above which there will be no heat gain computed to prevent TFlu > Medium.T_max";
  final parameter Modelica.SIunits.Temperature TMedMax2 = TMedMax-dTMax
    "Fluid temperature below which there will be no heat loss computed to prevent TFlu < Medium.T_min";

  final parameter Real iamSky(fixed = false)
    "Incident angle modifier for diffuse solar radiation from the sky";
  final parameter Real iamGro(fixed = false)
    "Incident angle modifier for diffuse solar radiation from the ground";
  final parameter Modelica.SIunits.Angle incAngSky(fixed = false)
    "Incident angle of diffuse radiation from the sky";
  final parameter Modelica.SIunits.Angle incAngGro(fixed = false)
    "Incident angle of diffuse radiation from the ground";
  final parameter Real tilDeg(
    unit = "deg") = Modelica.SIunits.Conversions.to_deg(til)
    "Surface tilt angle in degrees";
  final parameter Modelica.SIunits.HeatFlux HTotMin = 1
    "Minimum HTot to avoid div/0";
  final parameter Real HMinDel = 0.001
    "Delta of the smoothing function for HTot";

  Real iamBea "Incident angle modifier for director solar radiation";
  Real iam "Weighted incident angle modifier";

  Modelica.Blocks.Interfaces.RealInput shaCoe_internal
    "Internally used shading coefficient";

initial equation
  // E+ Equ (557)
  incAngSky = Modelica.SIunits.Conversions.from_deg(59.68 - 0.1388*(tilDeg) +
  0.001497*(tilDeg)^2);
  // Diffuse radiation from the sky
  // E+ Equ (555)
  iamSky = SolarCollectors.BaseClasses.IAM(incAngSky, B0, B1);
  // E+ Equ (558)
  incAngGro = Modelica.SIunits.Conversions.from_deg(90 - 0.5788*(tilDeg)+
  0.002693*(tilDeg)^2);
  // Diffuse radiation from the ground
  // E+ Equ (555)
  iamGro = SolarCollectors.BaseClasses.IAM(
    incAngGro,
    B0,
    B1);

equation

  connect(shaCoe_internal, shaCoe_in);

  if not use_shaCoe_in then
    shaCoe_internal = shaCoe;
  end if;

  // E+ Equ (555)
  iamBea = Buildings.Utilities.Math.Functions.smoothHeaviside(1/3*
  Modelica.Constants.pi- incAng, Modelica.Constants.pi/60)*
  SolarCollectors.BaseClasses.IAM(
    incAng,
    B0,
    B1);
  // E+ Equ (556)
  iam = Buildings.Utilities.Math.Functions.smoothHeaviside(
      1/3*Modelica.Constants.pi-incAng,Modelica.Constants.pi/60)*
      ((HDirTil*iamBea + HSkyDifTil*iamSky + HGroDifTil*iamGro)/
      Buildings.Utilities.Math.Functions.smoothMax((HDirTil +
      HSkyDifTil + HGroDifTil), HTotMin, HMinDel));
  // Modified from EnergyPlus Equ (559) by applying shade effect for
  //direct solar radiation
  // Only solar heat gain is considered here
  for i in 1 : nSeg loop
    QSol_flow[i] = A_c/nSeg*(y_intercept*iam*(HDirTil*(1.0 -
    shaCoe_internal) + HSkyDifTil + HGroDifTil))*
      smooth(1, if TFlu[i] < TMedMax2
        then 1
        else Buildings.Utilities.Math.Functions.smoothHeaviside(TMedMax-TFlu[i], dTMax));
  end for;

  annotation (
    defaultComponentName="solGai",
    Documentation(info="<html>
      <p>
        This component computes the solar heat gain of the solar thermal collector.
        It only calculates the solar heat gain without considering the heat loss
        to the environment. This model uses ratings data according to ASHRAE93.
        The solar heat gain is calculated using Equations 555 - 559 in the referenced
        EnergyPlus documentation.
      </p>
      <p>
        The solar radiation absorbed by the panel is identified using Eq 559 from
        the EnergyPlus documentation. It is
      </p>
      <p align=\"center\" style=\"font-style:italic;\">
        Q<sub>Flow</sub>[i]=A<sub>c</sub>/nSeg (F<sub>R</sub>(&tau;&alpha;)
          K<sub>(&tau;&alpha;)<sub>net</sub></sub> (G<sub>Dir</sub>
          (1-shaCoe)+G<sub>Dif,Sky</sub>+G<sub>Dif,Gnd</sub>))
      </p>
      <p>
        where <i>Q<sub>Flow</sub>[i]</i> is the heat gain in each segment, <i>A<sub>
        c</sub></i> is the area of the collector, <i>nSeg</i> is the user-specified
        number of segments in the simulation, <i>F<sub>R</sub>(&tau;&alpha;)</i> is
        the maximum collector efficiency, <i>K<sub>(&tau;&alpha;)<sub>net</sub>
        </sub></i> is the incidence angle modifier, <i>G<sub>Dir</sub></i> is the
        direct solar radiation, <i>shaCoe</i> is the user-specified shading
        coefficient, <i>G<sub>Dif,Sky</sub></i> is the diffuse solar radiation from
        the sky, and <i>G<sub>Dif,Gnd</sub></i> is the diffuse radiation from the
        ground.
      </p>
      <p>
        The solar radiation equation indicates that the collector is divided into
        multiple segments. The number of segments used in the simulation is specified
        by the user (parameter: <code>nSeg</code>). The area of an individual segment
        is identified by dividing the collector area by the total number of segments.
        The term <code>shaCoe</code> is used to define the percentage of the collector
        that is shaded.
      </p>
      <p>
        The incidence angle modifier used in the solar radiation equation is found using
        Eq 556 from the EnergyPlus documentation. It is
      </p>
      <p align=\"center\" style=\"font-style:italic;\">
        K<sub>(&tau;&alpha;),net</sub>=(G<sub>Beam</sub> K<sub>(&tau;&alpha;),
          Beam</sub>+G<sub>Dif,Sky</sub> K<sub>(&tau;&alpha;),Sky</sub>+G<sub>Dif,Gnd</sub>
          K<sub>(&tau;&alpha;),Gnd</sub>) / (G<sub>beam</sub>+G<sub>Dif,Sky</sub>+G<sub>
          Dif,Gnd</sub>)
      </p>
      <p>
        where <i>K<sub>(&tau;&alpha;),net</sub></i> is the net incidence angle modified,
        <i>G<sub>Beam</sub></i> is the beam radiation, <i>K<sub>(&tau;&alpha;),Beam</sub>
        </i> is the incidence angle modifier for beam radiation, <i>G<sub>Dif,Sky</sub></i>
        is the diffuse radiation from the sky, <i>K<sub>(&tau;&alpha;),Sky</sub></i> is the
        incidence angle modifier for radiation from the sky, <i>G<sub>Dif, Gnd</sub></i> is
        the diffuse radiation from the ground, and <i>K<sub>(&tau;&alpha;),Gnd</sub></i> is
        the incidence angle modifier for diffuse radiation from the ground.
      </p>
      <p>
        Each incidence angle modifier is calculated using Eq 555 from the EnergyPlus
        documentation. It is
      </p>
      <p align=\"center\" style=\"font-style:italic;\">
        K<sub>(&tau;&alpha;),x</sub>=1+b<sub>0</sub> (1/cos(&theta;)-1)+b<sub>1</sub>
          (1/cos(&theta;)-1)<sup>2</sup>
      </p>
      <p>
        where x can refer to beam, sky or ground. <i>&theta;</i> is
        the incidence angle. For beam radiation <i>&theta;</i> is found via standard
        geometry. The incidence angle for sky and ground diffuse radiation are found
        using, respectively, Eq 557 and 558 from the EnergyPlus documentation. They are
      </p>
      <p align=\"center\" style=\"font-style:italic;\">
        &theta;<sub>sky</sub>=59.68-0.1388 til+0.001497 til<sup>2</sup><br/>
        &theta;<sub>gnd</sub>=90.0-0.5788 til+0.002693 til<sup>2</sup>
      </p>
      <p>
        where <i>&theta;<sub>sky</sub></i> is the incidence angle for diffuse radiation from the
        sky, <i>til</i> is the tilt of the solar thermal collector, and <i>&theta;<sub>gnd</sub></i>
        is the incidence angle for diffuse radiation from the ground.
      </p>
      <p>
        These two equations must be evaluated in degrees. The necessary unit conversions are made
        internally.
      </p>
      <p>
        This model reduces the heat gain rate to 0 W when the fluid temperature is within 1 degree
        C of the maximum temperature of the medium model. The calucation is performed using the
        <a href=\"modelica://Buildings.Utilities.Math.Functions.smoothHeaviside\">
        Buildings.Utilities.Math.Functions.smoothHeaviside</a> function.
      </p>
    <h4>References</h4>
      <p>
      <a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>,
        October 13, 2011.<br/>
      ASHRAE 93-2010 -- Methods of Testing to Determine the Thermal Performance of Solar
        Collectors (ANSI approved)
      </p>
    </html>",
    revisions="<html>
    <ul>
<li>
September 17, 2016, by Michael Wetter:<br/>
Corrected quantity from <code>Temperature</code> to <code>ThermodynamicTemperature</code>
to avoid an error in the pedantic model check in Dymola 2017 FD01 beta2.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/557\">issue 557</a>.
</li>
<li>
June 29, 2015, by Michael Wetter:<br/>
Revised implementation of heat loss near <code>Medium.T_max</code>
to make it more efficient.
</li>
<li>
June 29, 2015, by Filip Jorissen:<br/>
Fixed sign mistake causing model to fail under high
solar irradiation because temperature goes above medium
temperature bound.
</li>
<li>
November 20, 2014, by Michael Wetter:<br/>
Added missing <code>each</code> keyword.
</li>
<li>
Jan 15, 2013, by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"));
end ASHRAESolarGain;
