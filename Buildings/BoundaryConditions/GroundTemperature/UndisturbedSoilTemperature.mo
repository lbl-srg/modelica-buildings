within Buildings.BoundaryConditions.GroundTemperature;
model UndisturbedSoilTemperature "Undisturbed soil temperature"
  parameter Modelica.SIunits.Length dep "Depth";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic
    soiDat "Soil thermal properties";
  replaceable parameter ClimaticConstants.Generic
    cliCon "Surface temperature climatic conditions";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b
    port "Boundary heat port";
protected
  constant Modelica.SIunits.Angle pi = Modelica.Constants.pi;
  constant Modelica.SIunits.Duration Year = 365.2422*24*60*60
    "Annual period length";

  parameter Modelica.SIunits.ThermalDiffusivity
    soiDif = soiDat.k / soiDat.c / soiDat.d "Soil diffusivity";
  parameter Modelica.SIunits.Duration
    timLag = cliCon.sinPhaDay*24*60*60
    "Start time of surface temperature sinusoid";
  parameter Real pha = - dep * (pi/soiDif/Year)^0.5
    "Phase angle of ground temperature sinusoid";

equation
  port.T = cliCon.TSurMea + cliCon.TSurAmp * exp(pha) *
    sin(2*pi*(time-timLag)/Year + pha);
    annotation (Placement(transformation(extent={{-6,-104},{6,-92}}),
        iconTransformation(extent={{-6,-104},{6,-92}})),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          lineColor={0,0,255},
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
          lineColor={0,0,0},
          textString="K")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model provides a prescribed temperature boundary counditions for buried objects,
where the temperature is computed per the ASCE (1996) equation:
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/BoundaryConditions/GroundTemperature/UndisturbedGroundTemperature.svg\" />
</p>
<p>
where: <br>
<i>T<sub>s,z</sub></i> = ground temperature at depth <i>z</i>,<br>
<i>&tau;</i> = annual period length (constant 365.25 days),<br>
<i>&alpha;</i> = soil thermal diffusivity, <br>
<i>t</i> = time, <br>
<i>T<sub>ms</sub></i> = mean annual surface temperature<br>
<i>A<sub>s</sub></i> = temperature amplitude throughout the year (max - min) 
<i>t<sub>lag</sub></i> = phase lag of the surface temperature sinusoid
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
