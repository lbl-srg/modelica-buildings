model Stratified "Model of a stratified tank for thermal energy storage" 
  extends Buildings.Fluids.Interfaces.PartialStaticTwoPortInterface;
  extends Modelica_Fluid.Interfaces.PartialInitializationParameters;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Documentation(info="<html>
<p>
This is a model of a stratified storage tank.
The tank uses several volumes to model the stratification.
Heat conduction is modeled between the volumes through the fluid,
and between the volumes and the ambient.
The port <tt>heaPorVol</tt> may be used to connect a temperature sensor
that measures the fluid temperature of an individual volume. It may also
be used to add heat to individual volumes.
</p>
<p>
The heat ports outside the tank insulation can be 
used to specify an ambient temperature.
Leave these ports unconnected to force adiabatic boundary conditions.
Note, however, that all heat conduction elements through the tank wall (but not the top and bottom) are connected to the 
heat port <tt>heaPorSid</tt>. Thus, not connecting
<tt>heaPorSid</tt> means an adiabatic boundary condition in the sense 
that <tt>heaPorSid.Q_flow = 0</tt>. This, however, still allows heat to flow
through the tank walls, modelled by <tt>conWal</tt>, from one fluid volume
to another one.
</p>
<p>
For a model with enhanced stratification, use
<a href=\"Modelica:Buildings.Fluids.Storage.StratifiedEnhanced\">
Buildings.Fluids.Storage.StratifiedEnhanced</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2008 by Michael Wetter:<br>
Added heat conduction.
</li>
<li>
October 23, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
Icon( Rectangle(extent=[-40,60; 40,20], style(
          color=1,
          rgbcolor={255,0,0},
          fillColor=1,
          rgbfillColor={255,0,0})),
      Rectangle(extent=[-40,-20; 40,-60], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[-76,2; -90,-2], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[0,84; -80,80], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[-76,84; -80,-2], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[82,0; 78,-86], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[0,84; -4,60], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[82,-84; 2,-88], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[6,-60; 2,-84], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[92,2; 78,-2], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Rectangle(extent=[-40,20; 40,-20], style(
          color=1,
          rgbcolor={255,0,0},
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=10)),
      Text(
        extent=[100,106; 134,74],
        style(color=74, rgbcolor={0,0,127}),
        string="QLoss"),
      Rectangle(extent=[-10,10; 10,-10], style(
          color=74,
          rgbcolor={0,0,127},
          gradient=3,
          fillColor=7,
          rgbfillColor={255,255,255})),
      Rectangle(extent=[50,68; 40,-66], style(
          pattern=0,
          fillColor=6,
          rgbfillColor={255,255,0})),
      Rectangle(extent=[-40,66; -50,-68], style(
          pattern=0,
          fillColor=6,
          rgbfillColor={255,255,0})),
      Rectangle(extent=[-48,68; 50,60], style(
          pattern=0,
          fillColor=6,
          rgbfillColor={255,255,0})),
      Rectangle(extent=[-48,-60; 50,-68], style(
          pattern=0,
          fillColor=6,
          rgbfillColor={255,255,0})),
      Line(points=[26,72; 102,72; 100,72], style(
          color=42,
          rgbcolor={127,0,0},
          pattern=3)),
      Line(points=[56,6; 56,72; 58,72], style(
          color=42,
          rgbcolor={127,0,0},
          pattern=3)),
      Line(points=[22,-74; 70,-74; 70,72], style(
          color=42,
          rgbcolor={127,0,0},
          pattern=3))),     Diagram);
  parameter Modelica.SIunits.Volume VTan "Tank volume";
  parameter Modelica.SIunits.Length hTan "Height of tank (without insulation)";
  parameter Modelica.SIunits.Length dIns "Thickness of insulation";
  parameter Modelica.SIunits.ThermalConductivity kIns = 0.04 
    "Specific heat conductivity of insulation";
  parameter Integer nSeg(min=2) = 2 "Number of volume segments";
  
  MixingVolumes.MixingVolume[nSeg] vol(
    redeclare each package Medium = Medium,
    each V=VTan/nSeg,
    each nP=nP,
    each initType=initType,
    each p_start=p_start,
    each use_T_start=use_T_start,
    each T_start=T_start,
    each h_start=h_start,
    each X_start=X_start) "Tank segment" 
                              annotation (extent=[-26,-10; -6,10]);
  Sensors.EnthalpyFlowRate hA(redeclare package Medium = Medium) 
    annotation (extent=[-60,-10; -40,10]);
  Sensors.EnthalpyFlowRate[nSeg-1] hVol_flow(redeclare package Medium = Medium) 
    annotation (extent=[-22,-50; -2,-30]);
  Sensors.EnthalpyFlowRate hB(redeclare package Medium = Medium) 
    annotation (extent=[46,-42; 66,-22]);
  
public 
  BaseClasses.Buoyancy buo(
    redeclare package Medium = Medium,
    V=VTan,
    nSeg=nSeg,
    tau=tau) "Model to prevent unstable tank stratification" 
    annotation (extent=[-60,50; -40,70]);
  parameter Modelica.SIunits.Time tau=1 
    "Time constant for mixing due to temperature inversion";
  Modelica.Thermal.HeatTransfer.ThermalConductor[nSeg - 1] conFlu(
                                                                each G=conFluSeg) 
    "Thermal conductance in fluid between the segments" 
    annotation (extent=[-40,24; -26,38]);
  Modelica.Thermal.HeatTransfer.ThermalConductor[nSeg] conWal(
     each G=2*Modelica.Constants.pi*kIns*hSeg/ln((rTan+dIns)/rTan)) 
    "Thermal conductance through tank wall" 
    annotation (extent=[10,34; 20,46]);
  Modelica.Thermal.HeatTransfer.ThermalConductor conTop(
     G=conTopSeg) "Thermal conductance through tank top" 
    annotation (extent=[10,54; 20,66],rotation=0);
  Modelica.Thermal.HeatTransfer.ThermalConductor conBot(
     G=conTopSeg) "Thermal conductance through tank bottom" 
    annotation (extent=[10,14; 20,26],   rotation=0);
protected 
  constant Integer nP = 2 "Number of ports of volume";
  parameter Modelica.SIunits.Length hSeg = hTan / nSeg 
    "Height of a tank segment";
  parameter Modelica.SIunits.Area ATan = VTan/hTan 
    "Tank cross-sectional area (without insulation)";
  parameter Modelica.SIunits.Length rTan = sqrt(ATan/Modelica.Constants.pi) 
    "Tank diameter (without insulation)";
  parameter Modelica.SIunits.ThermalConductance conFluSeg = ATan*Medium.lambda_const/hSeg 
    "Thermal conductance between fluid volumes";
  parameter Modelica.SIunits.ThermalConductance conTopSeg = 1/(1/conFluSeg+1/(ATan*kIns/dIns)) 
    "Thermal conductance from center of top (or bottom) volume through tank insulation at top (or bottom)";
  
public 
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSeg] heaPorVol 
    "Heat port of fluid volumes" 
    annotation (extent=[-6,-6; 6,6]);
