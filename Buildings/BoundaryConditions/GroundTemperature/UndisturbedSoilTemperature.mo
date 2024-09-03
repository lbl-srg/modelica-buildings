within Buildings.BoundaryConditions.GroundTemperature;
model UndisturbedSoilTemperature "Undisturbed soil temperature"
  parameter Modelica.Units.SI.Length dep "Depth";

  parameter Boolean useNFac = false
    "= true, use n-factors to correct climatic constants";
  parameter Real nFacTha = 1 "Thawing n-factor (TAir > 0degC)"
    annotation(Dialog(enable=useNFac));
  parameter Real nFacFre = 1 "Freezing n-factor (TAir <= 0degC)"
    annotation(Dialog(enable=useNFac));

  parameter Boolean useCon = false
    "= true, includes convection between air and surface coupling";
  parameter Real hSur(unit="W/(m2.K)", min=0) = 25
    "Surface convective heat transfer coefficient"
    annotation(Dialog(enable=useCon));

  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic
    soiDat "Soil thermal properties";
  replaceable parameter ClimaticConstants.Generic
    cliCon "Surface temperature climatic conditions";

  Modelica.Units.SI.Temperature T "Undisturbed soil temperature at depth dep";

protected
  constant Modelica.Units.SI.Angle pi=Modelica.Constants.pi;
  constant Modelica.Units.SI.Duration Year=365.2422*24*60*60
    "Annual period length";

  parameter Modelica.Units.SI.Length corDep=if useCon then dep + soiDat.k/hSur
       else dep "Convection-corrected depth";
  parameter ClimaticConstants.Generic corCliCon= if useNFac
    then BaseClasses.surfaceTemperature(cliCon=cliCon, nFacTha=nFacTha, nFacFre=nFacFre)
    else cliCon
    "<i>n</i>-factor corrected climatic constants";

  parameter Modelica.Units.SI.ThermalDiffusivity soiDif=soiDat.k/soiDat.c/
      soiDat.d "Soil diffusivity";
  parameter Modelica.Units.SI.Duration timLag=corCliCon.sinPha
    "Start time of surface temperature sinusoid";
  parameter Real pha = - corDep * (pi/soiDif/Year)^0.5
    "Phase angle of ground temperature sinusoid";

initial equation
  assert(not (useCon and useNFac),
    "N-Factors and surface convection corrections
    would typically not be used simultaneously",
    level = AssertionLevel.warning);

equation
  T = corCliCon.TSurMea + corCliCon.TSurAmp * exp(pha) *
    sin(2*pi*(time-timLag)/Year + pha);
    annotation (Placement(transformation(extent={{-6,-104},{6,-92}}),
        iconTransformation(extent={{-6,-104},{6,-92}})),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,20},{100,-100}},
          lineColor={0,0,0},
          fillColor={211,168,137},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,20},{100,26}},
          lineColor={0,0,0},
          fillColor={0,255,128},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,26},{100,100}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,38},{0,-60}},
          color={191,0,0},
          thickness=1),
        Polygon(
          points={{16,-60},{-16,-60},{0,-92},{16,-60}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-38,-38},{-100,-100}},
          textColor={0,0,0},
          textString="K")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model provides a prescribed temperature boundary condition for buried objects,
where the temperature is computed per the ASCE (1996) equation:
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/BoundaryConditions/GroundTemperature/UndisturbedSoilTemperature.svg\" />
</p>
<p>
where: <br>
<i>T<sub>s,z</sub></i> = ground temperature at depth <i>z</i>,<br>
<i>&tau;</i> = annual period length (constant 365.25 days),<br>
<i>&alpha;</i> = soil thermal diffusivity (assumed constant throughout the year), <br>
<i>t</i> = time, <br>
<i>T<sub>ms</sub></i> = mean annual surface temperature, <br>
<i>A<sub>s</sub></i> = temperature amplitude throughout the year (max - min), <br>
<i>t<sub>lag</sub></i> = phase lag of the surface temperature sinusoid
</p>

<h4>Corrections</h4>

<p>
Without correction, this model assumes that the surface temperature (depth = 0) is
equal to the air temperature, which is acceptable for most design calculations.<br>
For more accurate calculation, this model provides methods to compensate for
the convective thermal resistance and the impact of surface cover.
</p>
<p>
The convective thermal resistance can be modeled as a virtual equivalent soil layer
by setting the flag <i>useCon</i> to <code>true</code> and specifying the
heat transfer coefficient <i>hSur</i>.<br/>
This correction would result in a larger delay and dampening of the
resulting sinusoid.
</p>
<p>
The impact of surface cover on soil temperature can be modeled using
<i>n</i>-factors by setting the flag <i>useNFac</i> to <code>true</code> and
specifying the thawing and freezing <i>n</i>-factors at the surface. <br>

More information about <i>n</i>-factors correction can be found in the documentation
for <a href=\"modelica://Buildings.BoundaryConditions.GroundTemperature.BaseClasses.surfaceTemperature\">
Buildings.BoundaryConditions.GroundTemperature.BaseClasses.surfaceTemperature</a>.
</p>
<p>
Since <i>n</i>-factors incorporate the effect of surface convection,
both corrections would typically not be applied simultaneously. <br>
</p>

<h4>References</h4>
<p>
ASCE (1996). <i>Cold Regions Utilities Monograph</i>. D.W. Smith, Technical Editor.
</p>

</html>", revisions="<html>
<ul>
<li>
March 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end UndisturbedSoilTemperature;
