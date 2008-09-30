model DelayFirstOrder 
  "Delay element, approximated by a first order differential equation" 
  extends Buildings.Fluids.MixingVolumes.MixingVolume(final V=m0_flow*tau/rho0, nP=2);
  annotation (Diagram,
    Icon(
      Rectangle(extent=[-100,100; 100,-100], style(
          pattern=0,
          fillColor=7,
          rgbfillColor={255,255,255})),
      Rectangle(extent=[-72,78; 78,-46], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127})),
      Text(
        extent=[-60,22; 28,-78],
        string="tau=%tau",
        style(
          color=7,
          rgbcolor={255,255,255},
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Text(
        extent=[-26,84; 16,4],
        style(
          color=7,
          rgbcolor={255,255,255},
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1),
        string="1/s"),
      Rectangle(extent=[-130,-98; 132,-148], style(
          pattern=0,
          fillColor=7,
          rgbfillColor={255,255,255}))),
    Documentation(info="<html>
<p>
This model approximates a transport delay using a first order differential equations.
</p>
<p>
The model is essentially a mixing volume with two ports and a volume that is such
that at the nominal mass flow rate <tt>m0_flow</tt> the time constant of the volume is equal to the parameter <tt>tau</tt>.
</p>
<p>
The heat flux connector is optional, it need not be connnected.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 24 by Michael Wetter:<br>
Changed base class from <tt>Modelica_Fluid</tt> to <tt>Buildings</tt> library.
This was done to track the auxiliary species flow <tt>mC_flow</tt>.
</li>
<li>
September 4 by Michael Wetter:<br>
Fixed bug in assignment of parameter <tt>sta0</tt>. The earlier implementation
required temperature to be a state, which is not always the case.
</li>
<li>
March 17 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
  parameter Modelica.SIunits.Time tau = 60 "Time constant at nominal flow" 
     annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m0_flow(min=0) "Mass flow rate" 
     annotation(Dialog(group = "Nominal condition"));
  
protected 
   parameter Medium.ThermodynamicState sta0 = Medium.setState_pTX(T=T_start,
         p=p_start, X=X_start[1:Medium.nXi]);
   parameter Modelica.SIunits.Density rho0=Medium.density(sta0) 
    "Density, used to compute fluid volume";
end DelayFirstOrder;
