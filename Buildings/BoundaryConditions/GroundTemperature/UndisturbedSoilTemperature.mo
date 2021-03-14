within Buildings.BoundaryConditions.GroundTemperature;
model UndisturbedSoilTemperature
  parameter Modelica.SIunits.Length z "Depth";

  parameter Modelica.SIunits.ThermalDiffusivity soiDif "Soil thermal diffusivity";

  parameter Modelica.SIunits.Temperature TMeaSur "Mean annual surface temperature";
  parameter Modelica.SIunits.TemperatureDifference TSurAmp "Surface temperature amplitude";
  parameter Modelica.SIunits.Duration timLag(displayUnit="d") "Phase lag of soil surface temperature";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port
    annotation (Placement(transformation(extent={{-6,-104},{6,-92}}),
        iconTransformation(extent={{-6,-104},{6,-92}})));
protected
  constant Modelica.SIunits.Duration yea = 365.2422*24*60*60 "Annual period length";
  constant Modelica.SIunits.Angle pi = Modelica.Constants.pi;
  Real pha = - z * (pi/soiDif/yea)^0.5 "Temperature sinusoid phase";

equation
  port.T = TMeaSur + TSurAmp * exp(pha) * sin(2*pi*(time-timLag)/yea - pha);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,20},{100,-100}},
          lineColor={0,0,0},
          fillColor={122,20,25},
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
          thickness=0.5),
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