public 
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSid 
    "Heat port tank side (outside insulation)" 
                    annotation (extent=[50,-6; 62,6]);
  Modelica.Thermal.HeatTransfer.HeatFlowSensor heaFloSid[nSeg] 
    "Heat flow at wall of tank (outside insulation)" 
    annotation (extent=[30,34; 42,46]);
protected 
  Modelica.Blocks.Math.Sum sum1(nin=nSeg + 2) 
                                          annotation (extent=[78,42; 90,56]);
public 
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorTop 
    "Heat port tank top (outside insulation)" 
                    annotation (extent=[14,68; 26,80]);
  Modelica.Thermal.HeatTransfer.HeatFlowSensor heaFloTop 
    "Heat flow at top of tank (outside insulation)" 
    annotation (extent=[30,54; 42,66]);
public 
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorBot 
    "Heat port tank bottom (outside insulation). Leave unconnected for adiabatic condition"
                    annotation (extent=[14,-80; 26,-68]);
  Modelica.Thermal.HeatTransfer.HeatFlowSensor heaFloBot 
    "Heat flow at bottom of tank (outside insulation)" 
    annotation (extent=[30,14; 42,26]);
protected 
  Modelica.Blocks.Routing.Multiplex3 mul(
    n1=1,
    n2=nSeg,
    n3=1) annotation (extent=[62,44; 70,54]);
public 
  Modelica.Blocks.Interfaces.RealOutput Ql_flow(redeclare type SignalType = 
        Modelica.SIunits.HeatFlowRate) 
    "Heat loss of tank (positve if heat flows from to ambient)" 
    annotation (extent=[100,62; 120,82]);
  
