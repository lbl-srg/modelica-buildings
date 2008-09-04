model MassExchange 
  "Block to compute the latent heat transfer based on the Lewis number" 
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium 
    "Fluid medium model" 
      annotation (choicesAllMatching=true);
  annotation (Icon(
      Rectangle(extent=[-100,100; 100,-100], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255})),
      Text(
        extent=[-92,96; -48,54],
        string="TSur",
        style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1)),
      Text(
        extent=[-96,22; -48,-26],
        style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="XMed"),
      Text(
        extent=[-90,-66; -58,-98],
        style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="Gc"),
      Text(
        extent=[54,-20; 92,-58],
        style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="TLiq"),
      Text(
        extent=[56,28; 96,12],
        style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1),
        string="m"),
      Ellipse(extent=[72,38; 76,34], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Polygon(points=[-30,66; -36,46; -38,32; -36,26; -30,22; -20,22; -12,28;
            -10,36; -14,52; -24,84; -30,66], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Polygon(points=[10,26; 4,6; 2,-8; 4,-14; 10,-18; 20,-18; 28,-12; 30,-4;
            26,12; 16,44; 10,26], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Polygon(points=[-38,-18; -44,-38; -46,-52; -44,-58; -38,-62; -28,-62; -20,
            -56; -18,-48; -22,-32; -32,0; -38,-18], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Polygon(points=[14,-46; 8,-66; 6,-80; 8,-86; 14,-90; 24,-90; 32,-84; 34,
            -76; 30,-60; 20,-28; 14,-46], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255})),
      Polygon(points=[38,100; 32,80; 30,66; 32,60; 38,56; 48,56; 56,62; 58,70;
            54,86; 50,100; 38,100], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=3,
          rgbfillColor={0,0,255}))),
                            Diagram,
    Documentation(info="<html>
<p>
This model computes the mass transfer based on similarity laws between
the convective sensible heat transfer coefficient and the mass transfer coefficient.
</p>
<p>
Using the Lewis number which is defined as the ratio between the heat and mass
diffusion coefficients, one can obtain the ratio between convection 
heat transfer coefficient <tt>h</tt> (in W/(m^2*K)) and
mass transfer coefficient <tt>h_m</tt> (in m/s) as follows:
<pre>
  h
 --- = rho * c_p * Le^(1-n),
 h_m
</pre>
where <tt>rho</tt> is the mass density,
<tt>c_p</tt> is the specific heat capacity
of the bulk medium and <tt>n</tt> is a coefficient from the boundary layer analysis, which
is typically <tt>n=1/3</tt>.
From this equation, we can compute the water vapor mass flow rate <tt>n_A</tt> in (kg/s) as
<pre>
  n_A = (Gc) / c_p / Le^(1-n) * (X_s - X_inf),
</pre>
where <tt>Gc</tt> is the sensible heat conductivity in (W/K) and <tt>X_s</tt> and 
<tt>X_inf</tt> are the water vapor mass per unit volume in the boundary layer and in the 
bulk of the medium. In this model, <tt>X_s</tt> is the saturation water vapor pressure
corresponding to the temperature <tt>T_sur</tt> which is an input.
</p>
</html>", revisions="<html>
<ul>
<li>
August 13, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
  Modelica.Blocks.Interfaces.RealInput XInf(redeclare type SignalType = 
        Modelica.SIunits.MassFraction) "Water mass fraction of medium" 
    annotation (extent=[-140,-20; -100,20]);
  Modelica.Blocks.Interfaces.RealInput TSur(redeclare type SignalType = 
        Modelica.SIunits.Temperature) "Surface temperature" 
    annotation (extent=[-140,60; -100,100]);
  Modelica.Blocks.Interfaces.RealOutput mWat_flow(redeclare type SignalType = 
        Modelica.SIunits.MassFlowRate) "Water flow rate" 
    annotation (extent=[100,10; 120,30]);
  Modelica.Blocks.Interfaces.RealOutput TLiq(redeclare type SignalType = 
        Modelica.SIunits.Temperature) 
    "Temperature at which condensate drains from system" 
    annotation (extent=[100,-50; 120,-30]);
  Modelica.Blocks.Interfaces.RealInput Gc(redeclare type SignalType = 
        Modelica.SIunits.ThermalConductance) 
    "Signal representing the convective (sensible) thermal conductance in [W/K]"
    annotation (extent=[-140,-100; -100,-60],
                                           rotation=0);
  parameter Real Le = 1 "Lewis number (around 1 for water vapor in air)";
  parameter Real n = 1/3 
    "Exponent in bondary layer ratio, delta/delta_t = Pr^n";
public 
  Utilities.Psychrometrics.HumidityRatioPressure humRatPre 
    "Model to convert water vapor pressure into humidity ratio" 
    annotation (extent=[0,0; 20,20]);
  Utilities.Psychrometrics.DewPointTemperature TDewPoi 
    "Model to compute the water vapor pressure at the dew point" 
    annotation (extent=[-60,40; -40,60]);
  Modelica.Blocks.Math.Gain gain(k=1/cpLe) 
    "Constant to convert from heat transfer to mass transfer" 
    annotation (extent=[-80,-90; -60,-70]);
  Modelica.Blocks.Math.Product mWat "Water flow rate" 
    annotation (extent=[60,-80; 80,-60]);
  Modelica.Blocks.Math.Min min annotation (extent=[20,-60; 40,-40]);
  Modelica.Blocks.Sources.Constant zero(k=0) "Constant for zero" 
    annotation (extent=[-20,-40; 0,-20]);
  Modelica.Blocks.Math.Add delX(k2=-1, k1=1) "Humidity difference" 
    annotation (extent=[-40,-66; -20,-46]);
protected 
 parameter Medium.ThermodynamicState sta0(T=Medium.T_default,
       p=Medium.p_default);
 parameter Modelica.SIunits.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(sta0) 
    "Density, used to compute fluid volume";
 parameter Real cpLe(unit="J/kg/K") = cp * Le^(1-n);
equation 
  connect(TSur, TDewPoi.T) annotation (points=[-120,80; -80,80; -80,50; -61,50],
      style(color=74, rgbcolor={0,0,127}));
  connect(TDewPoi.p_w, humRatPre.p_w) annotation (points=[-39,50; -20,50; -20,
        17; 1,17],     style(color=3, rgbcolor={0,0,255}));
  connect(TSur, TLiq) annotation (points=[-120,80; 80,80; 80,-40; 110,-40],
      style(color=74, rgbcolor={0,0,127}));
  connect(Gc, gain.u) annotation (points=[-120,-80; -82,-80], style(color=74,
        rgbcolor={0,0,127}));
  connect(gain.y, mWat.u2) annotation (points=[-59,-80; 0,-80; 0,-76; 58,-76],
      style(color=74, rgbcolor={0,0,127}));
  connect(mWat.y, mWat_flow) annotation (points=[81,-70; 90,-70; 90,20; 110,20],
      style(color=74, rgbcolor={0,0,127}));
  connect(zero.y,min. u1) annotation (points=[1,-30; 10,-30; 10,-44; 18,-44],
      style(color=74, rgbcolor={0,0,127}));
  connect(delX.u2,XInf)  annotation (points=[-42,-62; -80,-62; -80,1.11022e-15; 
        -120,1.11022e-15], style(color=74, rgbcolor={0,0,127}));
  connect(humRatPre.XWat, delX.u1) annotation (points=[1,3; -60,3; -60,-50; -42,
        -50], style(color=3, rgbcolor={0,0,255}));
  connect(delX.y, min.u2) 
    annotation (points=[-19,-56; 18,-56], style(color=74, rgbcolor={0,0,127}));
  connect(min.y, mWat.u1) annotation (points=[41,-50; 48,-50; 48,-64; 58,-64],
      style(color=74, rgbcolor={0,0,127}));
end MassExchange;
