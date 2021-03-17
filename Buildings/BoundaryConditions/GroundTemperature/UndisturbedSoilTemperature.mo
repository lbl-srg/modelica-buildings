within Buildings.BoundaryConditions.GroundTemperature;
model UndisturbedSoilTemperature
  parameter Modelica.SIunits.Length depth "Depth";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soil "Soil thermal properties";
  replaceable parameter ClimaticConstants.Generic climate "Surface temperature climatic conditions";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port "Boundary heat port";
protected
  constant Modelica.SIunits.Duration yea = 365.2422*24*60*60 "Annual period length";
  constant Modelica.SIunits.Angle pi = Modelica.Constants.pi;
  Modelica.SIunits.ThermalDiffusivity soiDif = soil.k / soil.c / soil.d "Soil diffusivity";
  Modelica.SIunits.Duration timLag = climate.sinPhaDay*24*60*60 "Start time of surface temperature sinusoid";
  Real pha = - depth * (pi/soiDif/yea)^0.5 "Phase angle of ground temperature sinusoid";

equation
  port.T = climate.TMeaSur + climate.TSurAmp * exp(pha) * sin(2*pi*(time-timLag)/yea - pha);
    annotation (Placement(transformation(extent={{-6,-104},{6,-92}}),
        iconTransformation(extent={{-6,-104},{6,-92}})),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,20},{100,-100}},
          lineColor={0,0,0},
          fillColor={211,168,137},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,20},{100,26}},
          lineColor={0,0,0},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,26},{100,100}},
          lineColor={0,0,0},
          fillColor={28,108,200},
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
