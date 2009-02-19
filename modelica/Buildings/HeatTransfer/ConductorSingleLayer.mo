within Buildings.HeatTransfer;
model ConductorSingleLayer "Model for single layer heat conductance"
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,102},{100,-98}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,2},{90,-2}},
          lineColor={0,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,10},{-40,10},{-38,6},{-36,0},{-36,-4},{-38,-10},{-44,-14},
              {-48,-18},{-56,-20},{-60,-16},{-66,-10},{-68,0},{-66,6},{-64,10},
              {-62,12},{-60,14},{-56,16},{-52,16},{-46,14},{-42,10}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,-14},{-52,-16},{-46,-14},{-40,-12},{-44,-14},{-48,-18},{
              -56,-20},{-62,-18},{-66,-10},{-68,0},{-66,6},{-64,10},{-62,12},{-64,
              2},{-64,-6},{-60,-14}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{72,10},{74,10},{76,6},{78,0},{78,-4},{76,-10},{70,-14},{66,-18},
              {58,-20},{54,-16},{48,-10},{46,0},{48,6},{50,10},{52,12},{54,14},
              {58,16},{62,16},{68,14},{72,10}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{54,-14},{62,-16},{68,-14},{74,-12},{70,-14},{66,-18},{58,-20},
              {52,-18},{48,-10},{46,0},{48,6},{50,10},{52,12},{50,2},{50,-6},{
              54,-14}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,82},{18,-78}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward)}),
    Documentation(info="<html>
This is a model of a heat conductor with energy storage.
The construction has <tt>n>1</tt> state variables, of which one is located
at each of the surfaces. 
The thickness of the construction is divided into <tt>n-1</tt> layers
that conduct heat between the states.
To build multi-layer constructions, one instance of this model can be made
for each layer, and the layers can be connected with each other. A Modelica
translator should then collapse the state variables at the surfaces of two
adjacent layers into one state variable.
</html>", revisions="<html>
<ul>
<li>
February 5 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  parameter Modelica.SIunits.Length x "Construction thickness";
  parameter Modelica.SIunits.Area A "Heat transfer area";
  parameter Integer n = 2 "Number of states";
  parameter Buildings.HeatTransfer.Data.Solids mat "Construction material" 
annotation (choicesAllMatching=true);
  Modelica.SIunits.TemperatureDifference dT "port_a.T - port_b.T";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b annotation (Placement(transformation(extent={{90,-10},{
            110,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap[n](
      each C(fixed=false)) "Model for heat capacity" 
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor con[n-1](
     each G = A*mat.k/(x/(n-1))) "Model for heat conductance" 
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  final parameter Modelica.SIunits.CoefficientOfHeatTransfer U = mat.k/x
    "U-value (without surface heat transfer coefficients)";
  final parameter Modelica.SIunits.ThermalConductance G = U*A
    "Thermal conductance of construction";
  final parameter Modelica.SIunits.ThermalResistance R = 1/G
    "Thermal conductance of construction";
initial equation
  // nodes at surface have only 1/2 the layer thickness
  cap[1].C = A * x/(n-1) * mat.d * mat.c / 2;
  cap[n].C = cap[1].C;
  for i in 2:n-1 loop
    cap[i].C = A * x/(n-1) * mat.d * mat.c;
  end for;
equation
   dT = port_a.T - port_b.T;
  connect(port_a, cap[1].port) annotation (Line(
      points={{-100,0},{-40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  for i in 1:n-1 loop
    connect(cap[i].port, con[i].port_a) annotation (Line(
      points={{-40,0},{0,0}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(con[i].port_b, cap[i+1].port) annotation (Line(
      points={{20,0},{40,0},{40,-20},{-40,-20},{-40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  end for;
  connect(cap[n].port, port_b)   annotation (Line(
      points={{-40,0},{100,0}},
      color={191,0,0},
      smooth=Smooth.None));
end ConductorSingleLayer;
