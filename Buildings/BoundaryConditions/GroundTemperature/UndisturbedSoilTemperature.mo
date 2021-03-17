within Buildings.BoundaryConditions.GroundTemperature;
model UndisturbedSoilTemperature
  parameter Modelica.SIunits.Length dep "Depth";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat "Soil thermal properties";
  replaceable parameter ClimaticConstants.Generic cliCon "Surface temperature climatic conditions";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port "Boundary heat port";
protected
  constant Modelica.SIunits.Angle pi = Modelica.Constants.pi;
  constant Modelica.SIunits.Duration Year = 365.2422*24*60*60 "Annual period length";

  parameter Modelica.SIunits.ThermalDiffusivity soiDif = soiDat.k / soiDat.c / soiDat.d "Soil diffusivity";
  parameter Modelica.SIunits.Duration timLag = cliCon.sinPhaDay*24*60*60 "Start time of surface temperature sinusoid";
  parameter Real pha = - dep * (pi/soiDif/Year)^0.5 "Phase angle of ground temperature sinusoid";

equation
  port.T = cliCon.TMeaSur + cliCon.TSurAmp * exp(pha) * sin(2*pi*(time-timLag)/Year - pha);
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
        coordinateSystem(preserveAspectRatio=false)));
end UndisturbedSoilTemperature;