equation 
  connect(hA.port_b, vol[1].port[1]) annotation (points=[-40,6.10623e-16; -40,
        5.55112e-16; -16,5.55112e-16],            style(color=69, rgbcolor={0,
          127,255}));
  connect(vol[nSeg].port[2], hB.port_a) annotation (points=[-16,5.55112e-16; 7,
        5.55112e-16; 7,-32; 46,-32],          style(color=69, rgbcolor={0,127,
          255}));
  connect(hB.port_b, port_b) annotation (points=[66,-32; 82,-32; 82,5.55112e-16; 
        100,5.55112e-16],                 style(color=69, rgbcolor={0,127,255}));
  for i in 1:(nSeg-1) loop
    
  connect(vol[i].port[2], hVol_flow[i].port_a) annotation (points=[-16,
          5.55112e-16; -16,-20; -28,-20; -28,-40; -22,-40],
                                                     style(color=69, rgbcolor={
          0,127,255}));
  connect(hVol_flow[i].port_b, vol[i+1].port[1]) annotation (points=[-2,-40; 6,
          -40; 6,5.55112e-16; -16,5.55112e-16],
                                    style(color=69, rgbcolor={0,127,255}));
  end for;
  connect(port_a, hA.port_a) annotation (points=[-100,5.55112e-16; -80,
        5.55112e-16; -80,6.10623e-16; -60,6.10623e-16], style(color=69,
        rgbcolor={0,127,255}));
  connect(buo.heatPort, vol.thermalPort) annotation (points=[-40,60; -16,60;
        -16,9.8],                         style(
      color=42,
      rgbcolor={191,0,0},
      pattern=0,
      fillColor=74,
      rgbfillColor={0,0,127},
      fillPattern=1));
  for i in 1:nSeg-1 loop
  // heat conduction between fluid nodes
     connect(vol[i].thermalPort, conFlu[i].port_a) annotation (points=[-16,9.8;
          -16,20; -52,20; -52,31; -40,31],
                      style(color=42, rgbcolor={191,0,0}));
    connect(vol[i+1].thermalPort, conFlu[i].port_b) annotation (points=[-16,9.8;
          -16,31; -26,31],          style(color=42, rgbcolor={191,0,0}));
  end for;
  connect(vol[1].thermalPort, conTop.port_a) annotation (points=[-16,9.8; -16,
        32; -4,32; -4,60; 10,60],           style(color=42, rgbcolor={191,0,0}));
  connect(vol.thermalPort, conWal.port_a) annotation (points=[-16,9.8; -8,10; 0,
        10; 0,40; 10,40],               style(color=42, rgbcolor={191,0,0}));
  connect(conBot.port_a, vol[nSeg].thermalPort) annotation (points=[10,20; -16,
        20; -16,9.8],  style(color=42, rgbcolor={191,0,0}));
  connect(vol.thermalPort, heaPorVol) annotation (points=[-16,9.8; -10,9.8; -10,
        10; -2.22045e-16,10; -2.22045e-16,-2.22045e-16], style(color=42,
        rgbcolor={191,0,0}));
  connect(conWal.port_b, heaFloSid.port_a) 
    annotation (points=[20,40; 30,40], style(color=42, rgbcolor={191,0,0}));
  for i in 1:nSeg loop
    
    connect(heaFloSid[i].port_b, heaPorSid) annotation (points=[42,40; 56,40; 
          56,-2.22045e-16],
                  style(color=42, rgbcolor={191,0,0}));
  end for;
  
  connect(conTop.port_b, heaFloTop.port_a) 
    annotation (points=[20,60; 30,60], style(color=42, rgbcolor={191,0,0}));
  connect(conBot.port_b, heaFloBot.port_a) 
    annotation (points=[20,20; 30,20], style(color=42, rgbcolor={191,0,0}));
  connect(heaFloTop.port_b, heaPorTop) annotation (points=[42,60; 52,60; 52,74;
        20,74], style(color=42, rgbcolor={191,0,0}));
  connect(heaFloBot.port_b, heaPorBot) annotation (points=[42,20; 44,20; 44,-74;
        20,-74], style(color=42, rgbcolor={191,0,0}));
  connect(heaFloTop.Q_flow, mul.u1[1]) annotation (points=[36,54; 50,54; 50,
        52.5; 61.2,52.5], style(color=74, rgbcolor={0,0,127}));
  connect(heaFloSid.Q_flow, mul.u2) annotation (points=[36,34; 50,34; 50,49;
        61.2,49], style(color=74, rgbcolor={0,0,127}));
  connect(heaFloBot.Q_flow, mul.u3[1]) annotation (points=[36,14; 36,10; 58,10;
        58,45.5; 61.2,45.5], style(color=74, rgbcolor={0,0,127}));
  connect(mul.y, sum1.u) annotation (points=[70.4,49; 76.8,49], style(color=74,
        rgbcolor={0,0,127}));
  connect(sum1.y, Ql_flow) annotation (points=[90.6,49; 98,49; 98,72; 110,72],
      style(color=74, rgbcolor={0,0,127}));
end Stratified;
