within Buildings.HeatTransfer;
model ConstructionOpaque
  "Model for an opaque construction such as a wall, floor or ceiling"
  extends Buildings.BaseClasses.BaseIcon;
  extends Buildings.HeatTransfer.BaseClasses.PartialConstruction;

  parameter Buildings.RoomsBeta.Types.ConvectionModel conMod=
    Buildings.RoomsBeta.Types.ConvectionModel.Fixed
    "Convective heat transfer model"
  annotation(Evaluate=true);
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hFixed=3
    "Constant convection coefficient"
    annotation (Dialog(enable=(conMod == Buildings.RoomsBeta.Types.ConvectionModel.fixed)));
  parameter Modelica.SIunits.Angle til(displayUnit="deg") "Surface tilt"
    annotation (Dialog(enable= not (conMod == Buildings.RoomsBeta.Types.ConvectionModel.fixed)));

  parameter Modelica.SIunits.Area A "Heat transfer area";

  final parameter Modelica.SIunits.CoefficientOfHeatTransfer U = UA/A
    "U-value (without surface heat transfer coefficients)";
  final parameter Modelica.SIunits.ThermalConductance UA = 1/R
    "Thermal conductance of construction (without surface heat transfer coefficients)";
  final parameter Modelica.SIunits.ThermalResistance R = solid.R + 1/A/hCon_a_start + 1/A/hCon_b_start
    "Thermal resistance of construction";
  ConductorMultiLayer solid(
    final A=A,
    final layers=layers,
    final steadyStateInitial=steadyStateInitial,
    T_a_start= T_b_start + (T_a_start - T_b_start)/R/(A*hCon_a_start),
    T_b_start= T_a_start + (T_b_start - T_a_start)/R/(A*hCon_b_start))
    "Model for opaque construction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.SIunits.TemperatureDifference dT "port_a.T - port_b.T";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "Heat port at outside of air boundary layer near surface a"                       annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    "Heat port at outside of air boundary layer near surface b"                       annotation (Placement(transformation(extent={{90,-10},{
            110,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surf_a
    "Heat port at surface a"                                                          annotation (Placement(transformation(extent={{-30,30},
            {-10,50}}, rotation=0), iconTransformation(extent={{-64,54},{-44,74}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surf_b
    "Heat port at surface b"                                                          annotation (Placement(transformation(extent={{10,30},
            {30,50}}, rotation=0), iconTransformation(extent={{44,54},{64,74}})));
  Convection con_a(final A=A,
    final conMod=conMod,
    final hFixed=hFixed,
    final til=Modelica.Constants.pi - til)
    "Convective heat transfer at surface a"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Convection con_b(final A=A,
    final conMod=conMod,
    final hFixed=hFixed,
    final til=til) "Convective heat transfer at surface b"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  parameter Modelica.SIunits.CoefficientOfHeatTransfer hCon_a_start=3
    "Convective heat transfer coefficient on side a, used to compute initial condition"
    annotation (Dialog(tab="Advanced"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hCon_b_start=hCon_a_start
    "Convective heat transfer coefficient on side b, used to compute initial condition"
    annotation (Dialog(tab="Advanced"));
equation
  dT = port_a.T - port_b.T;
  connect(port_a, con_a.fluid) annotation (Line(
      points={{-100,5.55112e-16},{-91,5.55112e-16},{-91,6.10623e-16},{-80,
          6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(con_a.solid, solid.port_a) annotation (Line(
      points={{-60,6.10623e-16},{-36,-3.36456e-22},{-36,6.10623e-16},{-10,
          6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solid.port_b, con_b.solid) annotation (Line(
      points={{10,6.10623e-16},{36,-3.36456e-22},{36,6.10623e-16},{60,
          6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(con_b.fluid, port_b) annotation (Line(
      points={{80,6.10623e-16},{88,6.10623e-16},{88,5.55112e-16},{100,
          5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(solid.port_a, surf_a) annotation (Line(
      points={{-10,6.10623e-16},{-20,6.10623e-16},{-20,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solid.port_b, surf_b) annotation (Line(
      points={{10,6.10623e-16},{16,0},{20,0},{20,40}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-54,82},{-36,-52}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Forward),
        Rectangle(
          extent={{-36,82},{4,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{4,82},{54,-52}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.CrossDiag),
        Line(points={{-66,70},{-66,-36}}, color={0,127,255}),
        Line(points={{-66,-36},{-72,-28}}, color={0,127,255}),
        Line(points={{-66,-36},{-60,-28}}, color={0,127,255}),
        Line(points={{-82,-36},{-88,-28}}, color={0,127,255}),
        Line(points={{-82,-36},{-76,-28}}, color={0,127,255}),
        Line(points={{-82,70},{-82,-36}}, color={0,127,255}),
        Line(points={{66,-34},{60,-26}}, color={0,127,255}),
        Line(points={{66,-34},{72,-26}}, color={0,127,255}),
        Line(points={{66,72},{66,-34}}, color={0,127,255}),
        Line(points={{82,72},{82,-34}}, color={0,127,255}),
        Line(points={{82,-34},{76,-26}}, color={0,127,255}),
        Line(points={{82,-34},{88,-26}}, color={0,127,255}),
        Text(
          extent={{-98,-68},{98,-90}},
          lineColor={0,0,255},
          textString="A=%A")}),
    defaultComponentName="conOpa",
    Documentation(info="<html>
This is a model for a construction that does not transmit light.
The construction can consist of one or more layers of material. Inside
the material, one-dimensional heat conduction is computed.
The heat conduction is computed dynamic, taking into account
the energy storage of the material, or steady-state.
Steady-state heat conduction is computed if the specific heat capacity
of the material is zero.
At each surface of the material, there is a convective heat transfer 
coefficient, which can be configured to be
use various functions from the package
<a href=\"modelica://Buildings.HeatTransfer.Functions.ConvectiveHeatFlux\">
Buildings.HeatTransfer.Functions.ConvectiveHeatFlux</a>.
</p>
<p>
The model has a parameter <code>til</code> that is used as the surface tilt.
Because in the room model
<a href=\"modelica://Buildings.RoomsBeta\">
Buildings.RoomsBeta</a>, the surface <code>a</code> faces the exterior and 
the surface <code>b</code> faces the room air, the parameter <code>til</code>
is used as follows:
<table border=\"1\">
<tr>
<th>Value of parameter <code>til</code></th>
<th>Surface a</th>
<th>Surface b</th>
</tr>
<tr>
<td><code>Buildings.RoomsBeta.Types.Tilt.Ceiling</code></td>
<td>floor (facing the exterior)</td>
<td>ceiling (facing the room)</td>
<tr>
<td><code>Buildings.RoomsBeta.Types.Tilt.Floor</code></td>
<td>ceiling (facing the exterior)</td>
<td>floor (facing the room)</td>
</tr>
</tr>
</p>
<p>
To compute heat conduction in the solid, this model uses an instance of
<a href=\"modelica://Buildings.HeatTransfer.ConductorMultiLayer\">
Buildings.HeatTransfer.ConductorMultiLayer</a>.
See <a href=\"modelica://Buildings.HeatTransfer.ConductorMultiLayer\">
Buildings.HeatTransfer.ConductorMultiLayer</a> for how to define constructions
that can be used with this model.
The convective heat transfer is
computed using the model
<a href=\"modelica://Buildings.HeatTransfer.Convection\">
Buildings.HeatTransfer.Convection</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ConstructionOpaque;
