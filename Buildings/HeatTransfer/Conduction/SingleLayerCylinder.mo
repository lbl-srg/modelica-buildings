within Buildings.HeatTransfer.Conduction;
model SingleLayerCylinder "Heat conduction in a cylinder"
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic material
    "Material thermal properties"
  annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Height h "Height of the cylinder";
  parameter Modelica.Units.SI.Radius r_a "Internal radius";
  parameter Modelica.Units.SI.Radius r_b "External radius";
  parameter Integer nSta(min=1) "Number of state variables";
  parameter Modelica.Units.SI.Temperature TInt_start=293.15
    "Initial temperature at port_a, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Modelica.Units.SI.Temperature TExt_start=293.15
    "Initial temperature at port_b, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Boolean steadyStateInitial=false
    "true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using T_a_start and T_b_start"
     annotation (Dialog(group="Initialization"), Evaluate=true);

  parameter Real griFac(min=1) = 2 "Grid factor for spacing";

  Modelica.Units.SI.TemperatureDifference dT "port_a.T - port_b.T";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "Heat port at surface a" annotation (Placement(transformation(extent={{-110,-10},
            {-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
    "Heat port at surface b" annotation (Placement(transformation(extent={{90,-10},{
            110,10}})));

  Modelica.Units.SI.Temperature T[nSta](start={TInt_start + (TExt_start -
        TInt_start)/Modelica.Math.log(r_b/r_a)*Modelica.Math.log((r_a + (r_b -
        r_a)/(nSta)*(i - 0.5))/r_a) for i in 1:nSta})
    "Temperature of the states";
  Modelica.Units.SI.HeatFlowRate Q_flow[nSta + 1]
    "Heat flow rate from state i to i+1";

//  Modelica.Units.SI.TemperatureSlope der_T[nSta]
//    "Time derivative of temperature (= der(T))";
protected
  parameter Modelica.Units.SI.Radius r[nSta + 1](each fixed=false)
    "Radius to the boundary of the i-th domain";
  parameter Modelica.Units.SI.Radius rC[nSta](each fixed=false)
    "Radius to the center of the i-th domain";

  final parameter Modelica.Units.SI.SpecificHeatCapacity c=material.c
    "Specific heat capacity";
  final parameter Modelica.Units.SI.ThermalConductivity k=material.k
    "Thermal conductivity of the material";
  final parameter Modelica.Units.SI.Density d=material.d
    "Density of the material";

  parameter Modelica.Units.SI.ThermalConductance G[nSta + 1](each fixed=false)
    "Heat conductance between the temperature nodes";
  parameter Modelica.Units.SI.HeatCapacity C[nSta](each fixed=false)
    "Heat capacity of each state";

initial equation
  assert(r_a < r_b, "Error: Model requires r_a < r_b.");
  assert(0 < r_a,   "Error: Model requires 0 < r_a.");
  r[1] = r_a;
  for i in 2:nSta+1 loop
     r[i]= r[i-1] + ( r_b - r_a)  * (1-griFac)/(1-griFac^(nSta)) * griFac^(i-2);
  end for;

  // Radii to the center of the domain
  for i in 1:nSta loop
    rC[i] = (r[i]+r[i+1])/2;
  end for;
  // Conductance between nodes (which are in the center of the domain)
  G[1]      = 2*Modelica.Constants.pi*k*h/Modelica.Math.log(rC[1]/r_a);
  G[nSta+1] = 2*Modelica.Constants.pi*k*h/Modelica.Math.log(r_b/rC[nSta]);
  for i in 2:nSta loop
    G[i]      = 2*Modelica.Constants.pi*k*h/Modelica.Math.log(rC[i]/rC[i-1]);
  end for;

  // Heat capacity of each segment
  for i in 1:nSta loop
   C[i] = (d*Modelica.Constants.pi*c*h*((r[i+1])^2-(r[i])^2));
  end for;
  // The initialization is only done for materials that store energy.
  if not material.steadyState then
    if steadyStateInitial then
      der(T) = zeros(nSta);
    else
      for i in 1:nSta loop
        T[i]=TInt_start+ (TExt_start-TInt_start)/Modelica.Math.log(r_b/r_a) * Modelica.Math.log(rC[i]/r_a);
      end for;
    end if;
  end if;
equation
  dT = port_a.T - port_b.T;
  port_a.Q_flow = +Q_flow[1];
  port_b.Q_flow = -Q_flow[nSta+1];
  Q_flow[1]      = G[1]      * (port_a.T-T[1]);
  Q_flow[nSta+1] = G[nSta+1] * (T[nSta]-port_b.T);
  for i in 2:nSta loop
    Q_flow[i]=G[i]*(T[i-1]-T[i]);
    // Q_flow[i] represents the heat flowing between two nodes
  end for;
  if material.steadyState then
    for i in 2:nSta+1 loop
      Q_flow[i]=Q_flow[1];
    end for;
  else
    for i in 1:nSta loop
        der(T[i])= (Q_flow[i]-Q_flow[i+1])/C[i];
    end for;
  end if;
  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-94,4},{92,-4}},
          lineColor={0,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{12,8},{14,8},{16,4},{18,-2},{18,-6},{16,-12},{10,-16},{6,-20},
              {-2,-22},{-6,-18},{-12,-12},{-14,-2},{-12,4},{-10,8},{-8,10},{-6,
              12},{-2,14},{2,14},{8,12},{12,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-6,-16},{2,-18},{8,-16},{14,-14},{10,-16},{6,-20},{-2,-22},{
              -8,-20},{-12,-12},{-14,-2},{-12,4},{-10,8},{-8,10},{-10,0},{-10,-8},
              {-6,-16}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,-74},{-26,-86}},
          textColor={0,0,255},
          textString="%r_a"),
        Text(
          extent={{-22,-62},{20,-76}},
          textColor={0,0,255},
          textString="%nSta"),
        Text(
          extent={{16,-76},{102,-88}},
          textColor={0,0,255},
          textString="%r_b"),
        Polygon(
          points={{-50,60},{-38,34},{-32,0},{-36,-30},{-50,-60},{-62,-60},{-48,
              -30},{-44,0},{-50,34},{-62,60},{-50,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Backward,
          fillColor={175,175,175}),
        Polygon(
          points={{52,60},{64,34},{70,0},{66,-30},{52,-60},{40,-60},{54,-30},{
              58,0},{52,34},{40,60},{52,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Backward,
          fillColor={175,175,175})}),
defaultComponentName="lay",
    Documentation(info="<html>
Model for radial heat transfer in a hollow cylinder.
<p>
If the heat capacity of the material is non-zero, then this model computes transient heat conduction, i.e., it
computes a numerical approximation to the solution of the heat equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
   &rho; c ( &part; T(r,t) &frasl; &part;t ) =
    k ( &part;&sup2; T(r,t) &frasl; &part;r&sup2; + 1 &frasl; r &nbsp;  &part; T(r,t) &frasl; &part;r ),
</p>
<p>
where
<i>&rho;</i>
is the mass density,
<i>c</i>
is the specific heat capacity per unit mass,
<i>T</i>
is the temperature at location <i>r</i> and time <i>t</i> and
<i>k</i> is the heat conductivity.
At the locations <i>r=r<sub>a</sub></i> and <i>r=r<sub>b</sub></i>,
the temperature and heat flow rate are equal to the
temperature and heat flow rate of the heat ports.
</p>
<p>
If the heat capacity of the material is set to zero, then steady-state heat flow is computed using
</p>
<p align=\"center\" style=\"font-style:italic;\">
   Q = 2 &pi; k (T<sub>a</sub>-T<sub>b</sub>)&frasl; ln(r<sub>a</sub> &frasl; r<sub>b</sub>),
</p>
<p>
where
<i>r<sub>a</sub></i> is the internal radius,
<i>r<sub>b</sub></i> is the external radius,
<i>T<sub>a</sub></i> is the temperature at port a and
<i>T<sub>b</sub></i> is the temperature at port b.
</p>
<h4>Implementation</h4>
<p>
To spatially discretize the heat equation, the construction is
divided into compartments with <code>material.nSta &ge; 1</code> state variables.
The state variables are connected to each other through thermal conductors.
There is also a thermal conductor
between the surfaces and the outermost state variables. Thus, to obtain
the surface temperature, use <code>port_a.T</code> (or <code>port_b.T</code>)
and not the variable <code>T[1]</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 27, 2019, by Michael Wetter:<br/>
Removed assertion on geometry.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1529\">issue 1529</a>.
</li>
<li>
March 9, 2012, by Michael Wetter:<br/>
Removed protected variable <code>der_T</code> as it is not required.
</li>
<li>
April 14 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleLayerCylinder;
